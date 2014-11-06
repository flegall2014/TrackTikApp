#ifndef DATABASE_H_
#define DATABASE_H_

#include <QtSql/QtSql>

#define APPLICATION_VERSION "0.0.1"
#define DATABASE_DRIVER "QSQLITE"
#define DATABASE_CONNECTION_NAME "tracktik"
#define DATABASE_FILENAME "tracktik.sql3"
#define DATABASE_VERSION "1"
#define DATABASE_VERSION_APPBUILD "1"

class Database
{
public:
    // Return instance:
    static Database *instance();

    // Close & remove:
    static void closeAndRemove();

    // Return DB:
    QSqlDatabase &db();

    // Initialize:
    bool initialize();

    // Connected status:
    bool isConnected();

    // Execute a query:
    bool execQuery(const QString &queryStr, QSqlQuery &query) const;

private:
    // Use instance() method:
    Database();

    // Copy ctor:
    Database(const Database& db);

    // Destructor:
    ~Database ();

    // Create data table:
    bool createDataTable();

private:
    // DB:
    QSqlDatabase mDB;

    // Connection status:
    bool mIsConnected;

    // DB name:
    QString mDBName;

    // Data base:
    static Database *sDataBase;
};

#endif /* DATABASE_H_ */
