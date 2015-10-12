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

class Account
{
    std::string name;
    std::string profileUrl;
    std::string avatarUrl;
    int follows;
public:
    Account();
    virtual ~Account();
    static std::string getName();
    static void setName(std::string argv);
    static std::string getProfileUrl();
    static void setProfileUrl(std::string argv);
    static std::string getAvatarUrl();
    static void setAvatarUrl(std::string argv);
    static int getFollows();
    static void setFollows(int follows);
};