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

#define TIMEOUT 5000

#include "socketreader.h"
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include <QDataStream>
#include <QList>
#include <iostream>

using namespace rapidjson;

SocketReader::SocketReader() {
    networkSession = 0;
    // Initialize tcpSocket
    sock = new QTcpSocket(this);
    sock->connectToHost("localhost", 1921);
    sock->waitForConnected(TIMEOUT);
}

SocketReader::~SocketReader() {
   sock->abort();
}

QByteArray *SocketReader::sendYtDlUrl(QString url) {
    blocksize = 0;

    QByteArray *buffer = new QByteArray();

    if (sock->state() == QAbstractSocket::ConnectedState) {
        //printf("MADE IT: %s\n", url.toStdString().c_str());
        fflush(stdout);
        std::string charurl = url.trimmed().toStdString();
        std::string json = " { \"api\":\"local\",\"name\":\"getStreamUrl\",\"params\":{\"url\":\"" + charurl + "\"}}";
        sock->write(json.c_str(), json.length());
        sock->waitForBytesWritten();

        printf("%s", json.c_str());

        sock->waitForReadyRead();
        QDataStream in(sock);
        in.setVersion(QDataStream::Qt_4_0);

        if (sock->bytesAvailable() < (int)sizeof(quint16)) {
            return buffer;
        }

        //qint16 size = sock->bytesAvailable();

        buffer->append(sock->readAll());

        printf("\nThe RESULT IS: %s\n", buffer->constData());
        fflush(stdout);
    }

    return buffer;
}

QByteArray *SocketReader::searchStreams(QString query) {
    blocksize = 0;

    QByteArray *buffer = new QByteArray();

    if (sock->state() == QAbstractSocket::ConnectedState) {
        QString fixed;
        fixed.append(QUrl::toPercentEncoding(query));
        std::string json = " { \"api\":\"twitch\",\"name\":\"searchStreams\",\"params\":{\"query\":\"" + fixed.toStdString() + "\",\"limit\":10,\"offset\":0}}";
        sock->write(json.c_str(), json.length());
        sock->waitForBytesWritten();

        sock->waitForReadyRead();
        QDataStream in(sock);
        in.setVersion(QDataStream::Qt_4_0);

        if (sock->bytesAvailable() < (int)sizeof(quint16)) {
            return buffer;
        }

        //qint16 size = sock->bytesAvailable();

        buffer->append(sock->readAll());
    }

    return buffer;
}

QByteArray *SocketReader::getFollowing() {
    blocksize = 0;

    QByteArray *buffer = new QByteArray();

    if (sock->state() == QAbstractSocket::ConnectedState) {
        std::string json = " { \"api\":\"twitch\",\"name\":\"getFollowedStreams\",\"params\":{\"limit\":10,\"offset\":0}}";
        sock->write(json.c_str(), json.length());
        sock->waitForBytesWritten();

        sock->waitForReadyRead();
        QDataStream in(sock);
        in.setVersion(QDataStream::Qt_4_0);

        if (sock->bytesAvailable() < (int)sizeof(quint16)) {
            return buffer;
        }

        //qint16 size = sock->bytesAvailable();

        buffer->append(sock->readAll());
    }

    return buffer;
}

QByteArray *SocketReader::getAuthState() {
    blocksize = 0;

    QByteArray *buffer = new QByteArray();

    if (sock->state() == QAbstractSocket::ConnectedState) {
        std::string json = " { \"api\":\"local\",\"name\":\"isAuthenticated\",\"params\":{}}";
        sock->write(json.c_str(), json.length());
        sock->waitForBytesWritten();

        printf("%s", json.c_str());

        sock->waitForReadyRead();
        QDataStream in(sock);
        in.setVersion(QDataStream::Qt_4_0);

        if (sock->bytesAvailable() < (int)sizeof(quint16)) {
            return buffer;
        }

        //qint16 size = sock->bytesAvailable();

        buffer->append(sock->readAll());

        printf("\nThe RESULT IS: %s\n", buffer->constData());
        fflush(stdout);
    }

    return buffer;
}

