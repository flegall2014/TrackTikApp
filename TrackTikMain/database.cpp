#include "database.h"
#include <QObject>
#include <QtSql/QtSql>
#include "utils.h"

Database *Database::sDataBase = 0;

// Constructor:
Database::Database() : mIsConnected(false)
{
}

// Copy ctor:
Database::Database(const Database &db)
{
    Q_UNUSED(db);
}

// Destructor:
Database::~Database()
{
    mDB.close();
    QSqlDatabase::removeDatabase(DATABASE_FILENAME);
}

// Initialize:
bool Database::initialize()
{
    // Set DB name:
    mDBName = QDir::homePath() + "/" + DATABASE_FILENAME;

    // Add DB:
    mDB = QSqlDatabase::addDatabase(DATABASE_DRIVER, DATABASE_CONNECTION_NAME);

    // Set DB name:
    mDB.setDatabaseName(mDBName);

    // Check DB:
    if (!mDB.isValid())
    {
        qDebug() << "Could not set data base name probably due to invalid driver.";
        return false;
    }

    // Open:
    if (!mDB.open())
    {
        qWarning() << "Could not open connection to database: " << mDB.lastError().text();
        return false;
    }

    // DB created?
    if (mDB.tables().isEmpty())
    {
        if (!createDataTable())
        {
            qWarning() << "Could not create data table: " << mDB.lastError().text();
            return false;
        }
    }

    qDebug() << "Opened susccessfully.";
    qDebug() << "Tables: " << mDB.tables();

    mIsConnected = true;

    return true;
}

// Instance:
Database *Database::instance()
{
    if (!sDataBase)
    {
        // Create DB:
        sDataBase = new Database();

        // Initialize:
        sDataBase->initialize();
    }

    return sDataBase;
}

// Return DB:
QSqlDatabase &Database::db()
{
    return mDB;
}

// Create data table:
bool Database::createDataTable()
{
    // Create table:
    if (mDB.isOpen())
    {
        QString queryStr = "create table key_value (key TEXT, value TEXT, datatype INTEGER, querytype TEXT, date TEXT, jsonencoded BOOLEAN)";
        QSqlQuery query;
        if (!execQuery(queryStr, query))
        {
            qWarning() << "Could not create data table: " << query.lastError().databaseText()
                << query.lastError().driverText();
            return false;
        }
    }

    return true;
}

// Return connected status:
bool Database::isConnected()
{
    return mIsConnected;
}

// Execute a query:
bool Database::execQuery(const QString &queryStr, QSqlQuery &query) const
{
    // Build query:
    query = QSqlQuery(queryStr, mDB.database(DATABASE_CONNECTION_NAME));
    if (query.lastError().isValid())
    {
        qDebug() << query.lastError().databaseText() << query.lastError().driverText();
        return false;
    }

    return true;
}

// Execute a query:
bool Database::execQuery(QSqlQuery &query) const
{
    if (!query.exec())
    {
        qDebug() << query.lastError().databaseText() << query.lastError().driverText();
        return false;
    }
    return true;
}

// Save as JSON:
bool Database::saveAsJSON(const QString &key, const QVariant &value, const QString &queryType)
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

    // Check conversion to QVariantMap:
    if (!value.canConvert<QVariantMap>())
        return false;
    QVariantMap vMap = value.toMap();

    // Build JSON object:
    QJsonObject jsonObject = QJsonObject::fromVariantMap(vMap);
    QJsonDocument jsonDoc(jsonObject);

    // Prepare query:
    QSqlQuery query(mDB.database(DATABASE_CONNECTION_NAME));
    query.prepare("INSERT OR REPLACE INTO key_value (key, value, datatype, querytype, date, jsonencoded) VALUES (:key, :value, :datatype, :querytype, :date, :jsonencoded)");
    query.bindValue(":key", actualKey);

    // Save JSON doc:
    query.bindValue(":value", jsonDoc.toJson());

    // Save data type:
    query.bindValue(":datatype", (int)dType);

    // Save query type:
    query.bindValue(":querytype", queryType);

    // Save date:
    QString now = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    query.bindValue(":date", now);

    // Save jsonEncoded:
    query.bindValue(":jsonencoded", true);

    // Exec query:
    return execQuery(query);
}

// Read from JSON:
QVariant Database::readFromJSON(const QVariant &value) const
 {
    if (!value.isValid())
        return QVariant();

    // Convert JSON string to the Variant that QML expects
    QJsonDocument json(QJsonDocument::fromJson(value.toByteArray()));
    return json.object().toVariantMap();
}

// Set:
bool Database::set(const QString &key, const QVariant &value, const QString &queryType)
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

    // Special case, input is a QVariantMap:
    QString jsonString = "";
    bool jsonEncoded = false;

    // Encode QVariantMap to JSON:
    if (value.canConvert<QVariantMap>())
        return saveAsJSON(key, value, queryType);

    // Get current datatime:
    QString now = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");

    // Build query string:
    QString queryStr = QString("INSERT OR REPLACE INTO key_value(key, value, datatype, querytype, date, jsonencoded) VALUES('%1', '%2', '%3', '%4', '%5', '%6')").arg(actualKey).
        arg(jsonEncoded ? jsonString : value.toString()).arg((int)dType).arg(queryType).arg(now).arg(jsonEncoded);
    QSqlQuery query;

    // Exec query:
    return execQuery(queryStr, query);
}

// Get:
QVariant Database::get(const QString &key, const QString &defaultValue, const QString &queryType) const
{
    // Check key:
    QString actualKey = Utils::getKey(key);
    if (actualKey.isEmpty())
        return false;

    QSqlQuery query;
    QString queryStr = QString("SELECT value, datatype, jsonencoded FROM key_value WHERE querytype='%1' AND key='%2'").arg(queryType).arg(actualKey);
    if (!execQuery(queryStr, query))
        return QVariant();

    // Return result:
    bool ok = true;
    if (query.next())
    {
        // Read value:
        QVariant value = query.value("value");
        if (!value.isValid())
            return QVariant();

        // JSON encoded?
        bool jsonEncoded = query.value("jsonencoded").toBool();
        if (jsonEncoded)
            return readFromJSON(value);

        // Read data type:
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
bool Database::remove(const QString &key, const QString &queryType)
{
    // Check key:
    QString actualKey = Utils::getKey(key);
    if (actualKey.isEmpty())
        return false;

    QSqlQuery query;
    QString queryStr = QString("DELETE FROM key_value WHERE querytype='%1' AND key='%2'").arg(queryType).arg(actualKey);
    return Database::instance()->execQuery(queryStr, query);
}

// Clear all:
void Database::clearAll(const QString &queryType)
{
    QSqlQuery query;
    QString queryStr = QString("DELETE FROM key_value WHERE querytype='%1'").arg(queryType);
    execQuery(queryStr, query);
}
