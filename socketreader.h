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

#include <QTcpSocket>
#include <QNetworkSession>
#include <time.h>

class SocketReader : public QObject
{
    Q_OBJECT

public:
    SocketReader();
    ~SocketReader();
    QByteArray *sendYtDlUrl(QString cmd);
    QByteArray *getAuthState();

private:
    QTcpSocket *sock;
    QString lastResponse;
    QNetworkSession *networkSession;
    QString lastUrl;
    QString lastDesc;

    quint16 blocksize;

};

// REMOVE THIS CLASS FOR THE 50% WORKING SYSTEM
class SubmitUrlObj : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(QString Url READ Url WRITE setUrl NOTIFY UrlChanged)

    QString submittedUrl;
public:
    Q_INVOKABLE void requestUrl(QString submittedUrl);
    Q_INVOKABLE QString getUrl();
    Q_INVOKABLE bool isAuthenticated();
};
