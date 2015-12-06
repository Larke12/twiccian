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

#include <iostream>
#include <string>
#include "account.h"

class Result : public QObject
{
    Q_OBJECT

    QString title;
    qint16 viewerCount;
    QDateTime startTime;
    QString thumbnailUrl;
    QString game;
    Account streamer;
    bool isLive;
public:
    Result();
    virtual ~Result();
    static QString getTitle();
    static void setTitle(QString argv);
    static qint16 getViewerCount();
    static void setViewerCount(qint16 views);
    static QDateTime getStartTime();
    static void setStartTime(QDateTime start);
    static QString getThumbnailUrl();
    static void setThumbnailUrl(QString argv);
    static QString getGame();
    static void setGame(QString argv);
    static Account getStreamer();
    static void setStreamer(Account acct);
    static bool getIsLive();
    static void setIsLive(bool live);
};
