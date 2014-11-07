#include <QObject>
#include <QQmlParserStatus>
#include <QNetworkAccessManager>
#include <QPointer>
#include <QQmlListProperty>
#include "httppostfield.h"
#include <QUrl>
#include <QNetworkReply>
#include "httpuploaderlib_global.h"

// The HTTP uploader objects. It works similar to the XMLHttpRequest object, but allows
// uploading of the HTML form-like data.
class HTTPUPLOADERLIBSHARED_EXPORT HttpUploader : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_ENUMS(State)
    Q_ENUMS(Status)
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QQmlListProperty<HttpPostField> postFields READ postFields)
    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(State uploadState READ state NOTIFY stateChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString errorString READ errorString)
    Q_PROPERTY(QString responseText READ responseText)
    Q_PROPERTY(int networkError READ networkError NOTIFY networkErrorChanged)
    Q_CLASSINFO("DefaultProperty", "postFields")

public:
    // State of the uploader object (compatible with XMLHttpRequest state)
    enum State {
        Unsent,     //< Object is closed
        Opened,     //< Object is open and ready to send
        Loading,    //< Data is being sent
        Aborting,   //< State entered when upload is being aborted
        Done        //< Upload finished (you need to examine status property)
    };

    // Status:
    enum Status {
        None,
        Error,
        OK
    };

    // Constructor:
    explicit HttpUploader(QObject *parent = 0);

    // Destructor:
    virtual ~HttpUploader();

    // Get the destination URL:
    QUrl url() const;

    // Set the destination URL of the upload:
    void setUrl(const QUrl& url);

    // Post fields:
    QQmlListProperty<HttpPostField> postFields();

    // Progress:
    qreal progress() const;

    // State:
    HttpUploader::State state() const;

    // Error string:
    QString errorString() const;

    // Response text:
    QString responseText() const;

    // Status:
    HttpUploader::Status status() const;

    // Return network error:
    int networkError() const;

public slots:
    // Reset object to the initial state (close files/clear fields/etc.)
    void clear();

    // Set object to the open state with specified URL:
    void open(const QUrl& url);

    // Start upload:
    void send();

    // Start upload, but use file as POST body:
    void sendFile(const QString& fileName);

    // Abort current transaction:
    void abort();

    // Add key/value field:
    void addField(const QString& fieldName, const QString& fieldValue);

    // Add file field:
    void addFile(const QString& fieldName, const QString& fileName, const QString& mimeType = QString());

signals:
    void urlChanged();
    void progressChanged();
    void stateChanged();
    void statusChanged();
    void networkErrorChanged();

private:
    // Append:
    static void AppendFunction(QQmlListProperty<HttpPostField> *, HttpPostField*);

    // Count:
    static int CountFunction(QQmlListProperty<HttpPostField> *);

    // At:
    static HttpPostField *AtFunction(QQmlListProperty<HttpPostField> *, int);

    // Clear:
    static void ClearFunction(QQmlListProperty<HttpPostField> *);

private:
    // QQmlParserStatus:
    virtual void classBegin();
    virtual void componentComplete();

private slots:
    void reply_finished();
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void onNetworkError(const QNetworkReply::NetworkError &error);

private:
    bool mComplete;
    QNetworkAccessManager *mNetworkAccessManager;
    QUrl mUrl;
    QList< QPointer<HttpPostField> > mPostFields;
    qreal mProgress;
    State mState;
    QPointer<QNetworkReply> mPendingReply;
    QString mErrorString;
    QByteArray mBoundaryString;
    QIODevice * mUploadDevice;
    Status mStatus;
    QByteArray mResponse;
    int mNetworkError;
    friend class HttpUploaderDevice;
};
