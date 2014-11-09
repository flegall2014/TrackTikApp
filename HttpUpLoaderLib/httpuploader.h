#include <QObject>
#include <QNetworkAccessManager>
#include <QPointer>
#include <QQmlListProperty>
#include "httppostfield.h"
#include <QUrl>
#include <QNetworkReply>
#include "httpuploaderlib_global.h"

// The HTTP uploader objects. It works similar to the XMLHttpRequest object, but allows
// uploading of the HTML form-like data.
class HTTPUPLOADERLIBSHARED_EXPORT HttpUploader : public QObject
{
    Q_OBJECT

public:
    // State of the uploader object (compatible with XMLHttpRequest state)
    enum State {
        Unsent,     //< Object is closed
        Opened,     //< Object is open and ready to send
        Loading,    //< Data is being sent
        Aborting,   //< State entered when upload is being aborted
        Done        //< Upload finished (you need to examine status property)
    };

    enum ErrorType {
        None,
        FileError,
        NetworkError,
        ApiError
    };

    // Constructor:
    explicit HttpUploader(QObject *parent = 0);

    // Destructor:
    virtual ~HttpUploader();

    // Return url:
    inline QUrl url() const
    {
        return mUrl;
    }

    // Set the destination URL of the upload:
    void setUrl(const QUrl& url);

    // Post fields:
    QQmlListProperty<HttpPostField> postFields();

    // Progress:
    inline qreal progress() const
    {
        return mProgress;
    }

    // Set progress:
    inline void setProgress(qreal progress)
    {
        mProgress = progress;
        emit progressChanged();
    }

    // State:
    inline State state() const
    {
        return mState;
    }

    // Set state:
    inline void setState(const State &state)
    {
        mState = state;
        emit stateChanged();
    }

    // Error:
    inline ErrorType errorType() const
    {
        return mErrorType;
    }

    // Set error:
    inline void setErrorType(const ErrorType &errorType)
    {
        mErrorType = errorType;
        emit errorTypeChanged();
    }

    // Error string (file or network error):
    inline QString errorString() const
    {
        return mErrorString;
    }

    // Set error code:
    inline void setErrorString(const QString &errorString)
    {
        mErrorString = errorString;
    }

    // Response:
    QString response() const
    {
        return QString::fromUtf8(mResponse.constData(), mResponse.size());
    }

    // Set response:
    inline void setResponse(const QByteArray &response)
    {
        mResponse = response;
    }

public slots:
    // Reset object to the initial state (close files/clear fields/etc.)
    void clear();

    // Set object to the open state with specified URL:
    void open(const QUrl& url);

    // Start upload:
    void send();

    // Start upload, but use file as POST body:
    void sendFile(const QString& fileName);

    // Add key/value field:
    void addField(const QString& fieldName, const QString& fieldValue);

    // Add file field:
    void addFile(const QString& fieldName, const QString& fileName, const QString& mimeType = QString());

signals:
    void urlChanged();
    void progressChanged();
    void stateChanged();
    void statusChanged();
    void networkerrorTypeChanged();
    void errorTypeChanged();

private slots:
    void replyFinished();
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void onNetworkError(const QNetworkReply::NetworkError &error);

private:
    QNetworkAccessManager *mNetworkAccessManager;
    QUrl mUrl;
    QList< QPointer<HttpPostField> > mPostFields;
    qreal mProgress;
    State mState;
    QPointer<QNetworkReply> mPendingReply;
    QByteArray mBoundaryString;
    QIODevice *mUploadDevice;
    ErrorType mErrorType;
    QString mErrorString;
    QByteArray mResponse;
    friend class HttpUploaderDevice;
};
