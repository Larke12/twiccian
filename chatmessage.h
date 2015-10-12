#include <iostream>
#include <string>

class ChatMessage
{
    std::string userName;
    std::string message;

public:
    ChatMessage();
    virtual ~ChatMessage();
private:
    static std::string getUserName();
    static void setUserName(std::string argv);
    static std::string getMessage();
    static void setMessage(std::string argv);
};
