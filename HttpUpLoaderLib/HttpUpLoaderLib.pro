TEMPLATE = lib

QT -= gui
QT += qml quick network

DEFINES += HTTPUPLOADERLIB_LIBRARY

SOURCES += \
    httppostfield.cpp \
    httppostfieldfile.cpp \
    httppostfieldvalue.cpp \
    httpuploader.cpp \
    httpuploaderdevice.cpp

HEADERS +=\
    httpuploaderlib_global.h \
    httppostfield.h \
    httppostfieldfile.h \
    httppostfieldvalue.h \
    httpuploader.h \
    httpuploaderdevice.h

CONFIG(debug, debug|release) {
    TARGET = httpuploaderlibd
} else {
    TARGET = httpuploaderlib
}

unix {
    DESTDIR = ../bin
    MOC_DIR = ../moc
    OBJECTS_DIR = ../obj
}
win32 {
    DESTDIR = ..\\bin
    MOC_DIR = ..\\moc
    OBJECTS_DIR = ..\\obj
}

unix {
    QMAKE_CLEAN *= $$DESTDIR/*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR/*$$TARGET*
    QMAKE_CLEAN *= $$OBJECTS_DIR/*$$TARGET*
}

win32 {
    QMAKE_CLEAN *= $$DESTDIR\\*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR\\*$$TARGET*
    QMAKE_CLEAN *= $$OBJECTS_DIR\\*$$TARGET*
}

