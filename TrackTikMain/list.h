#ifndef LIST_H
#define LIST_H
#include <QObject>
#include <QVariant>
#include <QDebug>

class List : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList values READ values NOTIFY valuesChanged)

public:
    List(QObject *parent=0) : QObject(parent) {

    }

    // Clear:
    Q_INVOKABLE inline void clear() {
        mValues.clear();
        emit valuesChanged();
    }

    // Contains:
    Q_INVOKABLE inline bool contains(const QVariant &value) const {
        return mValues.contains(value);
    }

    // Add:
    Q_INVOKABLE inline void add(const QVariant &value) {
        mValues << value;
        emit valuesChanged();
    }

    // Remove:
    Q_INVOKABLE inline int remove(const QVariant &value) {
        int nRemoved = mValues.removeAll(value);
        if (nRemoved > 0)
            emit valuesChanged();
        return nRemoved;
    }

    // Return values:
    inline const QVariantList &values() const {
        return mValues;
    }

private:
    QVariantList mValues;

signals:
    void valuesChanged();
};

#endif // LIST_H
