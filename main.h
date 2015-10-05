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
    static void write();
    static void connect();
    static void close();
};

class SocketReader
{
public:
    SocketReader();
    virtual ~SocketReader();
    static void read();
    static void connect();
    static void close();
};

class ChatMessage
{
    std::string userName;
    std::string message;

public:
    ChatMessage();
    virtual ~ChatMessage();
private:
    static std::string getUserName();
    static void setUserName(std::string argv);
    static std::string getMessage();
    static void setMessage(std::string argv);
};


class Account
{
    std::string name;
    std::string profileUrl;
    std::string avatarUrl;
    int follows;
public:
    Account();
    virtual ~Account();
    static std::string getName();
    static void setName(std::string argv);
    static std::string getProfileUrl();
    static void setProfileUrl(std::string argv);
    static std::string getAvatarUrl();
    static void setAvatarUrl(std::string argv);
    static int getFollows();
    static void setFollows(int follows);
};

class Result
{
    std::string title;
    int viewerCount;
    timer_t startTime;
    std::string thumbnailUrl;
    std::string game;
    Account streamer;
    bool isLive;
public:
    Result();
    virtual ~Result();
    static std::string getTitle();
    static void setTitle(std::string argv);
    static int getViewerCount();
    static void setViewerCount(int views);
    static time_t getStartTime();
    static void setStarttime(time_t start);
    static std::string getThumbnailUrl();
    static void setThumbnailUrl(std::string argv);
    static std::string getGame();
    static void setGame(std::string argv);
    static Account getStreamer();
    static void setStreamer(Account acct);
    static bool getIsLive();
    static void setIsLive(bool live);
};


#endif
