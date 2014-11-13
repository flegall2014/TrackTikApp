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

    // Return DB:
    QSqlDatabase &db();

    // Initialize:
    bool initialize();

    // Connected status:
    bool isConnected();

    // Set:
    bool set(const QString &key, const QVariant &value, const QString &queryType);

    // Get:
    QVariant get(const QString &key, const QString &defaultValue, const QString &queryType) const;

    // Remove:
    bool remove(const QString &key, const QString &queryType);

    // Clear all:
    void clearAll(const QString &queryType);

private:
    // Use instance() method:
    Database();

    // Copy ctor:
    Database(const Database& db);

    // Destructor:
    ~Database ();

    // Create data table:
    bool createDataTable();

    // Execute a query:
    bool execQuery(const QString &queryStr, QSqlQuery &query) const;

    // Execute a query:
    bool execQuery(QSqlQuery &query) const;

    // Save as JSON:
    bool saveAsJSON(const QString &key, const QVariant &value, const QString &queryType);

    // Read from JSON:
    QVariant readFromJSON(const QVariant &value) const;

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
