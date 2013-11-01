#ifndef _QZKERNEL_EPUBKIT_EPUBLIB_INCLUDE_CSSCOMMONFUN_H_
#define _QZKERNEL_EPUBKIT_EPUBLIB_INCLUDE_CSSCOMMONFUN_H_

#include <iostream>
#include <string>
#include <map>
#include <vector>
//#include "QZKernelType.h"
#include "QZEpubPageDef.h"

extern std::string str_replace(const std::string find, const std::string replace, std::string str);

extern QZ_BOOL ctype_space(const QZ_CHAR c);

const std::string trim(const std::string istring);

std::vector<std::string> split(const std::string sString,QZ_CHAR C);

std::vector<std::string> split(const std::string sString,std::string strSplit);

std::vector<std::string> splitWithQuoteString(const std::string sString,QZ_CHAR C);

QZ_CHAR s_at(const std::string &istring, const QZ_LONG pos);

QZ_BOOL ctype_digit(const QZ_CHAR c);

QZ_BOOL ctype_xdigit(QZ_CHAR c);

QZ_BOOL ctype_alpha(QZ_CHAR c);

QZ_BOOL StrICompare(std::string str1,std::string str2);

QZ_BOOL IntegerNumberCheck(std::string strValue);

QZ_BOOL FloatNumberCheck(std::string strValue);

QZ_BOOL PercentIntegerCheck(std::string strValue);

QZ_BOOL PercentFloatNumberCheck(std::string strValue);

QZ_DOUBLE StringToDouble(std::string strDouble);

QZ_LONG	StringToLongInt(std::string strLong);

QZ_INT	StringToInt(std::string strInt);

QZ_ARGBCOLOR StringToARGBColor(std::string strColor);

std::string GetBase16Name(std::string filename);

#endif//_QZKERNEL_EPUBKIT_EPUBLIB_INCLUDE_CSSCOMMONFUN_H_
