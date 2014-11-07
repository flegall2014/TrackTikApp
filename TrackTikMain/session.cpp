#include "session.h"
#include "database.h"
#include "utils.h"

// Constructor:
Session::Session(QObject *parent) : Setting(parent)
{
    mType = "session";
}

// Destructor:
Session::~Session() {
}

// Clear:
void Session::clearAll()
{
    QSqlQuery query;
    QString queryStr = QString("DELETE FROM key_value WHERE querytype='%1'").arg(mType);
    Database::instance()->execQuery(queryStr, query);
}