QByteArray *SocketReader::changeChat(QString username) {
    blocksize = 0;

    QByteArray *buffer = new QByteArray();

    if (sock->state() == QAbstractSocket::ConnectedState) {
        std::string json = " { \"api\":\"local\",\"name\":\"changeChat\",\"params\":{\"query\":\""+username.toStdString()+"\"}}";
        sock->write(json.c_str(), json.length());
        sock->waitForBytesWritten();

        printf("%s", json.c_str());

        sock->waitForReadyRead();
        QDataStream in(sock);
        in.setVersion(QDataStream::Qt_4_0);

        if (sock->bytesAvailable() < (int)sizeof(quint16)) {
            return buffer;
        }

        //qint16 size = sock->bytesAvailable();

        buffer->append(sock->readAll());

        printf("\nThe RESULT IS: %s\n", buffer->constData());
        fflush(stdout);
    }

    return buffer;
}

void SubmitUrlObj::requestUrl(QString submittedUrl)
{
    // Pass string to daemon
    SocketReader *reader = new SocketReader();
    QByteArray *result = reader->sendYtDlUrl(submittedUrl);
    //printf("I made it\n");
    fflush(stdout);

    QString urlJson = "";
    urlJson.append(result->constData());

    Document json;
    json.Parse(urlJson.toStdString().c_str());
    if (json.IsObject() && json.HasMember("result")) {
        Value& res = json["result"];
        printf("%s\n", res.GetString());
        fflush(stdout);

        QString url(res.GetString());
        this->submittedUrl = url;

        printf("TEST: %s", url.toStdString().c_str());
        fflush(stdout);
    }
}

QString SubmitUrlObj::getUrl()
{
    // Return string to MPV Render
    return submittedUrl.trimmed();
}

bool SubmitUrlObj::isAuthenticated() {
    //struct timespec tim, tim2;
    //tim.tv_sec = 0;
    //tim.tv_nsec = 500000000L;
    //if(nanosleep(&tim , &tim2) < 0 ) {
    //      printf("Couldn't sleep\n");
    //}
    SocketReader *reader = new SocketReader();
    QByteArray *result = reader->getAuthState();

    QString urlJson = "";
    urlJson.append(result->constData());
    printf("Make sure the daemon is running to surpress the rapidjson error.\nSupposed result: %s\n", urlJson.toStdString().c_str());
    fflush(stdout);

    Document json;
    json.Parse(urlJson.toStdString().c_str());
    if (json.IsObject() && !json.HasMember("result")) {
        printf("Could not check if daemon is authenticated");
        fflush(stdout);
        return false;
    } else {
        Value& res = json["result"];
        //printf("%s\n", res.GetBool() ? "true" : "false");
        fflush(stdout);

        return res.GetBool();
    }
}

bool SubmitUrlObj::isLightTheme() {
    QSettings settings;
    //bool res = settings.value("theme/checked").toBool();
    bool res = settings.value("checked").toBool();
    return res;
}

void SubmitUrlObj::requestStreamSearch(QString query) {
    // Pass string to daemon
    SocketReader *reader = new SocketReader();
    QByteArray *result = reader->searchStreams(query);

    QString responseJson = "";
    responseJson.append(result->constData());

    Document json;
    json.Parse(responseJson.toStdString().c_str());
    searches.clear();
    if (json.IsObject() && json.HasMember("result")) {
        Value& resultArr = json["result"]["streams"];
        for (uint i=0; i < resultArr.Size(); i++) {
            Result* next = new Result();
            Account* accnext = new Account();
            const Value& stream = resultArr[i];
            const Value& channel = stream["channel"];

            next->setTitle(channel["status"].GetString());
            next->setViewerCount(stream["viewers"].GetInt());
            next->setStartTime(QDateTime::fromString(stream["created_at"].GetString(),
                                                     "yyyy-MM-dd'T'hh:mm:ss'Z'"));
            next->setThumbnailUrl(stream["preview"]["medium"].GetString());
            if (stream["game"].IsNull()) {
                next->setGame("");
            } else {
                next->setGame(stream["game"].GetString());
            }
            accnext->setName(channel["name"].GetString());
            accnext->setProfileUrl(channel["url"].GetString());
            if (channel["logo"].IsNull()) {
                accnext->setAvatarUrl("http://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png");
            } else {
                accnext->setAvatarUrl(channel["logo"].GetString());
            }
            accnext->setFollows(channel["followers"].GetInt());
            next->setStreamer(accnext);
            next->setIsLive(stream["is_playlist"].GetBool());
            searches.append(next);
        }
    }

    for (int i=0; i<searches.count(); i++) {
        printf("%s\n", qobject_cast<Result*>(searches[i])->getTitle().toStdString().c_str());
    }
    context->setContextProperty("searchModel",QVariant::fromValue(getSearches()));
    fflush(stdout);
}

