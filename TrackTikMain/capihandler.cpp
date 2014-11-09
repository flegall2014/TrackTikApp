#include "capihandler.h"
bool mSuccess;
QString mResponse;
QString mAPIError;
int mError;
int mErrorCode;
double mProgress;

CAPIHandler::CAPIHandler(QObject *parent) :
    QObject(parent), mSuccess(false), mResponse(""),
    mAPIError(""), mError(0), mErrorString(""), mProgress(0)
{
}
