#ifndef SESSION_H
#define SESSION_H
#include <QObject>
#include "database.h"

class Session: public QObject {
    Q_OBJECT

public:
    // Constructor:
    Session(QObject *parent=0);

    // Destructor:
    virtual ~Session();

    // Set:
    Q_INVOKABLE bool set(const QString &key, const QVariant &value);

    // Get:
    Q_INVOKABLE QVariant get(const QString &key, const QString &defaultValue="") const;

    // Remove:
    Q_INVOKABLE bool remove(const QString &key);

    // Clear all:
    Q_INVOKABLE void clearAll();

protected:
    // Type (Setting/Session):
    QString mQueryType;
};

#endif /* SESSION_H */
