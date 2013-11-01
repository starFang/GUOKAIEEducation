//===========================================================================
// Summary:
//		XHTMLSaxParser.cpp
// Usage:
//		Epub中XHtml解析CPP实现
// Remarks:
//		Null
// Date:
//		2013-08-04
// Author:
//		chenjunfa@qanzone.com
//===========================================================================


#include "XHTMLSaxParser.h"
extern "C"
{
#include <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/parserInternals.h>
};
#include <iostream>
#include <fstream>
using namespace std;

//构造函数初始化成员变量
XHTMLSaxParser::XHTMLSaxParser():m_pHandler(NULL),m_pUserData(NULL),m_pParserContext(NULL)
{
}

//析构函数释放内存
XHTMLSaxParser::~XHTMLSaxParser()
{
	//释放内存
	DestroyParser();
}

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
QZ_BOOL XHTMLSaxParser::CreateParser(QZ_CHAR* encoding)
{
	if(m_pHandler == QZ_NULL)
	{
		m_pHandler = QZ_MALLOCZ_OBJ(htmlSAXHandler);
		if (m_pHandler == QZ_NULL)
		{
			return false;
		}
	}

	return QZ_TRUE;
}

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
QZ_VOID XHTMLSaxParser::DestroyParser()
{
	if (m_pHandler != QZ_NULL)
	{
		delete m_pHandler;
		m_pHandler = QZ_NULL;
	}

	
	//释放上下文设备
	if (m_pParserContext != QZ_NULL)
	{
		xmlDocPtr doc = htmlParserCtxtPtr(m_pParserContext)->myDoc;
		htmlFreeParserCtxt((htmlParserCtxtPtr)m_pParserContext);
		m_pParserContext = QZ_NULL;

		//释放doc
		xmlFreeDoc(doc);
		xmlCleanupParser();
	}

	m_pUserData = QZ_NULL;
}

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
QZ_BOOL XHTMLSaxParser::Parse(const QZ_CHAR* pHtmlBuffer, QZ_INT length, QZ_BOOL isLast)
{
	//输入数据为空则返回失败
	if(pHtmlBuffer==NULL || length < 0)
	{
		return QZ_TRUE;
	}

	//创建环境设备上下文htmlParserCtxtPtr
	if (m_pParserContext == QZ_NULL)
	{
		m_pParserContext = htmlCreatePushParserCtxt((htmlSAXHandlerPtr)m_pHandler,m_pUserData, pHtmlBuffer, length, NULL,XML_CHAR_ENCODING_UTF8);  
		htmlCtxtUseOptions((htmlParserCtxtPtr)m_pParserContext,HTML_PARSE_RECOVER | HTML_PARSE_NOWARNING | HTML_PARSE_NONET); 
		length = 0;
	}

	//开始解析
	htmlParseChunk((htmlParserCtxtPtr)m_pParserContext, pHtmlBuffer, length,isLast); 

	return QZ_TRUE;
}

//-------------------------------------------
//	Summary:
//		得到当前正在解析的位置在HTML中的字节偏移
//	Parameters:
//		[in] ctx		- 回调函数中的第一个参数
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
QZ_LONG XHTMLSaxParser::GetCurByteOffset()
{
	return xmlByteConsumed((htmlParserCtxtPtr)m_pParserContext);
}

//-------------------------------------------
//	Summary:
//		get current byte offset while parsing
//	Parameters:
//		[in] ctx				- 回调函数中的第一个参数
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
QZ_LONG XHTMLSaxParser::GetTagPostByteOffset()
{
	htmlParserCtxtPtr ctxt = (htmlParserCtxtPtr)m_pParserContext;
	long pos = xmlByteConsumed(ctxt);

	//如果是开始结束标签需要寻找前面的'<'作为开始位置
	if (XML_PARSER_START_TAG == ctxt->instate ||
			 XML_PARSER_END_TAG == ctxt->instate)
	{
		int i = 0;
		const xmlChar* pBase = ctxt->input->base;
		const xmlChar* pCur = ctxt->input->cur;
		while(*(pCur-++i) != '<' && pCur-i > pBase);

		return pos-i;
	}

	//某些情况下会将开始/结束标签标记成内容标签，做一些处理
	if (XML_PARSER_CONTENT ==ctxt->instate )
	{
		int i = 0;
		const xmlChar* pBase = ctxt->input->base;
		const xmlChar* pCur = ctxt->input->cur;
		while(*(pCur-++i) != '>' && pCur-i > pBase);

		return pos-i+1;
	}




	return pos;
}


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
QZ_VOID XHTMLSaxParser::SetStartElementHandler(StartElementHandler startElementHndl)
{
	htmlSAXHandlerPtr(m_pHandler)->startElement = (startElementSAXFunc)startElementHndl;
}

//--------------------------------------------------------

QZ_VOID XHTMLSaxParser::SetEndElementHandler(EndElementHandler endElementHndl)
{
	htmlSAXHandlerPtr(m_pHandler)->endElement = (endElementSAXFunc)endElementHndl;
}

//--------------------------------------------------------

QZ_VOID XHTMLSaxParser::SetCharacterDataHandler(CharacterDataHandler characterHndl)
{
	htmlSAXHandlerPtr(m_pHandler)->characters = (charactersSAXFunc)characterHndl;
}

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
QZ_VOID XHTMLSaxParser::SetUserData(QZ_VOID* pUserData)
{
	m_pUserData = pUserData;
}

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
QZ_VOID* XHTMLSaxParser::GetParserContext()
{
	return m_pParserContext;
}

