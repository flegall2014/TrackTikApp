#ifndef FORM_H
#define FORM_H
#include <QObject>
#include <QMap>
#include <QUuid>
#include <QVariantMap>

class Form : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int nFields READ nFields NOTIFY nFieldsChanged)

public:
    explicit Form(QObject *parent = 0);

    // Load JSON string:
    bool loadJSONString(const QString &jsonString);

    // Load JSON file:
    bool loadJSONFile(const QString &jsonFile);

    // Get parameter, other than field:
    Q_INVOKABLE QVariant getParameter(const QString &paramName) const;

    // Get field value:
    Q_INVOKABLE QVariant getFieldValue(const QString &fieldId) const;

    // Set field value:
    Q_INVOKABLE bool setFieldValue(const QString &fieldId, const QVariant &value);

    // Get field value label:
    Q_INVOKABLE QVariant getFieldValueLabel(const QString &fieldId, const QString &format="yyyy/MM/dd") const;

    // Get field property:
    Q_INVOKABLE QVariant getFieldProperty(const QString &fieldId, const QString &propName) const;

    // Get field property:
    Q_INVOKABLE QVariant getFieldProperty(int fieldIndex, const QString &propName) const;

    // Get field id:
    Q_INVOKABLE QString getFieldId(int fieldIndex) const;

    // API button clicked:
    Q_INVOKABLE void sendRequest();

private:
    // Generate UID:
    inline QString generateUID() const
    {
        QString uid = QUuid::createUuid().toString();
        uid.replace("{", "");
        uid.replace("}", "");
        return uid;
    }

    // Return number of fields in form:
    inline int nFields() const
    {
        return mFields.size();
    }

private:
    // Use QList: need to preserve JSON order:
    QList<QVariantMap> mFields;

    // Parameters:
    QVariantMap mParameters;

signals:
    // N fields changed:
    void nFieldsChanged();

    // Update:
    void update(QObject *form, const QString &fieldId);

    // Request processed ok:
    void requestOK();

    // Request error:
    void requestError();
};

#endif // FORM_H
