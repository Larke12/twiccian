// This file is part of Twiccian.
// 
// Twiccian is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Twiccian is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Twiccian.  If not, see <http://www.gnu.org/licenses/>.

#include "main.h"
#include "socketreader.h"

#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <fcntl.h>

#include <stdexcept>
#include <clocale>
#include <string>

#include <QObject>
#include <QtGlobal>
#include <QOpenGLContext>
#include <QGuiApplication>

#include <QtGui/QOpenGLFramebufferObject>

#include <QtQuick/QQuickWindow>
#include <QtQuick/QQuickView>
#include <QQmlApplicationEngine>


class MpvRenderer : public QQuickFramebufferObject::Renderer
{
    static void *get_proc_address(void *ctx, const char *name) {
        (void)ctx;
        QOpenGLContext *glctx = QOpenGLContext::currentContext();
        if (!glctx)
            return NULL;
        return (void *)glctx->getProcAddress(QByteArray(name));
    }

    mpv::qt::Handle mpv;
    QQuickWindow *window;
    mpv_opengl_cb_context *mpv_gl;
public:
    // Create mpv opengl-cb instance
    MpvRenderer(const MpvObject *obj)
        : mpv(obj->mpv), window(obj->window()), mpv_gl(obj->mpv_gl)
    {
        int r = mpv_opengl_cb_init_gl(mpv_gl, NULL, get_proc_address, NULL);
        if (r < 0)
            throw std::runtime_error("Could not initialize mpv video renderer");
    }

    // Destroys the mpv renderer
    virtual ~MpvRenderer()
    {
        // Until this call is done, we need to make sure the player remains
        // alive. This is done implicitly with the mpv::qt::Handle instance
        // in this class.
        mpv_opengl_cb_uninit_gl(mpv_gl);
    }

    void render()
    {
        QOpenGLFramebufferObject *fbo = framebufferObject();
        window->resetOpenGLState();
        mpv_opengl_cb_draw(mpv_gl, fbo->handle(), fbo->width(), fbo->height());
        window->resetOpenGLState();
    }
};

MpvObject::MpvObject(QQuickItem * parent)
    : QQuickFramebufferObject(parent), mpv_gl(0)
{
    mpv = mpv::qt::Handle::FromRawHandle(mpv_create());
    if (!mpv)
        throw std::runtime_error("could not create mpv context");

    mpv_set_option_string(mpv, "terminal", "yes");
    mpv_set_option_string(mpv, "msg-level", "all=v");

    if (mpv_initialize(mpv) < 0)
        throw std::runtime_error("could not initialize mpv context");

    // Make use of the MPV_SUB_API_OPENGL_CB API.
    mpv::qt::set_option_variant(mpv, "vo", "opengl-cb");

    // Request hw decoding, just for testing.
    mpv::qt::set_option_variant(mpv, "hwdec", "auto");

    // Setup the callback that will make QtQuick update and redraw if there
    // is a new video frame. Use a queued connection: this makes sure the
    // doUpdate() function is run on the GUI thread.
    mpv_gl = (mpv_opengl_cb_context *)mpv_get_sub_api(mpv, MPV_SUB_API_OPENGL_CB);
    if (!mpv_gl)
        throw std::runtime_error("OpenGL not compiled in");
    mpv_opengl_cb_set_update_callback(mpv_gl, MpvObject::on_update, (void *)this);
    connect(this, &MpvObject::onUpdate, this, &MpvObject::doUpdate,
            Qt::QueuedConnection);
}

MpvObject::~MpvObject()
{
    if (mpv_gl)
        mpv_opengl_cb_set_update_callback(mpv_gl, NULL, NULL);
}

void MpvObject::on_update(void *ctx)
{
    MpvObject *self = (MpvObject *)ctx;
    emit self->onUpdate();
}

// connected to onUpdate(); signal makes sure it runs on the GUI thread
void MpvObject::doUpdate()
{
    update();
}

void MpvObject::command(const QVariant& params)
{
    mpv::qt::command_variant(mpv, params);
}

void MpvObject::setProperty(const QString& name, const QVariant& value)
{
    mpv::qt::set_property_variant(mpv, name, value);
}

QQuickFramebufferObject::Renderer *MpvObject::createRenderer() const
{
    window()->setPersistentOpenGLContext(true);
    window()->setPersistentSceneGraph(true);
    return new MpvRenderer(this);
}


int main(int argc, char **argv)
{    
    bool daemon_running = false;

    // Store the current working directory for the qt application
    char cwd[1024];
    getcwd(cwd, sizeof(cwd));

    // Check if the daemon is running or not
    chdir("/proc");
    DIR* procdir = opendir("/proc");
    struct dirent *dent;

    // Loop through all the directories in /proc
    while ((dent = readdir(procdir))) {
        // if the directory is a proccess id, search it
        int pid = strtol(dent->d_name, NULL, 10);
        if (pid != 0) {
            // Enter the directory and read the cmdline entry
            chdir(dent->d_name);
            char cmdline[1024];
            int fd = open ("cmdline", O_RDONLY);
            int len = read(fd, cmdline, (sizeof cmdline)-1);
            cmdline[len] = '\0';
            close(fd);

            // If the command is twicciand, we found our match; break out
            if (strncmp(cmdline, "twicciand", 9) == 0) {
                daemon_running = true;
                printf("Daemon is already running!\n");
                break;
            }
            chdir("/proc");
        }
    }
    closedir(procdir);

    // Run the daemon if necessary
    if (!daemon_running) {
        // First, fork the daemon
        pid_t pid = fork();

        // Check for forking error
        if (pid < 0) {
            perror("Could not create new process to run the daemon");
            exit(-1);
        } else if (pid == 0) {
            // Unset the umask
            umask(0);

            // Create a new process group for the child
            pid_t sid = setsid();

            if (sid < 0) {
                perror("Couldn't create new process group for the daemon");
                exit(-1);
            } else {
                int ret = execlp("twicciand", "twicciand", NULL);
                if (ret < 0) {
                    perror("Couldn't run daemon");
                    exit(-1);
                }
            }
        }
    }

    // Return to the qt application's working directory
    chdir(cwd);

    QGuiApplication app(argc, argv);
    // TODO: Add user input for stream URL
    // Convert url using youtube-dl and send to main.qml

    // Qt sets the locale in the QGuiApplication constructor, but libmpv
    // requires the LC_NUMERIC category to be set to "C", so change it back.
    std::setlocale(LC_NUMERIC, "C");

    // Register the custom type MpvObject to use in our qml
    qmlRegisterType<MpvObject>("twiccian", 1, 0, "MpvObject");
    qmlRegisterType<SubmitUrlObj>("twiccian", 1, 0, "Api");

    // Render the qml using a QQmlApplicationEngine
    QQmlApplicationEngine engine("main.qml");

    return app.exec();
}
