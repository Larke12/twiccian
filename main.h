#ifndef MPVRENDERER_H_
#define MPVRENDERER_H_

#include <QtQuick/QQuickFramebufferObject>

#include <mpv/client.h>
#include <mpv/opengl_cb.h>
#include <mpv/qthelper.hpp>
#include <string.h>

// Wraps the opengl-cb mpv instance in a C++ option
class MpvRenderer;

class MpvObject : public QQuickFramebufferObject
{
	Q_OBJECT

	mpv::qt::Handle mpv;
	mpv_opengl_cb_context *mpv_gl;

	friend class MpvRenderer;

public:
	MpvObject(QQuickItem * parent = 0);
	virtual ~MpvObject();
	virtual Renderer *createRenderer() const;
public slots:
	void command(const QVariant& params);
	void setProperty(const QString& name, const QVariant& value);
signals:
	void onUpdate();
private slots:
	void doUpdate();
private:
	static void on_update(void *ctx);
};

class SocketWriter
{
public:
    SocketWriter();
    virtual ~SocketWriter();
    write();
    connect();
    close();
};

class SocketReader
{
public:
    SocketReader();
    virtual ~SocketReader();
    read();
    connect();
    close();
};

class ChatMessage
{
    string userName;
    string message;

public:
    ChatMessage();
    virtual ~ChatMessage();
private:
    static string getUserName();
    static void setUserName(string argv);
    static string getMessage();
    static void setMessage(string argv);
};

class Result
{
    string title;
    int viewerCount;
    timer_t startTime;
    string thumbnailUrl;
    string game;
    Account streamer;
    bool isLive;
public:
    Result();
    virtual ~Result();
    static string getTitle();
    static void setTitle(string argv);
    // TODO: Add more methods
};

class Account
{
    string name;
    string profileUrl;
    string avatarUrl;
    int follows;
public:
    Account();
    virtual ~Account();
    static string getName();
    static void setName(string argv);
    // TODO: Add more methods
};


#endif
