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

#include "socketreader.h"
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include <QDataStream>
#include <iostream>

using namespace rapidjson;

SocketReader::SocketReader() {
    networkSession = 0;
    // Initialize tcpSocket
    sock = new QTcpSocket(this);
    sock->connectToHost("localhost", 1921);
    sock->waitForConnected();
}

SocketReader::~SocketReader() {
   sock->abort();
}

QByteArray *SocketReader::sendYtDlUrl(QString url) {
    blocksize = 0;

    QByteArray *buffer = new QByteArray();

    if (sock->state() == QAbstractSocket::ConnectedState) {
        std::string charurl = url.toStdString();
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

        qint16 size = sock->bytesAvailable();

        buffer->append(sock->readAll());

        printf("\nThe RESULT IS: %s\n", buffer->constData());
        fflush(stdout);
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

        printf("WHAT I NEED IN MY LIFE: %s", json.c_str());

        sock->waitForReadyRead();
        QDataStream in(sock);
        in.setVersion(QDataStream::Qt_4_0);

        if (sock->bytesAvailable() < (int)sizeof(quint16)) {
            return buffer;
        }

        qint16 size = sock->bytesAvailable();

        buffer->append(sock->readAll());

        printf("\nThe IMPORTANT RESULT IS: %s\n", buffer->constData());
        fflush(stdout);
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

        qint16 size = sock->bytesAvailable();

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

    QString urlJson = "";
    urlJson.append(result->constData());
    printf("Supposed result: %s\n", urlJson.toStdString().c_str());
    fflush(stdout);

    Document json;
    json.Parse(urlJson.toStdString().c_str());
    Value& res = json["result"];
    printf("%s\n", res.GetString());
    fflush(stdout);

    QString url(res.GetString());
    this->submittedUrl = url;

    printf("TEST: %s", url.toStdString().c_str());
    fflush(stdout);
}

QString SubmitUrlObj::getUrl()
{
    // Return string to MPV Render
    return submittedUrl.trimmed();
}

bool SubmitUrlObj::isAuthenticated() {
    struct timespec tim, tim2;
    tim.tv_sec = 0;
    tim.tv_nsec = 500000000L;
    if(nanosleep(&tim , &tim2) < 0 ) {
          printf("Couldn't sleep\n");
    }
    SocketReader *reader = new SocketReader();
    QByteArray *result = reader->getAuthState();

    QString urlJson = "";
    urlJson.append(result->constData());
    printf("Supposed result: %s\n", urlJson.toStdString().c_str());
    fflush(stdout);

    Document json;
    json.Parse(urlJson.toStdString().c_str());
    Value& res = json["result"];
    printf("%s\n", res.GetBool() ? "true" : "false");
    fflush(stdout);

    return res.GetBool();
}

void SubmitUrlObj::requestFollowing() {
    // Pass string to daemon
    SocketReader *reader = new SocketReader();
    QByteArray *result = reader->getFollowing();

    QString urlJson = "";
    urlJson.append(result->constData());
    printf("Supposed result: %s\n", urlJson.toStdString().c_str());
    fflush(stdout);

    Document json;
    json.Parse(urlJson.toStdString().c_str());
    Value& res = json["_total"];
    printf("%d\n", res.GetInt());
    fflush(stdout);

    int total = res.GetInt();

    printf("TEST: %d", total);
    fflush(stdout);
}

QObject* SubmitUrlObj::getStreamer() {
    return streamer;
}

QObject* SubmitUrlObj::getUser() {
    return user;
}

QList<QObject*> SubmitUrlObj::getResults() {
    return results;
}

