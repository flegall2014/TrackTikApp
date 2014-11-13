#include "setting.h"
#include "database.h"
#include "utils.h"
#include "json.h"

// Constructor:
Setting::Setting(QObject *parent) : QObject(parent),
    mQueryType("setting")
{

}

// Destructor:
Setting::~Setting() {
}

// Set:
bool Setting::set(const QString &key, const QVariant &value)
{
    return Database::instance()->set(key, value, mQueryType);
}

// Get:
QVariant Setting::get(const QString &key, const QString &defaultValue) const
{
    return Database::instance()->get(key, defaultValue, mQueryType);
}

// Remove:
bool Setting::remove(const QString &key)
{
    return Database::instance()->remove(key, mQueryType);
}
