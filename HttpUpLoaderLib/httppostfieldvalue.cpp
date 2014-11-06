#include "httppostfieldvalue.h"
#include <QBuffer>

// Constructor:
HttpPostFieldValue::HttpPostFieldValue(QObject * parent)
    : HttpPostField(parent)
{
    mType = FieldValue;
}

// Value:
QString HttpPostFieldValue::value() const
{
    return QString::fromUtf8(mValue.constData(), mValue.size());
}

// Set value:
void HttpPostFieldValue::setValue(const QString& value)
{
    mValue = value.toUtf8();
}

// Content length:
int HttpPostFieldValue::contentLength()
{
    return mValue.size();
}

// Create IO device:
QIODevice * HttpPostFieldValue::createIoDevice(QObject * parent)
{
    QBuffer * buffer = new QBuffer(parent);
    buffer->setData(mValue);
    buffer->open(QIODevice::ReadOnly);
    return buffer;
}

// Validate field:
bool HttpPostFieldValue::validateField()
{
    return true;
}

