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
#include <QString>
#include <QDateTime>
#include <QObject>
#include "account.h"

class Result : public QObject
{
    Q_OBJECT

private:
    QString title;
    qint16 viewerCount;
    QDateTime startTime;
    QString thumbnailUrl;
    QString game;
    Account* streamer;
    bool isLive;
public:
    Result(QString title, qint16 viewerCount, QDateTime startTime, QString thumbnailUrl, QString game, Account* streamer, bool isLive);
    virtual ~Result();
    QString getTitle();
    void setTitle(QString argv);
    qint16 getViewerCount();
    void setViewerCount(qint16 views);
    QDateTime getStartTime();
    void setStartTime(QDateTime start);
    QString getThumbnailUrl();
    void setThumbnailUrl(QString argv);
    QString getGame();
    void setGame(QString argv);
    Account* getStreamer();
    void setStreamer(Account* acct);
    bool getIsLive();
    void setIsLive(bool live);
};
