#ifndef SESSION_H
#define SESSION_H
#include "database.h"
#include "setting.h"

class Session: public Setting {
    Q_OBJECT

public:
    // Constructor:
    Session();

    // Destructor:
    virtual ~Session();

    // Clear all:
    Q_INVOKABLE void clearAll();
};

#endif /* SESSION_H */
