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
#include <httppostfield.h>
#include <httppostfieldvalue.h>
#include <httppostfieldfile.h>
#include <httpuploader.h>

// Constructor:
System::System(QObject *parent) : QObject(parent)
{
    // Data mgr:
    mDataMgr = new DataMgr(this);

    // Display:
    mDisplay = new Display(this);

    // Session:
    mSession = new Session(this);

    // Setting:
    mSetting = new Setting(this);
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
    mView.rootContext()->setContextProperty("session", mSession);
    mView.rootContext()->setContextProperty("setting", mSetting);
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
    // Generic list:
    qmlRegisterType<List>("List", 1, 0, "List");

    // From HTTP uploader lib:
    qmlRegisterUncreatableType<HttpPostField>("HttpUp", 1, 0, "HttpPostField", "Can't touch this");
    qmlRegisterType<HttpPostFieldValue>("HttpUp", 1, 0, "HttpPostFieldValue");
    qmlRegisterType<HttpPostFieldFile>("HttpUp", 1, 0, "HttpPostFieldFile");
    qmlRegisterType<HttpUploader>("HttpUp", 1, 0, "HttpUploader");

}

