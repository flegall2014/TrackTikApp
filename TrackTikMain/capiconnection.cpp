#include "capiconnection.h"
#include "tracktik.h"
#include "system.h"
#include "httpuploader.h"
#include "capihandler.h"
#include "json.h"
#include "setting.h"
#include "session.h"

// Constructor:
CAPIConnection::CAPIConnection(QObject *parent) :
    QObject(parent), mSystem(TrackTik::instance()->getSystem()), mHandler(0),
    mAPICall("")
{
    mHttpUploader = new HttpUploader(this);
    setupConnections();
}

// Add field:
void CAPIConnection::addField(const QString &fieldName, const QVariant &fieldValue)
{
    mHttpUploader->addField(fieldName, fieldValue.toString());
}

// Add file:
void CAPIConnection::addFile(const QString &fieldName, const QString &fileName)
{
    mHttpUploader->addFile(fieldName, fileName);
}

// Call the connection:
void CAPIConnection::call(const QString &url)
{
    QString toUse = url;
    if (toUse.isEmpty())
        toUse = mSystem->getSetting()->get("server_url").toString();

    // Get server url:
    QString fullUrl = toUse + "/api/" + mAPICall;
    mHttpUploader->open(fullUrl);

    // Before submit:
    beforeSubmit();

    // Send:
    mHttpUploader->send();
}

// Setup connections:
void CAPIConnection::setupConnections()
{
    connect(mHttpUploader, SIGNAL(progressChanged()), SLOT(onProgressChanged()), Qt::UniqueConnection);
    connect(mHttpUploader, SIGNAL(stateChanged()), SLOT(onStateChanged()), Qt::UniqueConnection);
    connect(mHttpUploader, SIGNAL(networkErrorChanged()), SLOT(onNetworkErrorChanged()), Qt::UniqueConnection);
}

// Before submit:
void CAPIConnection::beforeSubmit()
{
    mHttpUploader->addField("__device_account_id", mSystem->getSetting()->get("DEVICE_ACCOUNT_ID").toString());
    mHttpUploader->addField("__device_id", mSystem->getSetting()->get("DEVICE_ID").toString());
    mHttpUploader->addField("“__token”", mSystem->getSetting()->get("API_TOKEN").toString());
}

// Progress changed:
void CAPIConnection::onProgressChanged()
{
    if (!mHandler)
        return;
    mHandler->onProgressChanged(mHttpUploader->progress());
}

// State changed:
void CAPIConnection::onStateChanged()
{
    if (!mHandler)
        return;

    // HTTP loader done:
    if (mHttpUploader->state() == HttpUploader::Done)
        if (mHttpUploader->status() == HttpUploader::OK)
        {
            QString jsonString = mHttpUploader->responseText();
            QVariantMap jsonObject = JSON::instance().parse(jsonString);

            // API Error?
            if (jsonObject["name"] == "api.error")
                mHandler->onAPIError(jsonString);
            else
                mHandler->onSuccess(jsonString);
        }
}

// Network error changed:
void CAPIConnection::onNetworkErrorChanged()
{
    if (!mHandler)
        return;
    mHandler->onNetworkError(mHttpUploader->networkError());
}
