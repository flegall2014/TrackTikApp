#ifndef CAPIHANDLER_H
#define CAPIHANDLER_H
#include <QObject>

class CAPIHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool success READ getSuccess NOTIFY success)
    Q_PROPERTY(int error READ getError NOTIFY error)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QString apiError READ getAPIError NOTIFY apiError)

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
    }

    // Errors:
    inline void onError(int error, const QString &errorString)
    {
        mErrorString = errorString;
        setError(error);
    }

    // Progress changed:
    inline void onProgressChanged(double progress)
    {
        setProgress(progress);
    }

    // Get success:
    inline bool getSuccess() const
    {
        return mSuccess;
    }

    // Set success:
    inline void setSuccess(bool succ)
    {
        mSuccess = succ;
        emit success();
    }

    // Get network error:
    inline int getError() const
    {
        return mError;
    }

    // Set success:
    inline void setError(int err)
    {
        if (err > 0)
        {
            mError = err;
            emit error();
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
    inline QString getAPIError()
    {
        return mAPIError;
    }

    // Set success:
    inline void setAPIError(const QString &error)
    {
        mAPIError = error;
        emit apiError();
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

    // Return error string:
    Q_INVOKABLE inline QString errorString() const
    {
        return mErrorString;
    }

private:
    bool mSuccess;
    QString mResponse;
    QString mAPIError;
    int mError;
    QString mErrorString;
    double mProgress;

signals:
    void success();
    void error();
    void apiError();
    void progressChanged();
};

#endif // CAPIHANDLER_H
