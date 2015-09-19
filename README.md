# Twiccian

## Project Description
Twiccian is, or will be, a native app written for Linux to allow the user
to watch [Twitch.tv](https://twitch.tv) streams without the use of Flash.
Twitch.tv is a very common platform for streaming games and speedruns, but
suffers from the fact that the web player and chat are built on Flash,
seriously impacting the battery life and system usage of many computers.


## How it's created
Twiccian is built using Qt as the library/framework. The user-facing side
of it will be written in a combination of C++ and QML, Qt's markup
language used to facilitate easy creation of application interfaces.

Twiccian will also have a background daemon, written in Go, to allow for
a quick background interface with Twitch, which should enable us to
provide features like notifications, as well as to act as an intermediary
between Twitch chat and the front-end of the application, since Go makes
concurrency and networking simple.

We plan to make use of Twitch chat's [IRC
bridge](http://help.twitch.tv/customer/portal/articles/1302780-twitch-irc),
as well as Twitch's [REST API](https://github.com/justintv/twitch-api) to recreate the chat in a native fashion.


## Dependencies
Twiccian requires the [mpv](http://mpv.io/) library to render and stream video, so that
should be installed.

It can be installed from pacman:
``` 
pacman -S mpv
```

At the moment, Twiccian currently does not fetch stream urls itself, so it
only plays the one it was compiled with. In order to generate a compatible
url to stream, it's currently necessary to feed the desired Twitch url
into [youtube-dl](https://rg3.github.io/youtube-dl/).

It can be installed from pacman:
```
pacman -S youtube-dl
```

And the stream url can be generated like so:
```
youtube-dl -g url
```


## Other Documentation
At the moment, all other documentation can be found on our
[wiki](https://github.com/octotep/twiccian/wiki), though it's in a state
of flux right now.
