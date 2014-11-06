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
    mStatus(0)
{
    mComplete = false;
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

// Post fields:
QQmlListProperty<HttpPostField> HttpUploader::postFields()
{
    return QQmlListProperty<HttpPostField>(this,
                                                   0,
                                                   &HttpUploader::AppendFunction,
                                                   &HttpUploader::CountFunction,
                                                   &HttpUploader::AtFunction,
                                                   &HttpUploader::ClearFunction);
}

// Append:
void HttpUploader::AppendFunction(QQmlListProperty<HttpPostField> * o, HttpPostField* field)
{
    HttpUploader * self = qobject_cast<HttpUploader *>(o->object);
    if(self) {
        if( self->mState == Loading ) {
            qWarning("HttpUploader: Invalid state when trying to append field");
        } else {
            self->mPostFields.append(field);
        }
    }
}

// Count:
int HttpUploader::CountFunction(QQmlListProperty<HttpPostField> * o)
{
    HttpUploader * self = qobject_cast<HttpUploader *>(o->object);
    if(self)
        return self->mPostFields.count();
    return 0;
}

// At:
HttpPostField * HttpUploader::AtFunction(QQmlListProperty<HttpPostField> * o, int index)
{
    HttpUploader * self = qobject_cast<HttpUploader *>(o->object);
    if(self)
    {
        return self->mPostFields.value(index);
    }

    return NULL;
}

// Clear:
void HttpUploader::ClearFunction(QQmlListProperty<HttpPostField> * o)
{
    HttpUploader * self = qobject_cast<HttpUploader *>(o->object);
    if(self)
    {
        if( self->mState == Loading ) {
            qWarning("HttpUploader: Invalid state when trying to clear fields");
        } else {
            for(int i = 0 ; i < self->mPostFields.size() ; ++i)
                if(self->mPostFields[i] && !self->mPostFields[i]->mInstancedFromQml)
                    delete self->mPostFields[i];
            self->mPostFields.clear();
        }
    }
}

// Class begin:
void HttpUploader::classBegin()
{
    // Get active engine:
    QQmlEngine *engine = QQmlEngine::contextForObject(this)->engine();

    if (QQmlNetworkAccessManagerFactory *factory = engine->networkAccessManagerFactory())
    {
        mNetworkAccessManager = factory->create(this);
    }
    else
    {
        mNetworkAccessManager = engine->networkAccessManager();
    }
}

// Component complete:
void HttpUploader::componentComplete()
{
    mComplete = true;
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

// Status:
int HttpUploader::status() const
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
        mStatus = 0;
        mErrorString.clear();
        mResponse.clear();
        emit stateChanged();
        emit urlChanged();
        emit progressChanged();
        emit statusChanged();
    }
}

// Open:
void HttpUploader::open(const QUrl& url)
{
    if( mState == Unsent )
    {
        setUrl(url);
        mState = Opened;
        emit stateChanged();
    } else {
        qWarning() << "Invalid state of uploader" << mState << "to open";
    }
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
                    mStatus = -1;
                    emit stateChanged();
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

        connect(mPendingReply, SIGNAL(finished()), SLOT(reply_finished()));
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)));

        emit stateChanged();
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
            mStatus = -1;
            emit stateChanged();
            emit statusChanged();
            return;
        }

        mPendingReply = mNetworkAccessManager->post(request, mUploadDevice);
        mState = Loading;
        mProgress = 0;

        connect(mPendingReply, SIGNAL(finished()), SLOT(reply_finished()));
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)));

        emit stateChanged();
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
        emit stateChanged();
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
void HttpUploader::reply_finished()
{
    mPendingReply->deleteLater();

    if( mPendingReply->error() == QNetworkReply::OperationCanceledError ) {
#ifdef QT_DEBUG
        qDebug() << "HttpUploader: Upload aborted";
#endif

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
#ifdef QT_DEBUG
        qDebug() << "HttpUploader: Network error" << mPendingReply->error();
#endif

        delete mUploadDevice;
        mUploadDevice = NULL;
        mProgress = 0;
        mState = Done;
        mBoundaryString.clear();
        mErrorString = mPendingReply->errorString();
        mPendingReply = NULL;
        mStatus = 0;
        emit progressChanged();
        emit stateChanged();
        emit statusChanged();
        return;
    }

#ifdef QT_DEBUG
    qDebug() << "HttpUploader: Upload finished";
#endif

    delete mUploadDevice;
    mUploadDevice = NULL;
    mProgress = 1;
    mState = Done;
    mErrorString.clear();
    mPendingReply = NULL;
    mStatus = 200;

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
#ifdef QT_DEBUG
            qDebug() << "HttpUploader: Progress is" << mProgress;
#endif
            emit progressChanged();
        }
    }
}
