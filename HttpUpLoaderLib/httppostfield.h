#ifndef HTTPPOSTFIELD_H
#define HTTPPOSTFIELD_H
#include <QObject>
#include <QString>
#include "httpuploaderlib_global.h"
class QIODevice;

// Field type:
class HTTPUPLOADERLIBSHARED_EXPORT HttpPostField : public QObject
{
    Q_OBJECT
    Q_ENUMS(FieldType)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(FieldType type READ type CONSTANT FINAL)
    Q_PROPERTY(int contentLength READ contentLength NOTIFY contentLengthChanged)

public:
    // Defines type of the HTTP POST field
    enum FieldType {
        FieldInvalid,       //< Invalid field - not initialized
        FieldValue,         //< Field is string
        FieldFile           //< Filed is file
    };

    // Constructor:
    HttpPostField(QObject * parent = 0);

    // Destructor:
    virtual ~HttpPostField();

    // Field name:
    QString name() const;

    // Sets name of the field:
    void setName(const QString& name);

    // HTTP POST field type:
    HttpPostField::FieldType type() const;

    // Return length of the content uploaded
    virtual int contentLength() = 0;

    // Create QIODevice object which returns data to be uploaded
    virtual QIODevice * createIoDevice(QObject * parent = 0) = 0;

    // Check if the field is valid (e.g. file exists)
    virtual bool validateField() = 0;

signals:
    // Name changed:
    void nameChanged();

    // Content length changed:
    void contentLengthChanged();

protected:
    // Sets type of the field. Used only by derived classes:
    void setType(HttpPostField::FieldType type);

protected:
    friend class HttpUploader;
    FieldType mType;
    QString mName;
    bool mInstancedFromQml;
};

#endif // HTTPPOSTFIELD_H
