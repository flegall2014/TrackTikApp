#include "session.h"
#include "database.h"
#include "utils.h"

// Constructor:
Session::Session(QObject *parent) : QObject(parent),
    mQueryType("session")
{
}

// Destructor:
Session::~Session() {
}

// Set:
bool Session::set(const QString &key, const QVariant &value)
{
    return Database::instance()->set(key, value, mQueryType);
}

// Get:
QVariant Session::get(const QString &key, const QString &defaultValue) const
{
    return Database::instance()->get(key, defaultValue, mQueryType);
}

// Remove:
bool Session::remove(const QString &key)
{
    return Database::instance()->remove(key, mQueryType);
}

// Clear:
void Session::clearAll()
{
    return Database::instance()->clearAll(mQueryType);
}
