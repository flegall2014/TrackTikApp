#ifndef SETTING_H
#define SETTING_H
#include <QObject>
#include "database.h"

class Setting: public QObject {
    Q_OBJECT

public:
    // Constructor:
    Setting(QObject *parent=0);

    // Destructor:
    virtual ~Setting();

    // Set:
    Q_INVOKABLE bool set(const QString &key, const QVariant &value);

    // Get:
    Q_INVOKABLE QVariant get(const QString &key, const QString &defaultValue="") const;

    // Remove:
    Q_INVOKABLE bool remove(const QString &key);

protected:
    // Type (session/setting):
    QString mQueryType;
};

#endif /* SETTING_H */
