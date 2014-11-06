#include "formprivate.h"
#include "json.h"
#include "utils.h"
#include <QDate>

// Constructor:
FormPrivate::FormPrivate() : QSharedData()
{
}

// Load JSON string:
bool FormPrivate::loadJSONString(const QString &jsonString)
{
    // Check string:
    if (jsonString.simplified().isEmpty())
        return false;

    // Parsing json strings
    QVariantMap jsonObject = JSON::instance().parse(jsonString);
    if (jsonObject.isEmpty())
        return false;

    // Parameters:
    QVariantMap formParameters;
    for (QMap<QString, QVariant>::iterator it = jsonObject.begin(); it != jsonObject.end(); ++it)
    {
        QString paramName = Utils::getKey(it.key());
        if (paramName.isEmpty())
            continue;
        if (paramName == "fields")
            continue;
        formParameters[paramName] = it.value();
    }

    // Read fields:
    QVariantList fields = jsonObject.value("fields").toList();
    for (int i=0; i<fields.size(); i++)
        formFields << fields[i].toMap();
    formParameters["name"] = "parameters";
    formFields << formParameters;

    return true;
}

// Get field value:
QVariant FormPrivate::getFieldValue(const QString &fieldId) const
{
    return getFieldProperty(fieldId, "value");
}

// Set field value:
bool FormPrivate::setFieldValue(const QString &fieldId, const QVariant &value)
{
    if (fieldId.simplified().isEmpty())
        return false;
    QString actualFieldId = Utils::getKey(fieldId);
    if (actualFieldId.isEmpty())
        return false;
    for (int i=0; i<formFields.size(); i++)
    {
        QString curFieldId = Utils::getKey(formFields[i]["name"].toString());
        if (curFieldId.isEmpty())
            continue;
        if (actualFieldId == curFieldId)
        {
            formFields[i]["value"] = value;
            return true;
        }
    }
    return false;
}

// Get field value:
QVariant FormPrivate::getFieldProperty(const QString &fieldId, const QString &propName) const
{
    if (fieldId.simplified().isEmpty())
        return QVariant();
    QString actualFieldId = Utils::getKey(fieldId);
    if (actualFieldId.isEmpty())
        return QVariant();
    QString actualPropName = Utils::getKey(propName);
    if (actualPropName.isEmpty())
        return QVariant();
    for (int i=0; i<formFields.size(); i++)
    {
        QString curFieldId = Utils::getKey(formFields[i]["name"].toString());
        if (curFieldId.isEmpty())
            continue;
        if (actualFieldId == curFieldId)
        {
            QVariantMap formProperties = formFields[i];
            for (QMap<QString, QVariant>::const_iterator it = formProperties.begin(); it != formProperties.end(); ++it)
            {
                QString curPropName = Utils::getKey(it.key());
                if (curPropName.isEmpty())
                    continue;
                if (curPropName == actualPropName)
                    return it.value();
            }
        }
    }
    return QVariant();
}

// Get field property:
QVariant FormPrivate::getFieldProperty(int fieldIndex, const QString &propName) const
{
    if ((fieldIndex < 0) || (fieldIndex > (formFields.size()-1)))
        return QVariant();
    QVariantMap field = formFields[fieldIndex];
    return getFieldProperty(field["name"].toString(), propName);
}

// Get field id:
QString FormPrivate::getFieldId(int fieldIndex) const
{
    if ((fieldIndex < 0) || (fieldIndex > (formFields.size()-1)))
        return "";
    return formFields[fieldIndex]["name"].toString();
}

// Get field value label:
QVariant FormPrivate::getFieldValueLabel(const QString &fieldId, const QString &format) const
{
    if (fieldId.simplified().isEmpty())
        return QVariant();
    QString type = getFieldProperty(fieldId, "type").toString();
    QString listType = "strings";
    if (type == "list")
        listType = getFieldProperty(fieldId, "listType").toString();
    if ((type == "list") && (listType == "values"))
    {
        QVariantList list = getFieldProperty(fieldId, "list").toList();
        QVariantList out;
        QVariantList values = getFieldValue(fieldId).toList();
        for (int i=0; i<values.size(); i++)
            for (int j=0; j<list.size(); j++)
            {
                QVariantMap val = list[j].toMap();
                if (val["value"] == values[i])
                    out << val["label"];
            }
        return out;
    }
    else
    if (type == "date")
        return getFieldValue(fieldId).toDate().toString(format);

    return getFieldValue(fieldId);
}

// API button clicked:
void FormPrivate::sendRequest()
{
    // Get API call:
    QString apiCall = getFieldProperty("parameters", "apicall").toString();
}
