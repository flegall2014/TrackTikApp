#include "capiconnection.h"
#include "tracktik.h"
#include "system.h"
#include "httpuploader.h"
#include "capihandler.h"
#include "json.h"
#include "setting.h"
#include "session.h"
#include "utils.h"

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
    // Back to Unsent state:
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
    connect(mHttpUploader, SIGNAL(errorTypeChanged()), SLOT(onErrorTypeChanged()), Qt::UniqueConnection);
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
    {
        QString jsonString = mHttpUploader->response();
        if (!jsonString.simplified().isEmpty())
        {
            QVariantMap jsonObject = JSON::instance().parse(jsonString);

            // Make sure we got a valid TrackTik notification:
            if (jsonObject.contains("name"))
            {
                QString name = Utils::getKey(jsonObject["name"].toString());

                // API Error?
                if (name == "api.error")
                    mHandler->onError(CAPIHandler::ApiError, jsonString);
                else
                if (name == "success")
                    mHandler->onSuccess(jsonString);
            }
        }
    }
}

// Network error changed:
void CAPIConnection::onErrorTypeChanged()
{
    if (!mHandler)
        return;
    mHandler->onError((CAPIHandler::ErrorType)mHttpUploader->errorType(), mHttpUploader->errorString());
}
