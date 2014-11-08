#ifndef FORMPRIVATE_H
#define FORMPRIVATE_H
#include <QSharedData>
#include <QVariantMap>

// Private:
class FormPrivate : public QSharedData
{
public:
    // Constructor:
    FormPrivate();

    // Load JSON string:
    bool loadJSONString(const QString &jsonString);

    // Get field value:
    QVariant getFieldValue(const QString &fieldId) const;

    // Set field value:
    bool setFieldValue(const QString &fieldId, const QVariant &value);

    // Get field value:
    QVariant getFieldProperty(const QString &fieldId, const QString &propName) const;

    // Get field property:
    QVariant getFieldProperty(int fieldIndex, const QString &propName) const;

    // Get field id:
    QString getFieldId(int fieldIndex) const;

    // Get field value label:
    QVariant getFieldValueLabel(const QString &fieldId, const QString &format) const;

    // Use QList: need to preserve JSON order:
    QList<QVariantMap> formFields;
};

#endif // FORMPRIVATE_H
