#include "form.h"
#include "json.h"
#include <QUuid>
#include <QFile>
#include <QTextStream>
#include <QDate>
#include "utils.h"

Form::Form(QObject *parent) :
    QObject(parent)
{
}

// Load JSON string:
bool Form::loadJSONString(const QString &jsonString)
{
    // Check string:
    if (jsonString.simplified().isEmpty())
        return false;

    // Parsing json strings
    QVariantMap jsonObject = JSON::instance().parse(jsonString);
    if (jsonObject.isEmpty())
        return false;

    // Parse parameters:
    for (QMap<QString, QVariant>::iterator it = jsonObject.begin(); it != jsonObject.end(); ++it)
    {
        QString paramName = Utils::getKey(it.key());
        if (paramName.isEmpty())
            continue;
        if (paramName == "fields")
            continue;
        mParameters[paramName] = it.value();
    }

    // Read fields:
    QVariantList fields = jsonObject.value("fields").toList();
    for (int i=0; i<fields.size(); i++)
        mFields << fields[i].toMap();
    mParameters["name"] = generateUID();
    mFields << mParameters;

    emit nFieldsChanged();
    return true;
}

// Load JSON file:
bool Form::loadJSONFile(const QString &jsonFile)
{
    // Check file:
    if (!QFile::exists(jsonFile))
        return false;

    // Parse file:
    QFile file(jsonFile);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return false;
    QTextStream in(&file);
    QString jsonString = in.readAll();
    file.close();

    // Load JSON string:
    return loadJSONString(jsonString);
}

// Get parameter, other than field:
QVariant Form::getParameter(const QString &paramName) const
{
    if (paramName.simplified().isEmpty())
        return QVariant();
    QString actualParamName = Utils::getKey(paramName);
    if (actualParamName.isEmpty())
        return QVariant();
    return mParameters[actualParamName];
}

// Get field value:
QVariant Form::getFieldValue(const QString &fieldId) const
{
    return getFieldProperty(fieldId, "value");
}

// Set field value:
bool Form::setFieldValue(const QString &fieldId, const QVariant &value)
{
    if (fieldId.simplified().isEmpty())
        return false;
    QString actualFieldId = Utils::getKey(fieldId);
    if (actualFieldId.isEmpty())
        return false;
    for (int i=0; i<mFields.size(); i++)
    {
        QString curFieldId = Utils::getKey(mFields[i]["name"].toString());
        if (curFieldId.isEmpty())
            continue;
        if (actualFieldId == curFieldId)
        {
            mFields[i]["value"] = value;
            emit update(this, fieldId);
            return true;
        }
    }
    return false;
}

// Get field value:
QVariant Form::getFieldProperty(const QString &fieldId, const QString &propName) const
{
    if (fieldId.simplified().isEmpty())
        return QVariant();
    QString actualFieldId = Utils::getKey(fieldId);
    if (actualFieldId.isEmpty())
        return QVariant();
    QString actualPropName = Utils::getKey(propName);
    if (actualPropName.isEmpty())
        return QVariant();
    for (int i=0; i<mFields.size(); i++)
    {
        QString curFieldId = Utils::getKey(mFields[i]["name"].toString());
        if (curFieldId.isEmpty())
            continue;
        if (actualFieldId == curFieldId)
        {
            QVariantMap formProperties =  mFields[i];
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
QVariant Form::getFieldProperty(int fieldIndex, const QString &propName) const
{
    if ((fieldIndex < 0) || (fieldIndex > (mFields.size()-1)))
        return QVariant();
    QVariantMap field = mFields[fieldIndex];
    return getFieldProperty(field["name"].toString(), propName);
}

// Get field id:
QString Form::getFieldId(int fieldIndex) const
{
    if ((fieldIndex < 0) || (fieldIndex > (mFields.size()-1)))
        return "";
    return mFields[fieldIndex]["name"].toString();
}

// Get field value label:
QVariant Form::getFieldValueLabel(const QString &fieldId, const QString &format) const
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
void Form::sendRequest()
{
    // Get API call:
    QString apiCall = getParameter("apicall").toString();
    emit requestOK();
}
