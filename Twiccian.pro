QT += qml quick

HEADERS += main.h socketreader.h socketwriter.h account.h chatmessage.h result.h
SOURCES += main.cpp socketreader.cpp socketwriter.cpp account.cpp chatmessage.cpp result.cpp

QT_CONFIG -= no-pkg-config
CONFIG += link_pkgconfig debug
PKGCONFIG += mpv

RESOURCES += qml.qrc

OTHER_FILES += main.qml

qml.path = $${OUT_PWD}/
qml.files = *.qml

INSTALLS += qml
