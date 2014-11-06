#include "httppostfieldfile.h"
#include <QFileInfo>

// Constructor:
HttpPostFieldFile::HttpPostFieldFile(QObject * parent)
    : HttpPostField(parent)
{
    mType = FieldFile;
}

// Content length:
int HttpPostFieldFile::contentLength()
{
    QFileInfo fi(mSource.toLocalFile());
    return fi.size();
}

// Create IO device:
QIODevice *HttpPostFieldFile::createIoDevice(QObject * parent)
{
    QFile *file = new QFile(mSource.toLocalFile(), parent);
    if(!file->open(QFile::ReadOnly))
    {
        delete file;
        Q_ASSERT_X(NULL, "HttpPostFieldFile::createIoDevice", "Failed to open file");
    }
    return file;
}

// Return source:
QUrl HttpPostFieldFile::source() const
{
    return mSource;
}

// Set source:
void HttpPostFieldFile::setSource(const QUrl& url)
{
    mSource = url;
}

// Return MIME type:
QString HttpPostFieldFile::mimeType() const
{
    return mMime;
}

// Set MIME type:
void HttpPostFieldFile::setMimeType(const QString& mime)
{
    if( mMime != mime ) {
        mMime = mime;
        emit mimeTypeChanged();
    }
}

// Validate field:
bool HttpPostFieldFile::validateField()
{
    return QFile::exists(mSource.toLocalFile());
}

