#ifndef DATAMGR_H
#define DATAMGR_H
#include "iservice.h"
#include "form.h"
#include <QDir>
#include <QUuid>
class System;

class DataMgr : public QObject, public IService
{
    Q_OBJECT
    Q_PROPERTY(int nForms READ nForms NOTIFY nFormsChanged)

public:
    friend class System;

    // Startup:
    bool startup();

    // Shutdown:
    void shutdown();

    // Return home dir:
    Q_INVOKABLE inline QString homeDir() const {
        return QDir::home().canonicalPath();
    }

    // File exists?
    Q_INVOKABLE bool fileExists(const QString &fileName) const {
        return QFile::exists(fileName);
    }

    // Build a single form:
    Q_INVOKABLE QObject *buildForm(const QString &jsonForm);

    // Build form:
    Q_INVOKABLE void buildForms(const QStringList &forms);

    // Return form at index:
    Q_INVOKABLE inline QObject *form(int index) const
    {
        if ((index < 0) || (index > (mForms.size()-1)))
            return 0;
        return mForms[index];
    }

    // Generate UID:
    Q_INVOKABLE inline QString generateUID() const
    {
        QString uid = QUuid::createUuid().toString();
        uid.replace("{", "");
        uid.replace("}", "");
        return uid;
    }

private:
    // Constructor:
    DataMgr(System *system=0);

    // Prevent copy construction:
    DataMgr(const DataMgr &other);

    // Prevent assignment:
    DataMgr &operator=(const DataMgr &other);

    // Return number of forms:
    inline int nForms() const {
        return mForms.size();
    }

private:
    // System:
    System *mSystem;

    // Forms:
    QList<Form *> mForms;

signals:
    void nFormsChanged();
    void update(const QString &fieldId);
};

#endif // DATAMGR_H
