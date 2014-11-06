#ifndef HTTPPOSTFIELDVALUE_H
#define HTTPPOSTFIELDVALUE_H
#include "httppostfield.h"
#include "httpuploaderlib_global.h"

// UTF-8 encoded POST field:
class HTTPUPLOADERLIBSHARED_EXPORT HttpPostFieldValue : public HttpPostField
{
    Q_OBJECT
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged)

public:
    // Constructor:
    HttpPostFieldValue(QObject * parent = 0);

    // Return value as Unicode string:
    QString value() const;

    // Transform unicode string to UTF-8 buffer:
    void setValue(const QString& value);

    // Return content length:
    virtual int contentLength();

    // Create IO device:
    virtual QIODevice *createIoDevice(QObject * parent = 0);

    // Validate vield:
    virtual bool validateField();

signals:
    // Value changed:
    void valueChanged();

private:
    QByteArray mValue;
};

#endif // HTTPPOSTFIELDVALUE_H
