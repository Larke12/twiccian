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
#include <QString>
#include <QDateTime>

class Account : public QObject
{
    Q_OBJECT

    QString name;
    QString profileUrl;
    QString avatarUrl;
    qint16 follows;
public:
    Account();
    virtual ~Account();
    static QString getName();
    static void setName(QString argv);
    static QString getProfileUrl();
    static void setProfileUrl(QString argv);
    static QString getAvatarUrl();
    static void setAvatarUrl(QString argv);
    static qint16 getFollows();
    static void setFollows(qint16 follows);
};
