#include <QIODevice>
#include "httpuploaderdevice.h"
#include "httpuploader.h"
#include "httppostfieldfile.h"
#include "httppostfieldvalue.h"
#include <QFileInfo>
#include <QBuffer>

// Constructor:
HttpUploaderDevice::HttpUploaderDevice(HttpUploader * uploader):
    QIODevice(uploader),
    totalSize(0),
    ioIndex(0),
    lastIndex(0)
{
    setup();
}

// Return size:
qint64 HttpUploaderDevice::size() const
{
    return totalSize;
}

// Seek:
bool HttpUploaderDevice::seek(qint64 pos)
{
    if(pos >= totalSize)
        return false;
    ioIndex = pos;
    lastIndex = 0;
    return QIODevice::seek(pos);
}

// Read data:
qint64 HttpUploaderDevice::readData(char *data, qint64 len)
{
    if ((len = qMin(len, qint64(totalSize) - ioIndex)) <= 0)
        return qint64(0);

    qint64 totalRead = 0;

    while(len > 0)
    {
        if( ioIndex >= ioDevices[lastIndex].first.start &&
            ioIndex <= ioDevices[lastIndex].first.end )
        {

        } else {
            for(int i = 0 ; i < ioDevices.count() ; ++i)
            {
                if( ioIndex >= ioDevices[i].first.start &&
                    ioIndex <= ioDevices[i].first.end )
                {
                    lastIndex = i;
                }
            }
        }

        QIODevice * chunk = ioDevices[lastIndex].second;

        if(!ioDevices[lastIndex].second->seek(ioIndex - ioDevices[lastIndex].first.start))
        {
            qWarning("HttpUploaderDevice: Failed to seek inner device");
            break;
        }

        qint64 bytesLeftInThisChunk = chunk->size() - chunk->pos();
        qint64 bytesToReadInThisRequest = qMin(bytesLeftInThisChunk, len);

        qint64 readLen = chunk->read(data, bytesToReadInThisRequest);
        if( readLen != bytesToReadInThisRequest ) {
            qWarning("HttpUploaderDevice: Failed to read requested amount of data");
            break;
        }

//#ifdef QT_DEBUG
//        qDebug() << "HttpUploaderDevice: Read chunk of size" << readLen << "Offset =" << ioIndex << "Left =" << len - readLen;
//        qDebug() << "HttpUploaderDevice: Data is [" << QByteArray::fromRawData(data, readLen) << "]";
//#endif

        data += bytesToReadInThisRequest;
        len -= bytesToReadInThisRequest;
        totalRead += bytesToReadInThisRequest;
        ioIndex += bytesToReadInThisRequest;
    }

    return totalRead;
}

// Write data:
qint64 HttpUploaderDevice::writeData(const char *data, qint64 len)
{
    Q_UNUSED(data);
    Q_UNUSED(len);
    return -1;
}

void HttpUploaderDevice::setup()
{
    HttpUploader * o = (HttpUploader *)parent();

    QByteArray crlf("\r\n");
    QByteArray boundary("---------------------------" + o->mBoundaryString);
    QByteArray endBoundary(crlf + "--" + boundary + "--" + crlf);
    contentType = QByteArray("multipart/form-data; boundary=") + boundary;
    boundary="--"+boundary+crlf;
    QByteArray bond=boundary;

    bool first = true;

    for(int i = 0 ; i < o->mPostFields.count() ; ++i)
    {
        if(!o->mPostFields[i])
            continue;
        HttpPostField * field = o->mPostFields[i].data();

        QByteArray chunk(bond);
        if(first) {
            first = false;
            boundary = crlf + boundary;
            bond = boundary;
        }

        if(field->type() == HttpPostField::FieldFile) {
            chunk.append("Content-Disposition: form-data; name=\"");
            chunk.append(field->name().toLatin1());
            chunk.append("\"; filename=\"");

            HttpPostFieldFile * file = static_cast<HttpPostFieldFile *>(field);

            QFileInfo fi(file->source().toLocalFile());
            chunk.append(fi.fileName().toUtf8());
            chunk.append("\"");
            chunk.append(crlf);

            if(!file->mimeType().isEmpty()) {
                chunk.append("Content-Type: ");
                chunk.append(file->mimeType());
                chunk.append("\r\n");
            } else {
                chunk.append("Content-Type: application/octet-stream\r\n");
            }

            chunk.append(crlf);

            // Files up to 256KB may be loaded into memory
            if( totalSize + chunk.size() + file->contentLength() < 256*1024) {
                QIODevice * dev = file->createIoDevice(this);
                chunk.append(dev->readAll());
                delete dev;
                appendData(chunk);
            } else {
                appendData(chunk);
                appendField(file);
            }
        } else {
            chunk.append("Content-Disposition: form-data; name=\"");
            chunk.append(field->name().toLatin1());
            chunk.append("\"");
            chunk.append(crlf);
            chunk.append("Content-Transfer-Encoding: 8bit");
            chunk.append(crlf);
            chunk.append(crlf);

            HttpPostFieldValue * value = static_cast<HttpPostFieldValue *>(field);

            chunk.append(value->value().toUtf8());

            appendData(chunk);
        }
    }

    if( !o->mPostFields.isEmpty() )
        appendData(endBoundary);
}

// Append data:
void HttpUploaderDevice::appendData(const QByteArray& data)
{
    QBuffer * buffer = new QBuffer(this);
    buffer->setData(data);
    buffer->open(QBuffer::ReadOnly);

    Range r;
    r.start = totalSize;
    r.end = totalSize + data.size() - 1;

    ioDevices.append(QPair<Range, QIODevice *>(r, buffer));
    totalSize += data.size();
}

// Append field:
void HttpUploaderDevice::appendField(HttpPostField * field)
{
#ifdef QT_DEBUG
    qDebug() << "HttpUploaderDevice: Append field of size" << field->contentLength();
#endif

    QIODevice * device = field->createIoDevice(this);

    Range r;
    r.start = totalSize;
    r.end = totalSize + device->size() - 1;

    ioDevices.append(QPair<Range, QIODevice *>(r, device));
    totalSize += device->size();
}
