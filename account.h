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
