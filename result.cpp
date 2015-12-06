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

#include "result.h"

Result::Result() {
	// Do stuff
}

Result::~Result() {
	// Do stuff
}

QString Result::getTitle() {
    return title;
}

void Result::setTitle(QString argv) {
    this->title = argv;
}

qint16 Result::getViewerCount() {
    return viewerCount;
}

void Result::setViewerCount(qint16 views) {
    this->viewerCount = views;
}

QDateTime Result::getStartTime() {
    return startTime;
}

void Result::setStartTime(QDateTime start) {
    this->startTime = start;
}

QString Result::getThumbnailUrl() {
    return thumbnailUrl;
}

void Result::setThumbnailUrl(QString argv) {
    this->thumbnailUrl = argv;
}

QString Result::getGame() {
    return game;
}

void Result::setGame(QString argv) {
    this->game = argv;
}

Account Result::getStreamer() {
    return streamer;
}

void Result::setStreamer(Account acct) {
    this->streamer = acct;
}

bool Result::getIsLive() {
    return isLive;
}

void Result::setIsLive(bool live) {
    this->isLive = live;
}
