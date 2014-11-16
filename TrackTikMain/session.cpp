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
    return Database::instance()->set(Utils::getKey(key), value, mQueryType);
}

// Get:
QVariant Session::get(const QString &key, const QString &defaultValue) const
{
    return Database::instance()->get(Utils::getKey(key), defaultValue, mQueryType);
}

// Remove:
bool Session::remove(const QString &key)
{
    return Database::instance()->remove(Utils::getKey(key), mQueryType);
}

// Clear:
void Session::clearAll()
{
    return Database::instance()->clearAll(mQueryType);
}

// Does session have feature?
bool Session::hasFeature(const QString &featureName) const
{
    return Database::instance()->hasKey(mQueryType, "feature_"+Utils::getKey(featureName));
}
