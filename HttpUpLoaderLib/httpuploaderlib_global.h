#ifndef HTTPUPLOADERLIB_GLOBAL_H
#define HTTPUPLOADERLIB_GLOBAL_H
#include <QtCore/qglobal.h>

#if defined(HTTPUPLOADERLIB_LIBRARY)
#  define HTTPUPLOADERLIBSHARED_EXPORT Q_DECL_EXPORT
#else
#  define HTTPUPLOADERLIBSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // HTTPUPLOADERLIB_GLOBAL_H
