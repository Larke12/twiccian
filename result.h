#include <iostream>
#include <string>
#include "account.h"

class Result
{
    std::string title;
    int viewerCount;
    time_t startTime;
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
    static void setStartTime(time_t start);
    static std::string getThumbnailUrl();
    static void setThumbnailUrl(std::string argv);
    static std::string getGame();
    static void setGame(std::string argv);
    static Account getStreamer();
    static void setStreamer(Account acct);
    static bool getIsLive();
    static void setIsLive(bool live);
};
