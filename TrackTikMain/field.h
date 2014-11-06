#ifndef FIELD_H
#define FIELD_H
#include <QString>
#include <QVariant>

class Field
{
public:
    Field();

    // Get value:
    QVariant getValue() const;

    // Get value label:
    QString getValueLabel() const;

    // Set value:
    void setValue(const QString &key, const QVariant &value);

private:
    QVariantMap mValues;
};

#endif // FIELD_H