void SubmitUrlObj::requestFollowing() {
    // Pass string to daemon
    SocketReader *reader = new SocketReader();
    QByteArray *result = reader->getFollowing();

    QString responseJson = "";
    responseJson.append(result->constData());

    Document json;
    json.Parse(responseJson.toStdString().c_str());
    results.clear();
    if (json.IsObject() && json.HasMember("result")) {
        Value& resultArr = json["result"]["streams"];
        for (uint i=0; i < resultArr.Size(); i++) {
            Result* next = new Result();
            Account* accnext = new Account();
            const Value& stream = resultArr[i];
            const Value& channel = stream["channel"];

            next->setTitle(channel["status"].GetString());
            next->setViewerCount(stream["viewers"].GetInt());
            next->setStartTime(QDateTime::fromString(stream["created_at"].GetString(),
                                                     "yyyy-MM-dd'T'hh:mm:ss'Z'"));
            next->setThumbnailUrl(stream["preview"]["medium"].GetString());
            if (stream["game"].IsNull()) {
                next->setGame("");
            } else {
                next->setGame(stream["game"].GetString());
            }
            accnext->setName(channel["name"].GetString());
            accnext->setProfileUrl(channel["url"].GetString());
            if (channel["logo"].IsNull()) {
                accnext->setAvatarUrl("http://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png");
            } else {
                accnext->setAvatarUrl(channel["logo"].GetString());
            }
            accnext->setFollows(channel["followers"].GetInt());
            next->setStreamer(accnext);
            next->setIsLive(stream["is_playlist"].GetBool());
            results.append(next);
        }
    }

    for (int i=0; i<results.count(); i++) {
        printf("%s\n", qobject_cast<Result*>(results[i])->getTitle().toStdString().c_str());
    }
    context->setContextProperty("myModel",QVariant::fromValue(getResults()));
    fflush(stdout);
}

void SubmitUrlObj::changeChat(QString username) {
    SocketReader *reader = new SocketReader();
    QByteArray *result = reader->changeChat(username);

    QString responseJson = "";
    responseJson.append(result->constData());

}

QObject* SubmitUrlObj::getStreamer() {
    return streamer;
}

QObject* SubmitUrlObj::getResult() {
    return curResult;
}

void SubmitUrlObj::setResult(int index, int list) {
    if (list == 0) {
        this->curResult = qobject_cast<Result*>(results[index]);
    } else {
        this->curResult = qobject_cast<Result*>(searches[index]);
    }
}


void SubmitUrlObj::setStreamer(int index) {
    this->streamer = qobject_cast<Result*>(results[index])->getStreamer();
}

void SubmitUrlObj::setStreamerSearch(int index) {
    this->streamer = qobject_cast<Result*>(searches[index])->getStreamer();
}

QObject* SubmitUrlObj::getUser() {
    return user;
}

QList<QObject*> SubmitUrlObj::getSearches() {
    return searches;
}

QList<QObject*> SubmitUrlObj::getResults() {
    return results;
}

void SubmitUrlObj::setContext(QQmlContext *ctxt) {
    this->context = ctxt;
}
