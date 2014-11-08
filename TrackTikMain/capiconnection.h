#ifndef CAPICONNECTION_H
#define CAPICONNECTION_H
#include <QObject>
class System;
class CAPIHandler;
class HttpUploader;
class Form;

class CAPIConnection : public QObject
{
    Q_OBJECT
    Q_PROPERTY(CAPIHandler *handler READ handler WRITE setHandler NOTIFY handlerChanged)
    Q_PROPERTY(QString apiCall READ apiCall WRITE setApiCall NOTIFY apiCallChanged)

public:
    // Constructor:
    explicit CAPIConnection(QObject *parent = 0);

    // Add field:
    Q_INVOKABLE void addField(const QString &fieldName, const QVariant &fieldValue);

    // Add field:
    Q_INVOKABLE void addFile(const QString &fieldName, const QString &fileName);

    // Call the connection:
    Q_INVOKABLE void call(const QString &url="");

private:
    // Get handler:
    CAPIHandler *handler() const
    {
        return mHandler;
    }

    // Set handler:
    inline void setHandler(CAPIHandler *handler)
    {
        if (handler != mHandler)
        {
            mHandler = handler;
            emit handlerChanged();
        }
    }

    // Get api call:
    inline QString apiCall() const
    {
        return mAPICall;
    }

    // Set api call:
    inline void setApiCall(const QString &apiCall)
    {
        mAPICall = apiCall;
        emit apiCallChanged();
    }

    // Setup connections:
    void setupConnections();

    // Before submit:
    void beforeSubmit();

private:
    // System:
    System *mSystem;

    // Handler:
    CAPIHandler *mHandler;

    // HTTP uploader:
    HttpUploader *mHttpUploader;

    // API call:
    QString mAPICall;

signals:
    void handlerChanged();
    void apiCallChanged();

    void progressChanged(double progress);
    void stateChanged();
    void networkErrorChanged();

private slots:
    void onProgressChanged();
    void onStateChanged();
    void onNetworkErrorChanged();
};

#endif // CAPICONNECTION_H
