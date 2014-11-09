#include "capihandler.h"

CAPIHandler::CAPIHandler(QObject *parent) :
    QObject(parent), mSuccess(false), mResponse(""),
    mErrorType(None), mErrorString(""), mProgress(0)
{
}
