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

#include "account.h"

Account::Account() {
    this->name = "nope";
    this->profileUrl = "nope";
    this->avatarUrl = "nope";
    this->follows = -1;
}

Account::Account(QString name, QString profileUrl, QString avatarUrl, qint16 follows) {
    this->name = name;
    this->profileUrl = profileUrl;
    this->avatarUrl = avatarUrl;
    this->follows = follows;
}

QString Account::getName() {
    return name;
}

void Account::setName(QString argv) {
    this->name = argv;
}

QString Account::getProfileUrl() {
    return profileUrl;
}

QUrl Account::getProfileUrlAsUrl() {
    return QUrl(profileUrl);
}

void Account::setProfileUrl(QString argv) {
    this->profileUrl = argv;
}

QString Account::getAvatarUrl() {
    return avatarUrl;
}

void Account::setAvatarUrl(QString argv) {
    this->avatarUrl = argv;
}

qint16 Account::getFollows() {
    return follows;
}

void Account::setFollows(qint16 follows) {
    this->follows = follows;
}
