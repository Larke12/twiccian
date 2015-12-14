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
#include <QQmlContext>
#include <QNetworkSession>
#include <QSettings>
#include "account.h"
#include "result.h"
#include "main.h"
#include <time.h>

class SocketReader : public QObject
{
    Q_OBJECT

public:
    SocketReader();
    ~SocketReader();
    QByteArray *sendYtDlUrl(QString cmd);
    QByteArray *searchStreams(QString query);
    QByteArray *getFollowing();
    QByteArray *getAuthState();
    QByteArray *changeChat(QString username);

private:
    QTcpSocket *sock;
    QString lastResponse;
    QNetworkSession *networkSession;
    QString lastUrl;
    QString lastDesc;

    quint16 blocksize;

};

class SubmitUrlObj : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> results READ getResults)
    Q_PROPERTY(QObject* streamer READ getStreamer)
    Q_PROPERTY(QObject* user READ getUser)

    QString submittedUrl;
private:
    Account* streamer;
    Account* user;
    Result* curResult;
    QList<QObject*> results;
    QList<QObject*> searches;
    QQmlContext *context;
public:
    Q_INVOKABLE void requestUrl(QString submittedUrl);
    Q_INVOKABLE void changeChat(QString username);
    Q_INVOKABLE void requestFollowing();
    Q_INVOKABLE void requestStreamSearch(QString query);
    Q_INVOKABLE QString getUrl();
    Q_INVOKABLE QList<QObject*> getResults();
    Q_INVOKABLE QList<QObject*> getSearches();
    Q_INVOKABLE QObject* getStreamer();
    Q_INVOKABLE QObject* getResult();
    Q_INVOKABLE void setResult(int index, int list);
    Q_INVOKABLE void setStreamer(int index);
    Q_INVOKABLE void setStreamerSearch(int index);
    Q_INVOKABLE QObject* getUser();
    Q_INVOKABLE void setContext(QQmlContext *ctxt);
    Q_INVOKABLE bool isAuthenticated();
    Q_INVOKABLE bool isLightTheme();
};
