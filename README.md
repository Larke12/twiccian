# Twiccian (1.0)

## Project Description
Twiccian is a native desktop app written for Linux to allow the user to watch [Twitch.tv](http://twitch.tv) streams without the use of Flash. Twitch.tv is a very common platform for streaming games and speedruns, but suffers from the fact that the web player and chat are built on Flash, seriously impacting the battery life and system usage of many computers. Twiccian also plans to allow for local notifications and design features to remove the need for a browser and certain extentions/plugins.

Of course, as cosmic irony would deem, shortly after we conceived this project, Twitch switched to HTML5. Still, we're doing this because we want to, and because our grades depend on it.

![screenshot](http://i.imgur.com/QYOGRsn.png?1)

## How it's created
Twiccian is built using Qt as the library/framework. The user-facing side
of it will be written in a combination of C++ and QML, Qt's markup
language used to facilitate easy creation of application interfaces.

Twiccian currently has a [background daemon](https://github.com/octotep/twicciand), written in Go, to allow for a quick background interface with Twitch, which enables us to act as an intermediary between the Twitch API and the front-end of the application, since Go makes concurrency and networking simple.

We currently make use of Twitch chat's [IRC bridge](http://help.twitch.tv/customer/portal/articles/1302780-twitch-irc),
as well as their [REST API](https://github.com/justintv/twitch-api) and [TMI](https://tmi.twitch.tv/group/user/usernamehere/chatters) to recreate the chat in a native fashion.


## Installation
Currently, Twiccian has a package on the AUR, though there's a chance we might break something before 1.0. ;)

It can be found on the AUR under the name:
```
twiccian
```

## Dependencies
Twiccian requires the following libraries to run:
- mpv
- Qt 5
- youtube-dl
- rapidjson
- Go

They can be installed from pacman (recommended you use pacaur or similar):
``` 
$ sudo pacman -S qt5-base qt5-quickcontrols qt5-webengine qt5-webkit qt5-graphicaleffects mpv rapidjson youtube-dl git go
```

You'll also need to install the following go packages:
```
go get "github.com/walle/cfg"
go get "github.com/gorilla/handlers"
go get "github.com/gorilla/websocket"
go get "github.com/sorcix/irc"
```

At the moment, we don't have an official way to actually _install_ it, so if you want to use it, the above AUR package is probably your best bet. If you want to clone this repo instead, install the depencencies for Twiccian and twicciand as mentioned and run the following (in the Twiccian directory) after successfuly building twicciand. You will have to run `qmake` multiple times if you are missing dependencies.
```
$ qmake
$ make
```

Now that both parts of Twiccian have been built, the next part either works or needs to be worked around. Run `./twicciand` where it was built and follow the instructions from there. If you hit a 404, navigate to `~/.config/twicciand/twicciand.config` and add the following to the file:
```
user= [your username]
token= [copy the token code that appears between #access_token= and the following & in your browser]
```

Copy the two HTML files from the `assets` folder to `/usr/share/twiccian` and then restart `twicciand`. If the daemon runs without saying you have no token/errors, head over to where you built Twiccian and run the application!
```
$ ./Twiccian
```

## Known Issues
A lot of this should be automated, but sometimes it doesn't work. If we ever come back to this application, expect these to be fixed.

* The daemon doesn't always write to the files or make the directories.
* Twiccian will have segmentation faults and rapidjson errors after any action.

## Other Documentation
At the moment, all other documentation can be found on our [wiki](https://github.com/octotep/twiccian/wiki), though it's in a state of flux right now.

