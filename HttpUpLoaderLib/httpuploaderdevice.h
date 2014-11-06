#ifndef HTTPUPLOADERDEVICE_H
#define HTTPUPLOADERDEVICE_H
#include <QIODevice>
#include <QVector>
#include <QPair>
#include "httpuploaderlib_global.h"
class HttpPostField;
class HttpUploader;

class HTTPUPLOADERLIBSHARED_EXPORT HttpUploaderDevice : public QIODevice
{
    Q_OBJECT

public:
    // Constructor:
    HttpUploaderDevice(HttpUploader * uploader);

    // Destructor:
    ~HttpUploaderDevice()
    {
        for(int i = 0 ; i < ioDevices.count() ; ++i)
            delete ioDevices[i].second;
    }

    // Size:
    virtual qint64 size() const;

    // Seek:
    virtual bool seek(qint64 pos);

private:
    // Read data:
    virtual qint64 readData(char *data, qint64 maxlen);

    // Write data:
    virtual qint64 writeData(const char *data, qint64 len);

private:
    // Setup:
    void setup();

public:
    struct Range {
        int start;
        int end;
    };

    // Append data:
    void appendData(const QByteArray& data);

    // Append field:
    void appendField(HttpPostField * field);

    QVector< QPair<Range, QIODevice *> > ioDevices;
    int totalSize;
    qint64 ioIndex;
    int lastIndex;
    QByteArray contentType;
};

#endif // HTTPUPLOADERDEVICE_H
