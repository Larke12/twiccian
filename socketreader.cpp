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

// REMOVE THESE METHODS FOR 50% WORKING SYSTEM
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

