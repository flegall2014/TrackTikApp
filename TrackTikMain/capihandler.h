#ifndef CAPIHANDLER_H
#define CAPIHANDLER_H
#include <QObject>

class CAPIHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool success READ success WRITE setSuccess NOTIFY successChanged)
    Q_PROPERTY(int networkError READ networkError WRITE setNetworkError NOTIFY networkErrorChanged)
    Q_PROPERTY(double progress READ progress WRITE setProgress NOTIFY progressChanged)
    Q_PROPERTY(QString apiError READ apiError WRITE setAPIError NOTIFY apiErrorChanged)
    Q_PROPERTY(QString response READ response WRITE setResponse NOTIFY responseChanged)

public:
    CAPIHandler(QObject *parent=0);

    // Success:
    void onSuccess(const QString &response)
    {
        setResponse(response);
        setSuccess(true);
    }

    // API Error:
    void onAPIError(const QString &apiError)
    {
        setAPIError(apiError);
        setSuccess(false);
    }

    // Network errror:
    void onNetworkError(int error)
    {
        setNetworkError(error);
    }

    // Progress changed:
    void onProgressChanged(double progress)
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
    inline bool networkError() const
    {
        return mNetworkError;
    }

    // Set success:
    inline void setNetworkError(int error)
    {
        mNetworkError = error;
        emit networkErrorChanged();
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
    inline QString response()
    {
        return mResponse;
    }

    // Set success:
    inline void setResponse(const QString &response)
    {
        mResponse = response;
        emit responseChanged();
    }

private:
    bool mSuccess;
    QString mResponse;
    QString mAPIError;
    int mNetworkError;
    double mProgress;

signals:
    void successChanged();
    void networkErrorChanged();
    void apiErrorChanged();
    void responseChanged();
    void progressChanged();
};

#endif // CAPIHANDLER_H
