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
    Q_PROPERTY(QString title READ getTitle WRITE setTitle)
    Q_PROPERTY(qint16 viewerCount READ getViewerCount WRITE setViewerCount)
    Q_PROPERTY(QDateTime startTime READ getStartTime WRITE setStartTime)
    Q_PROPERTY(QString thumbnailUrl READ getThumbnailUrl WRITE setThumbnailUrl)
    Q_PROPERTY(QString game READ getGame WRITE setGame)
    Q_PROPERTY(Account* streamer READ getStreamer WRITE setStreamer)
    Q_PROPERTY(bool isLive READ getIsLive WRITE setIsLive)

private:
    QString title;
    qint16 viewerCount;
    QDateTime startTime;
    QString thumbnailUrl;
    QString game;
    Account* streamer;
    bool isLive;
public:
    Result();
    Result(QString title, qint16 viewerCount, QDateTime startTime, QString thumbnailUrl, QString game, Account* streamer, bool isLive);
    virtual ~Result();
    Q_INVOKABLE QString getTitle();
    void setTitle(QString argv);
    Q_INVOKABLE qint16 getViewerCount();
    void setViewerCount(qint16 views);
    Q_INVOKABLE QDateTime getStartTime();
    void setStartTime(QDateTime start);
    Q_INVOKABLE QString getThumbnailUrl();
    void setThumbnailUrl(QString argv);
    Q_INVOKABLE QString getGame();
    void setGame(QString argv);
    Q_INVOKABLE Account* getStreamer();
    void setStreamer(Account* acct);
    Q_INVOKABLE bool getIsLive();
    void setIsLive(bool live);
};
