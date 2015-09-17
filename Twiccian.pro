QT += qml quick

HEADERS += main.h
SOURCES += main.cpp

QT_CONFIG -= no-pkg-config
CONFIG += link_pkgconfig debug
PKGCONFIG += mpv

RESOURCES += qml.qrc

OTHER_FILES += main.qml

qml.path = $${OUT_PWD}/
qml.files = *.qml

INSTALLS += qml
