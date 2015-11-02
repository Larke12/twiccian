QT += qml quick

HEADERS += main.h socketreader.h account.h chatmessage.h result.h
SOURCES += main.cpp socketreader.cpp account.cpp chatmessage.cpp result.cpp

QT_CONFIG -= no-pkg-config
CONFIG += link_pkgconfig debug
PKGCONFIG += mpv

RESOURCES += qml.qrc

OTHER_FILES += main.qml

qml.path = $${OUT_PWD}/
qml.files = *.qml

assets.path = $${OUT_PWD}/assets
assets.files = $${PWD}/assets/*

INSTALLS += qml assets
