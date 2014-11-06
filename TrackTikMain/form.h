#ifndef FORM_H
#define FORM_H
#include <QObject>
#include <QSharedDataPointer>
#include "formprivate.h"

class Form : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int nFields READ nFields NOTIFY nFieldsChanged)

public:
    explicit Form(QObject *parent = 0);

    // Load JSON string:
    inline bool loadJSONString(const QString &jsonString)
    {
        if (d->loadJSONString(jsonString))
        {
            emit nFieldsChanged();
            return true;
        }
        return false;
    }

    // Load JSON file:
    bool loadJSONFile(const QString &jsonFile);

    // Get field value:
    Q_INVOKABLE inline QVariant getFieldValue(const QString &fieldId) const
    {
        return d->getFieldValue(fieldId);
    }

    // Set field value:
    Q_INVOKABLE inline bool setFieldValue(const QString &fieldId, const QVariant &value)
    {
        if (d->setFieldValue(fieldId, value))
        {
            emit update(this, fieldId);
            return true;
        }
        return false;
    }

    // Get field value label:
    Q_INVOKABLE inline QVariant getFieldValueLabel(const QString &fieldId, const QString &format="yyyy/MM/dd") const
    {
        return d->getFieldValueLabel(fieldId, format);
    }

    // Get field property:
    Q_INVOKABLE inline QVariant getFieldProperty(const QString &fieldId, const QString &propName) const
    {
        return d->getFieldProperty(fieldId, propName);
    }

    // Get field property:
    Q_INVOKABLE inline QVariant getFieldProperty(int fieldIndex, const QString &propName) const
    {
        return d->getFieldProperty(fieldIndex, propName);
    }

    // Get field id:
    Q_INVOKABLE inline QString getFieldId(int fieldIndex) const
    {
        return d->getFieldId(fieldIndex);
    }

    // API button clicked:
    Q_INVOKABLE inline void sendRequest()
    {
        d->sendRequest();
        emit requestOK();
    }

private:
    // Return number of fields in form:
    inline int nFields() const
    {
        return d->formFields.size();
    }

private:
    // Private data:
    QSharedDataPointer<FormPrivate> d;

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
