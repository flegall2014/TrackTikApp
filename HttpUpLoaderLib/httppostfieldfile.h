#ifndef HTTPPOSTFIELDFILE_H
#define HTTPPOSTFIELDFILE_H
#include "httppostfield.h"
#include <QUrl>
#include "httpuploaderlib_global.h"

// Raw file
class HTTPUPLOADERLIBSHARED_EXPORT HttpPostFieldFile : public HttpPostField
{
    Q_OBJECT
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString mimeType READ mimeType WRITE setMimeType NOTIFY mimeTypeChanged)

public:
    // Constructor:
    HttpPostFieldFile(QObject * parent = 0);

    // Return content length:
    virtual int contentLength();

    // Create IO device:
    virtual QIODevice *createIoDevice(QObject * parent = 0);

    // Validate vield:
    virtual bool validateField();

    // Source URL for the file:
    QUrl source() const;

    // Sets source URL of the file:
    void setSource(const QUrl& url);

    // Returns MIME type of the file:
    QString mimeType() const;

    // Sets MIME type of the file. If MIME type is empty, application/octet-stream is used by default:
    void setMimeType(const QString& mime);

signals:
    // Source changed:
    void sourceChanged();

    // MIME type changed:
    void mimeTypeChanged();

private:
    QUrl mSource;
    QString mMime;
};

#endif // HTTPPOSTFIELDFILE_H
