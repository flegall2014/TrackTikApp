#ifndef CAPIHANDLER_H
#define CAPIHANDLER_H
#include <QObject>

class CAPIHandler : public QObject
{
    Q_OBJECT
    Q_ENUMS(ErrorType)
    Q_PROPERTY(bool success READ getSuccess NOTIFY success)
    Q_PROPERTY(int error READ getErrorType NOTIFY error)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)

public:
    enum ErrorType {
        None,
        FileError,
        NetworkError,
        ApiError
    };

    CAPIHandler(QObject *parent=0);

    // Success:
    inline void onSuccess(const QString &response)
    {
        setResponse(response);
        setSuccess(true);
    }

    // Errors:
    inline void onError(const ErrorType &errorType, const QString &errorString)
    {
        mErrorString = errorString;
        setErrorType(errorType);
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
    inline ErrorType getErrorType() const
    {
        return mErrorType;
    }

    // Set success:
    inline void setErrorType(const ErrorType &errorType)
    {
        if (errorType != None)
        {
            mErrorType = errorType;
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
    ErrorType mErrorType;
    QString mErrorString;
    double mProgress;

signals:
    void success();
    void error();
    void apiError();
    void progressChanged();
};

#endif // CAPIHANDLER_H
