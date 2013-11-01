//===========================================================================
// Summary:
//	    XMLSaxParser.h
// Usage:
//      定义XML的SAX解析器使用的回调函数类型
//  		...
// Remarks:
//	    null
// Date:
//	    2013-08-04
// Author:
//	    xk@qanzone.com
//===========================================================================

#ifndef __QZKERNEL_COMMONLIBS_XMLBASE_XMLSAXHANDLER_H__
#define __QZKERNEL_COMMONLIBS_XMLBASE_XMLSAXHANDLER_H__

//#include "QZKernelType.h"
#include "QZEpubPageDef.h"

typedef QZ_VOID (*StartElementHandler)(QZ_VOID* pUserData, const QZ_CHAR* pName, const QZ_CHAR** ppAttrs);
typedef QZ_VOID (*EndElementHandler)(QZ_VOID* pUserData, const QZ_CHAR* pName);

typedef QZ_VOID (*CharacterDataHandler)(QZ_VOID* pUserData, const QZ_CHAR* pData, QZ_INT length);

typedef QZ_VOID (*CommentHandler)(QZ_VOID* pUserData, const QZ_CHAR* pComment);

typedef QZ_VOID (*StartCDATAHandler)(QZ_VOID* pUserData);
typedef QZ_VOID (*EndCDATAHandler)(QZ_VOID* pUserData);

typedef QZ_VOID (*SkippedEntityHandler)(QZ_VOID* pUserData, const QZ_CHAR* pEntityName, QZ_INT isParamEntity);

typedef QZ_VOID (*StartNamespaceDeclHandler)(QZ_VOID* pUserData, const QZ_CHAR* pPrefix, const QZ_CHAR* pUri);
typedef QZ_VOID (*EndNamespaceDeclHandler)(QZ_VOID* pUserData, const QZ_CHAR* pPrefix);

typedef QZ_VOID (*XMLDeclarationHandler)(QZ_VOID* pUserData, const QZ_CHAR* pVersion, const QZ_CHAR* pEncoding, QZ_INT standalone);

#endif
