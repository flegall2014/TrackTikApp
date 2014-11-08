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
    mStatus(None),
    mNetworkError(0)
{
    mNetworkAccessManager = new QNetworkAccessManager(this);
}

// Destructor:
HttpUploader::~HttpUploader()
{
    if(mPendingReply) {
        mPendingReply->abort();
    }
}

// Return url:
QUrl HttpUploader::url() const
{
    return mUrl;
}

// Set url:
void HttpUploader::setUrl(const QUrl& url)
{
    if( mState == Loading )
    {
        qWarning() << "HttpUploader: Can't change URL in loading state";
    } else {
        if( url != mUrl ) {
            mUrl = url;
            emit urlChanged();
        }
    }
}

// Progress:
qreal HttpUploader::progress() const
{
    return mProgress;
}

// State:
HttpUploader::State HttpUploader::state() const
{
    return mState;
}

// Error string:
QString HttpUploader::errorString() const
{
    return mErrorString;
}

// Response text:
QString HttpUploader::responseText() const
{
    return QString::fromUtf8(mResponse.constData(), mResponse.size());
}

// Network error:
int HttpUploader::networkError() const
{
    return mNetworkError;
}

// Status:
HttpUploader::Status HttpUploader::status() const
{
    return mStatus;
}

// Clear:
void HttpUploader::clear()
{
    if( mState == Done || mState == Opened || mState == Unsent ) {
        mState = Unsent;
        mUrl.clear();
        for(int i = 0 ; i < mPostFields.size() ; ++i)
            if(mPostFields[i] && !mPostFields[i]->mInstancedFromQml)
                delete mPostFields[i];
        mPostFields.clear();
        mProgress = 0;
        mStatus = None;
        mErrorString.clear();
        mResponse.clear();
        //emit stateChanged();
        emit urlChanged();
        emit progressChanged();
        emit statusChanged();
    }
}

// Open:
void HttpUploader::open(const QUrl& url)
{
    //if( mState == Unsent )
    {
        setUrl(url);
        mState = Opened;
        //emit stateChanged();
    } //else {
      //  qWarning() << "Invalid state of uploader" << mState << "to open";
    //}
}

// Send:
void HttpUploader::send()
{
    if( mState == Opened ) {
        QNetworkRequest request(mUrl);

        QCryptographicHash hash(QCryptographicHash::Sha1);
        foreach(QPointer<HttpPostField> field, mPostFields) {
            if( !field.isNull() ) {
                if(!field->validateField()) {
                    mState = Done;
                    mErrorString = tr("Failed to validate POST fields");
                    mStatus = Error;
                    //emit stateChanged();
                    emit statusChanged();
                    return;
                }
                hash.addData(field->name().toUtf8());
            }
        }

        mBoundaryString = "HttpUploaderBoundary" + hash.result().toHex();

        mUploadDevice = new HttpUploaderDevice(this);
        mUploadDevice->open(QIODevice::ReadOnly);

        request.setHeader(QNetworkRequest::ContentTypeHeader, ((HttpUploaderDevice *)mUploadDevice)->contentType);
        request.setHeader(QNetworkRequest::ContentLengthHeader, mUploadDevice->size());

        mPendingReply = mNetworkAccessManager->post(request, mUploadDevice);
        mState = Loading;
        mProgress = 0;

        connect(mPendingReply, SIGNAL(finished()), SLOT(replyFinished()), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(onNetworkError(QNetworkReply::NetworkError)), Qt::UniqueConnection);

        //emit stateChanged();
        emit progressChanged();
    } else {
        qWarning() << "Invalid state of uploader" << mState << "to send";
    }
}

// Send file:
void HttpUploader::sendFile(const QString& fileName)
{
    if( mState == Opened ) {
        QNetworkRequest request(mUrl);

        mUploadDevice = new QFile(fileName, this);
        if(!mUploadDevice->open(QIODevice::ReadOnly)) {
            mState = Done;
            mErrorString = mUploadDevice->errorString();
            delete mUploadDevice;
            mUploadDevice = NULL;
            mStatus = Error;
            //emit stateChanged();
            emit statusChanged();
            return;
        }

        mPendingReply = mNetworkAccessManager->post(request, mUploadDevice);
        mState = Loading;
        mProgress = 0;

        connect(mPendingReply, SIGNAL(finished()), SLOT(replyFinished()), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)), Qt::UniqueConnection);
        connect(mPendingReply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(onNetworkError(QNetworkReply::NetworkError)), Qt::UniqueConnection);

        //emit stateChanged();
        emit progressChanged();
    } else {
        qWarning() << "Invalid state of uploader" << mState << "to send";
    }
}

// Abort:
void HttpUploader::abort()
{
    if( mState == Loading ) {
        mState = Aborting;
        //emit stateChanged();
        mPendingReply->abort();
    }
}

// Add field:
void HttpUploader::addField(const QString& fieldName, const QString& fieldValue)
{
    HttpPostFieldValue * field = new HttpPostFieldValue(this);
    field->setName(fieldName);
    field->setValue(fieldValue);
    field->mInstancedFromQml = false;
    mPostFields.append(field);
}

// Add file:
void HttpUploader::addFile(const QString& fieldName, const QString& fileName, const QString& mimeType)
{
    HttpPostFieldFile * field = new HttpPostFieldFile(this);
    field->setName(fieldName);
    field->setSource(QUrl::fromLocalFile(fileName));
    field->setMimeType(mimeType);
    field->mInstancedFromQml = false;
    mPostFields.append(field);
}

// Reply finished:
void HttpUploader::replyFinished()
{
    mPendingReply->deleteLater();

    if( mPendingReply->error() == QNetworkReply::OperationCanceledError ) {
        mPendingReply = NULL;
        delete mUploadDevice;
        mUploadDevice = NULL;
        mProgress = 0;
        mState = Done;
        mBoundaryString.clear();
        emit progressChanged();
        emit stateChanged();
        return;
    }

    mResponse = mPendingReply->readAll();

    if( mPendingReply->error() != QNetworkReply::NoError ) {
        delete mUploadDevice;
        mUploadDevice = NULL;
        mProgress = 0;
        mState = Done;
        mBoundaryString.clear();
        mErrorString = mPendingReply->errorString();
        mPendingReply = NULL;
        mStatus = None;
        emit progressChanged();
        emit stateChanged();
        emit statusChanged();
        return;
    }

    delete mUploadDevice;
    mUploadDevice = NULL;
    mProgress = 1;
    mState = Done;
    mErrorString.clear();
    mPendingReply = NULL;
    mStatus = OK;

    emit progressChanged();
    emit statusChanged();
    emit stateChanged();
}

// Upload progress:
void HttpUploader::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    if( bytesTotal > 0 )
    {
        qreal progress = qreal(bytesSent) / qreal(bytesTotal);
        if(!qFuzzyCompare(progress, mProgress))
        {
            mProgress = progress;
            emit progressChanged();
        }
    }
}

// Network error:
void HttpUploader::onNetworkError(const QNetworkReply::NetworkError &error)
{
    mNetworkError = (int)error;
    emit networkErrorChanged();
}
