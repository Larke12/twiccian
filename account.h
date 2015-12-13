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

#ifndef ACCOUNT_H
#define ACCOUNT_H

#include <iostream>
#include <QString>
#include <QDateTime>
#include <QObject>
#include <QUrl>

class Account : public QObject
{
    Q_OBJECT

    QString name;
    QString profileUrl;
    QString avatarUrl;
    qint16 follows;
public:
    Account();
    Account(QString name, QString profileUrl, QString avatarUrl, qint16 follows);
    Q_INVOKABLE QString getName();
    void setName(QString argv);
    Q_INVOKABLE QString getProfileUrl();
    Q_INVOKABLE QUrl getProfileUrlAsUrl();
    void setProfileUrl(QString argv);
    Q_INVOKABLE QString getAvatarUrl();
    void setAvatarUrl(QString argv);
    Q_INVOKABLE qint16 getFollows();
    void setFollows(qint16 follows);
};

#endif // ACCOUNT_H
