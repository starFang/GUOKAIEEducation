//===========================================================================
// Summary:
//		XHTMLParser.h
// Usage:
//		Epub中XHtml解析
// Remarks:
//		Null
// Date:
//		2013-08-04
// Author:
//		xk@qanzone.com
//===========================================================================

#ifndef __QZKERNEL_COMMONLIBS_XMLBASE_HTMLSAXPARSER_H__
#define __QZKERNEL_COMMONLIBS_XMLBASE_HTMLSAXPARSER_H__

#include "XMLSaxHandler.h"
#pragma warning( disable : 4996)

class XHTMLSaxParser
{
public:
    XHTMLSaxParser();
    ~XHTMLSaxParser();

public:
    //-------------------------------------------
    //	Summary:
    //		创建 sax parser
    //	Parameters:
    //		[in] encoding			- the encoding
    //	Remarks:
    //		only call once
    //	Return Value:
    //		QZ_ReturnCode
    //-------------------------------------------
    QZ_BOOL CreateParser(QZ_CHAR* encoding = "UTF8");

    //-------------------------------------------
    //	Summary:
    //		destroy the parser;
    //	Parameters:
    //		null
    //	Remarks:
    //		null
    //	Return Value:
    //		QZ_VOID
    //-------------------------------------------
    QZ_VOID DestroyParser();

    //-------------------------------------------
    //	Summary:
    //		parse the buffer
    //	Parameters:
    //		[in] pHtmlBuffer		- the html buffer
    //      [in] length             - the buffer length
    //      [in] isLast             - if is the last piece of the buffer
    //	Remarks:
    //		null
    //	Return Value:
    //		HTMLSaxStatus
    //-------------------------------------------
    QZ_BOOL Parse(const QZ_CHAR* pHtmlBuffer, QZ_INT length, QZ_BOOL isLast = QZ_TRUE);

    //-------------------------------------------
    //	Summary:
    //		得到当前正在解析的位置在HTML中的字节偏移
    //	Parameters:
    //		null
    //	Remarks:
    //		For html segment, like: "<p>text</p>",
    //          when parsing start element p, the offset will be the start byte offset of "<p>";
    //          when parsing end element p, the offset will be the start byte offset of "</p>";
    //          when parsing text contained in the p tag,, the offset will be the start byte offset of "text".
    //      For html segment, like: "<br />"
    //          the offset will always be the start byte offset of "<br />"
    //	Return Value:
    //		QZ_LONG the byte offset
    //-------------------------------------------
    QZ_LONG GetCurByteOffset();

    //-------------------------------------------
    //	Summary:
    //		get current byte offset while parsing
    //	Parameters:
    //		null
    //	Remarks:
    //      Can be only called when parsing tag.
    //		For html segment, like: "<p>text</p>",
    //          when parsing start element p, the offset will be the end byte offset of "<p>";
    //          when parsing end element p, the offset will be the end byte offset of "</p>";
    //      For html segment, like: "<br />"
    //          the offset will always be the end byte offset of "<br />"
    //	Return Value:
    //		QZ_LONG the byte offset
    //-------------------------------------------
	QZ_LONG GetTagPostByteOffset();

public:
    //-------------------------------------------
    //	Summary:
    //		set the sax call backs
    //	Parameters:
    //		null
    //	Remarks:
    //		if using, must be called before CreateParser
    //	Return Value:
    //		QZ_VOID
    //-------------------------------------------
    QZ_VOID SetStartElementHandler(StartElementHandler startElementHndl);
    QZ_VOID SetEndElementHandler(EndElementHandler endElementHndl);
    QZ_VOID SetCharacterDataHandler(CharacterDataHandler characterHndl);

public:
    //-------------------------------------------
    //	Summary:
    //		set the user data
    //	Parameters:
    //		[in]userData       - the pointer to the user data
    //	Remarks:
    //		if using, Must be called before Parse
    //	Return Value:
    //		QZ_VOID
    //-------------------------------------------
    QZ_VOID SetUserData(QZ_VOID* pUserData);

	//-------------------------------------------
	//	Summary:
	//		get the parser object
	//	Parameters:
	//		Null
	//	Remarks:
	//		返回该指针用于后面解析的判断
	//	Return Value:
	//		QZ_VOID
	//-------------------------------------------
	QZ_VOID* GetParserContext();

private:
    QZ_VOID* m_pHandler;
    QZ_VOID* m_pUserData;
    QZ_VOID* m_pParserContext;

};

#endif
