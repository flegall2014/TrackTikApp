#include "httpuploader.h"
#include <QNetworkReply>
#include <QQmlEngine>
#include <QFile>
#include <QQmlNetworkAccessManagerFactory>
#include <QQmlContext>
#include "httpuploaderdevice.h"
#include "httppostfieldvalue.h"
#include "httppostfieldfile.h"

// Constructor:
HttpUploader::HttpUploader(QObject *parent) :
    QObject(parent),
    mProgress(0.0),
    mState(Unsent),
    mPendingReply(NULL),
    mUploadDevice(NULL),
    mErrorType(None),
    mErrorString("")
{
    mNetworkAccessManager = new QNetworkAccessManager(this);
}

// Destructor:
HttpUploader::~HttpUploader()
{
    if (mPendingReply)
        mPendingReply->abort();
}

// Set url:
void HttpUploader::setUrl(const QUrl& url)
{
    if (url != mUrl)
    {
        mUrl = url;
        emit urlChanged();
    }
}

// Clear:
void HttpUploader::clear()
{
    // Release reply:
    mPendingReply->deleteLater();

    // Clear post fields:
    for (int i = 0 ; i < mPostFields.size() ; ++i)
        if (mPostFields[i] && !mPostFields[i]->mInstancedFromQml)
            delete mPostFields[i];
    mPostFields.clear();

    // Clear boundary string:
    mBoundaryString.clear();

    // Delete upload device:
    if (mUploadDevice)
    {
        delete mUploadDevice;
        mUploadDevice = NULL;
    }
}

// Open:
void HttpUploader::open(const QUrl &url)
{
    if (mState != Loading)
    {
        setUrl(url);
        mState = Opened;
    } else qDebug() << "HTTPUPLOADER BUSY LOADING";
}

// Send:
void HttpUploader::send()
{
    if (mState == Opened)
    {
        // Build request:
        QNetworkRequest request(mUrl);

        // Crypting:
        QCryptographicHash hash(QCryptographicHash::Sha1);
        foreach (QPointer<HttpPostField> field, mPostFields)
            if (!field.isNull())
                hash.addData(field->name().toUtf8());

        // Build boundary string:
        mBoundaryString = "HttpUploaderBoundary" + hash.result().toHex();

        // Release upload device:
        if (mUploadDevice)
            delete mUploadDevice;

        // Setup upload device:
        mUploadDevice = new HttpUploaderDevice(this);
        mUploadDevice->open(QIODevice::ReadOnly);

        // Setup request:
        request.setHeader(QNetworkRequest::ContentTypeHeader, ((HttpUploaderDevice *)mUploadDevice)->contentType);
        request.setHeader(QNetworkRequest::ContentLengthHeader, mUploadDevice->size());

        // Create pending reply:
        mPendingReply = mNetworkAccessManager->post(request, mUploadDevice);

        // Update state & progress:
        mState = Loading;
        setProgress(0.);

        // Connect:
        connect(mPendingReply, SIGNAL(finished()), SLOT(replyFinished()), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(onNetworkError(QNetworkReply::NetworkError)), Qt::UniqueConnection);
    }
}

// Send file:
void HttpUploader::sendFile(const QString& fileName)
{
    if (mState == Opened)
    {
        // Build request:
        QNetworkRequest request(mUrl);

        // Release current upload device:
        if (mUploadDevice)
            delete mUploadDevice;

        // Setup upload device:
        mUploadDevice = new QFile(fileName, this);
        if (!mUploadDevice->open(QIODevice::ReadOnly))
        {
            // Done:
            setErrorString(mUploadDevice->errorString());
            setErrorType(FileError);
            clear();
            return;
        }

        // Get reply:
        mPendingReply = mNetworkAccessManager->post(request, mUploadDevice);

        // Loading:
        mState = Loading;

        // Reset progress:
        setProgress(0.);

        connect(mPendingReply, SIGNAL(finished()), SLOT(replyFinished()), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(onNetworkError(QNetworkReply::NetworkError)), Qt::UniqueConnection);
    }
}

// Add field:
void HttpUploader::addField(const QString& fieldName, const QString& fieldValue)
{
    HttpPostFieldValue *field = new HttpPostFieldValue(this);
    field->setName(fieldName);
    field->setValue(fieldValue);
    field->mInstancedFromQml = false;
    mPostFields.append(field);
}

// Add file:
void HttpUploader::addFile(const QString& fieldName, const QString& fileName, const QString& mimeType)
{
    HttpPostFieldFile *field = new HttpPostFieldFile(this);
    field->setName(fieldName);
    field->setSource(QUrl::fromLocalFile(fileName));
    field->setMimeType(mimeType);
    field->mInstancedFromQml = false;
    mPostFields.append(field);
}

// Upload progress:
void HttpUploader::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    if (bytesTotal > 0)
    {
        qreal progress = qreal(bytesSent) / qreal(bytesTotal);
        if (!qFuzzyCompare(progress, mProgress))
            setProgress(progress);
    }
}

// Reply finished:
void HttpUploader::replyFinished()
{
    // Set response:
    setResponse(mPendingReply->readAll());

    // Done:
    setState(Done);

    // Clear:
    clear();
}

// Network error:
void HttpUploader::onNetworkError(const QNetworkReply::NetworkError &error)
{
    Q_UNUSED(error);

    // Update network error:
    setErrorString(mPendingReply->errorString());
    setErrorType(NetworkError);

    mState = Done;

    // Clear:
    clear();
}



