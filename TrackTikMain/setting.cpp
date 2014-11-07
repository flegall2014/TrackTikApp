#include "setting.h"
#include "database.h"
#include "utils.h"

// Constructor:
Setting::Setting(QObject *parent) : QObject(parent), mType("setting")
{

}

// Destructor:
Setting::~Setting() {
}

// Set:
bool Setting::set(const QString &key, const QVariant &value)
{
    // Check key:
    QString actualKey = Utils::getKey(key);
    if (actualKey.isEmpty())
        return false;

    // Check value:
    if (!value.isValid())
        return false;

    // Check type:
    QVariant::Type dType = value.type();
    QString now = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    QString queryStr = QString("INSERT OR REPLACE INTO key_value(key, value, datatype, querytype, date) VALUES('%1', '%2', '%3', '%4', '%5')").arg(actualKey).arg(value.toString()).arg((int)dType).arg(mType).arg(now);
    QSqlQuery query;

    // Exec query:
    if (!Database::instance()->execQuery(queryStr, query))
        return false;

    return true;
}

// Get:
QVariant Setting::get(const QString &key, const QString &defaultValue) const
{
    // Check key:
    QString actualKey = Utils::getKey(key);
    if (actualKey.isEmpty())
        return false;

    QSqlQuery query;
    QString queryStr = QString("SELECT value, datatype FROM key_value WHERE querytype='%1' AND key='%2'").arg(mType).arg(actualKey);
    if (!Database::instance()->execQuery(queryStr, query))
        return QVariant();

    // Return result:
    bool ok = true;
    if (query.next())
    {
        QVariant value = query.value("value");
        if (!value.isValid())
            return QVariant();
        int dType = query.value("datatype").toInt(&ok);
        if (!ok)
            return QVariant();
        QVariant::Type vType = (QVariant::Type)dType;

        switch (vType)
        {
            case QVariant::Bool: return value.toBool();
            case QVariant::Int: {
                int out = value.toInt(&ok);
                return ok ? out : QVariant();
            }
            case QVariant::Double: {
                double out = value.toDouble(&ok);
                return ok ? out : QVariant();
            }
            case QVariant::Date:
            case QVariant::String: return value.toString();
            default: return QVariant();
        }
    }

    return defaultValue;
}

// Remove:
bool Setting::remove(const QString &key)
{
    // Check key:
    QString actualKey = Utils::getKey(key);
    if (actualKey.isEmpty())
        return false;

    QSqlQuery query;
    QString queryStr = QString("DELETE FROM key_value WHERE querytype='%1' AND key='%2'").arg(mType).arg(actualKey);
    return Database::instance()->execQuery(queryStr, query);
}
