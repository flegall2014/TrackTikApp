#ifndef CAPIHANDLER_H
#define CAPIHANDLER_H
#include <QObject>

class CAPIHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool success READ success WRITE setSuccess NOTIFY successChanged)
    Q_PROPERTY(int error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY(double progress READ progress WRITE setProgress NOTIFY progressChanged)
    Q_PROPERTY(QString apiError READ apiError WRITE setAPIError NOTIFY apiErrorChanged)

public:
    CAPIHandler(QObject *parent=0);

    // Success:
    inline void onSuccess(const QString &response)
    {
        setResponse(response);
        setSuccess(true);
    }

    // API Error:
    inline void onAPIError(const QString &apiError)
    {
        setAPIError(apiError);
        setSuccess(false);
    }

    // Errors:
    inline void onError(int error, int errorCode)
    {
        mErrorCode = errorCode;
        setError(error);
    }

    // Progress changed:
    inline void onProgressChanged(double progress)
    {
        setProgress(progress);
    }

    // Get success:
    inline bool success() const
    {
        return mSuccess;
    }

    // Set success:
    inline void setSuccess(bool success)
    {
        mSuccess = success;
        emit successChanged();
    }

    // Get network error:
    inline int error() const
    {
        return mError;
    }

    // Set success:
    inline void setError(int error)
    {
        if (error > 0)
        {
            mError = error;
            emit errorChanged();
        }
    }

    // Get progress:
    inline double progress() const
    {
        return mProgress;
    }

    // Set progress;
    inline void setProgress(double progress)
    {
        if (mProgress != progress)
        {
            mProgress = progress;
            emit progressChanged();
        }
    }

    // Get api error:
    inline QString apiError()
    {
        return mAPIError;
    }

    // Set success:
    inline void setAPIError(const QString &error)
    {
        mAPIError = error;
        emit apiErrorChanged();
    }

    // Get response:
    Q_INVOKABLE inline QString response()
    {
        return mResponse;
    }

    // Set success:
    inline void setResponse(const QString &response)
    {
        mResponse = response;
    }

    // Return error code:
    Q_INVOKABLE inline int errorCode() const
    {
        return mErrorCode;
    }

private:
    bool mSuccess;
    QString mResponse;
    QString mAPIError;
    int mError;
    int mErrorCode;
    double mProgress;

signals:
    void successChanged();
    void errorChanged();
    void apiErrorChanged();
    void progressChanged();
};

#endif // CAPIHANDLER_H
