#include "form.h"
#include "json.h"
#include <QFile>
#include <QTextStream>
#include "utils.h"

// Constructor:
Form::Form(QObject *parent) :
    QObject(parent), d(new FormPrivate())
{
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
    return d->loadJSONString(jsonString);
}
