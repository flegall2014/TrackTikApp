#include "httppostfield.h"
#include <QDebug>

// Constructor:
HttpPostField::HttpPostField(QObject * parent)
    : QObject(parent),
      mType(FieldInvalid),
      mInstancedFromQml(true)
{
}

// Destructor:
HttpPostField::~HttpPostField()
{
}

// Return name:
QString HttpPostField::name() const
{
    return mName;
}

// Set name:
void HttpPostField::setName(const QString& name)
{
    if( mName != name ) {
        mName = name;
        emit nameChanged();
    }
}

// Return type:
HttpPostField::FieldType HttpPostField::type() const
{
    return mType;
}

// Set type:
void HttpPostField::setType(HttpPostField::FieldType type)
{
    mType = type;
}

