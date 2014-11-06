#ifndef TRACKTIK_H
#define TRACKTIK_H
#include <QObject>
#include "iservice.h"
class System;

// Main application:
class TrackTik : public QObject, public IService
{
    Q_OBJECT

public:
    // Return an instance of TrackTik:
    static TrackTik *instance();

    // Startup:
    virtual bool startup();

    // Shutdown:
    virtual void shutdown();

private:
    // Constructor:
    TrackTik(QObject *parent = 0);

private:
    // KeyManage singleton:
    static TrackTik *sTrackTik;

    // System singleton:
    System *mSystem;
};

#endif // TRACKTIK_H
