#include "database.h"
#include <QObject>
#include <QtSql/QtSql>

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

// Close and remove:
void Database::closeAndRemove()
{
    delete sDataBase;
    sDataBase = 0;
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
        QString queryStr = "create table key_value (key TEXT PRIMARY KEY, value TEXT, datatype INTEGER, querytype TEXT, date TEXT)";
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
