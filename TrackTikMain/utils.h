#ifndef UTILS_H
#define UTILS_H
#include <QString>

class Utils
{
public:
    // Get key:
    static QString getKey(const QString &input)
    {
        return QString(input).remove(" ").toLower();
    }
};

#endif // UTILS_H
