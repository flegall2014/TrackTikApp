#-------------------------------------------------
#
# Project created by QtCreator 2014-10-27T19:15:16
#
#-------------------------------------------------
TEMPLATE = app

QT += qml quick widgets sql script

SOURCES += \
    database.cpp \
    main.cpp \
    session.cpp \
    setting.cpp \
    system.cpp \
    tracktik.cpp \
    json.cpp \
    datamgr.cpp \
    field.cpp \
    form.cpp

HEADERS += \
    database.h \
    iservice.h \
    session.h \
    setting.h \
    system.h \
    tracktik.h \
    utils.h \
    json.h \
    datamgr.h \
    field.h \
    list.h \
    form.h \
    display.h

CONFIG(debug, debug|release) {
    TARGET = tracktikd
} else {
    TARGET = tracktik
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

RESOURCES += \
    resources.qrc
