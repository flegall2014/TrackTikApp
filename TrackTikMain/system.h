#ifndef SYSTEM_H
#define SYSTEM_H
#include <QObject>
#include <QQuickView>
#include "iservice.h"
class Session;
class Setting;
class DataMgr;
class Display;

// System singleton:
class System : public QObject, public IService
{
    Q_OBJECT
    friend class TrackTik;

public:
    // Startup:
    virtual bool startup();

    // Shutdown:
    virtual void shutdown();

    // Get setting:
    inline Setting *getSetting() const
    {
        return mSetting;
    }

    // Get session:
    inline Session *getSession() const
    {
        return mSession;
    }

private:
    // Constructor:
    System(QObject *parent=0);

    // Destructor:
    virtual ~System() {

    }

    // Register types for QML:
    void registerTypes();

private:
    // Main view:
    QQuickView mView;

    // Data mgr:
    DataMgr *mDataMgr;

    // Display:
    Display *mDisplay;

    // Session:
    Session *mSession;

    // Setting:
    Setting *mSetting;
};

#endif // SYSTEM_H
