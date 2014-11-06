#include "system.h"
#include <qqml.h>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickItem>
#include "session.h"
#include "setting.h"
#include "datamgr.h"
#include "list.h"
#include "display.h"

// Constructor:
System::System(QObject *parent) : QObject(parent)
{
    // Data mgr:
    mDataMgr = new DataMgr(this);

    // Display:
    mDisplay = new Display(this);
}

// Startup:
bool System::startup()
{
    // Start data mgr:
    if (!mDataMgr->startup())
        return false;

    // Register types:
    registerTypes();

    // Make session, setting & dataMgr visible everywhere in QML:
    Session session;
    Setting setting;
    mView.rootContext()->setContextProperty("session", &session);
    mView.rootContext()->setContextProperty("setting", &setting);
    mView.rootContext()->setContextProperty("dataMgr", mDataMgr);
    mView.rootContext()->setContextProperty("display", mDisplay);

    // Set QML source:
    mView.setSource(QUrl("qrc:/qml/main/main.qml"));

    // Set resize mode:
    mView.setResizeMode(QQuickView::SizeRootObjectToView);

    // Show maximized:
    mView.resize(1024, 748);
    mView.show();

    return true;
}

// Shutdown:
void System::shutdown()
{
    mDataMgr->shutdown();
}

// Register types:
void System::registerTypes()
{
    qmlRegisterType<List>("List", 1, 0, "List");
}

