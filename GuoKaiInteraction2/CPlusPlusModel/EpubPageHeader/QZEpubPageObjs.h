//===========================================================================
// Summary:
//     epub中页面中的各种交互对象的定义
// Usage:
//     Null
// Remarks:
//     Null
// Date:
//     2013-09-17
// Author:
//     chenjunfa(chenjunfa@qanzone.com)
//===========================================================================

#ifndef _QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGEOBJS_H_
#define _QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGEOBJS_H_

//#include "QZKernelBaseType.h"
//#include "QZKernelRenderType.h"
//#include "QZCSSDef.h"
#include "QZEpubPageDef.h"
#include <string>
#include <vector>

//题目类型
enum PageQuestionType
{
	PAGE_QUESTION_CHOICE,		//选择题
	PAGE_QUESTION_DRUG,			//拖动题 文字拖到图片的远点撒很难过
	PAGE_QUESTION_FILE_BLANK,	//填空题
	PAGE_QUESTION_BRIEF_ANSWER,	//简答题
	PAGE_QUESTION_CONNECTION,	//连线题
	PAGE_QUESTION_SORT,			//排序题
	PAGE_QUESTION_IMAGE_CHOICE	//图像排序题
};

//对象类型
enum PageElementType
{
	PAGE_OBJECT_DEFAULT,//默认情况下是文字
	PAGE_OBJECT_CHARACTER,
	PAGE_OBJECT_TOOL_TIP,
	PAGE_OBJECT_TOOL_IMAGE_TIP,
	PAGE_OBJECT_NAV_RECT,
	PAGE_OBJECT_NAV_BUTTON,
	PAGE_OBJECT_VIDEO,
	PAGE_OBJECT_QUESTION_LIST,
	PAGE_OBJECT_IMAGE,
	PAGE_OBJECT_IMAGE_LIST,
	PAGE_OBJECT_VOICE,
	PAGE_OBJECT_TEXT_ROLL,
	PAGE_OBJECT_WEB_LINK
};

//富文本piece类型
enum PageRichTextPieceType
{
	PAGE_RICH_TEXT_PIECE_TEXT,
	PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN,
	PAGE_RICH_TEXT_PIECE_PARAGRAPH_END,
	PAGE_RICH_TEXT_PIECE_DOT
};

//内容
struct PageRIchTextPieceText
{
	PageRichTextPieceType pieceType;	//文本类型

	//当piece == PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN/PAGE_RICH_TEXT_PIECE_PARAGRAPH_END有效
	QZ_INT nLength;							

	//当piece == PAGE_RICH_TEXT_PIECE_TEXT有效
	QZ_ARGBCOLOR	fontColor;
	QZ_INT			fontSize;		//ipad数学长度
	std::string		fontFamily;		
	QZ_BOOL			isItalic;
	QZ_BOOL			isBold;
	std::string		strText;

	PageRIchTextPieceText():pieceType(PAGE_RICH_TEXT_PIECE_TEXT),nLength(0),
		fontSize(0),isItalic(QZ_FALSE),isBold(QZ_FALSE)
	{}
};

//富文本定义
struct PageRichText
{
	QZ_BOOL								isRichText;
	std::string							strText;
	std::vector<PageRIchTextPieceText>	vTextItemList;

	PageRichText():isRichText(QZ_FALSE)
	{}
};


//三级索引
struct BookIndex
{
	QZ_LONG nChapter;
	QZ_LONG nPage;
	QZ_LONG nCharacter;

	BookIndex():nChapter(0),nPage(0),nCharacter(0)
	{}
};

//页面对象基类
struct PageBaseElements
{
	PageElementType m_elementType;
	QZ_BOX rect;

	PageBaseElements(PageElementType elementType = PAGE_OBJECT_TOOL_TIP):m_elementType(elementType)
	{}

	virtual ~PageBaseElements()
	{}
};

//划线文字
struct PageCharacter:public PageBaseElements
{
	//TODO:变为三级索引
	BookIndex	nIndex;
	PageCharacter():PageBaseElements(PAGE_OBJECT_CHARACTER)
	{}
};

//文字、图片提示1
struct PageToolTip:public PageBaseElements
{
	QZ_LONG						nWidth;
	QZ_LONG						nHeight;
	QZ_ARGBCOLOR				bgColor;		
	PageRichText				strTipText;
	std::string					strBtnImage;
	std::string					strBtnText;
	PageToolTip():PageBaseElements(PAGE_OBJECT_TOOL_TIP),nWidth(0),nHeight(0)
	{}
};

//图片提示1~2
struct PageToolImageTip:public PageBaseElements
{
	QZ_LONG						nWidth;
	QZ_LONG						nHeight;
	std::string					strBtnImage;
	std::string					strBtnText;
	std::string					filePath;

	PageToolImageTip():PageBaseElements(PAGE_OBJECT_TOOL_IMAGE_TIP),nWidth(0),nHeight(0)
	{}
};


//指向书内章节页面的对象 2
struct PageNavRect:public PageBaseElements
{
	QZ_INT		nChapterIndex;
	QZ_INT		nPageIndex;

	PageNavRect():PageBaseElements(PAGE_OBJECT_NAV_RECT),nChapterIndex(0),nPageIndex(0)
	{}
};

//图片导航按钮
struct PageNavChildButton
{
	QZ_INT		nChapterIndex;
	QZ_INT		nPageIndex;
	std::string	strBtnText;
	PageNavChildButton():nChapterIndex(0),nPageIndex(0)
	{}
};

//导航按钮3
struct PageNavButton:public PageBaseElements
{
	std::string						strTipText;
	QZ_LONG							nWidth;
	QZ_LONG							nHeight;
	std::vector<PageNavChildButton> vBtnList;

	PageNavButton():PageBaseElements(PAGE_OBJECT_NAV_BUTTON),nWidth(0L),nHeight(0L)
	{}
};

//视频类型4
struct PageVideo:public PageBaseElements
{
	PageRichText	stTitle;
	std::string		strPath;
	std::string		strStartImage;

	PageVideo():PageBaseElements(PAGE_OBJECT_VIDEO)
	{}
};

//题目 
struct PageQuestionBase
{
	PageQuestionType	eType;

	PageQuestionBase(PageQuestionType type):eType(type)
	{}
};

//选择题类型
struct PageQuestionChoice: public PageQuestionBase
{
	std::string					strQuestion;
	std::vector<std::string>	vChoices;
	std::vector<QZ_INT>			vAnswer;
	PageQuestionChoice():PageQuestionBase(PAGE_QUESTION_CHOICE)
	{}
};

//拖动题 圆点节点
struct PageQuestionDragPoint
{
	QZ_BOX	rect;
	QZ_INT	nAnswer;
	PageQuestionDragPoint():nAnswer(0)
	{}
};

//拖动题 文字拖到图片上
struct PageQuestionDrag: public PageQuestionBase
{
	std::string							strBackGroundImage;
	std::string							strQuestion;
	std::vector<PageQuestionDragPoint>	vImageSide;
	std::vector<std::string>			vStringSide;
	
	PageQuestionDrag():PageQuestionBase(PAGE_QUESTION_DRUG)
	{}
};

//填空题 节点
struct PageQuestionFillBlankItem
{
	QZ_BOOL isAnswer;
	std::string strText;

	PageQuestionFillBlankItem():isAnswer(QZ_FALSE)
	{}
};

//填空题
struct PageQuestionFillBlank:public PageQuestionBase
{
	std::vector<PageQuestionFillBlankItem> vDescription;

	PageQuestionFillBlank():PageQuestionBase(PAGE_QUESTION_FILE_BLANK)
	{}
};

//简答题brief answer

struct PageQuestionBriefAnswer:public PageQuestionBase
{
	std::string					strQuestion;
	std::string					vStrAnswer;
	
	PageQuestionBriefAnswer():PageQuestionBase(PAGE_QUESTION_BRIEF_ANSWER)
	{}
};

//连线题connection question
struct PageQuestionConnection:public PageQuestionBase
{
	std::string					strQuestion;
	std::vector<std::string>    vLeftSide;
	std::vector<std::string>    vRightSide;
	std::vector<QZ_INT>         vAnswers;

	PageQuestionConnection():PageQuestionBase(PAGE_QUESTION_CONNECTION)
	{}
};

//排序题sort question
struct PageQuestionSort:public PageQuestionBase
{
	std::string                 strQuestion;
	std::vector<std::string>    vStrTexts;
	std::vector<QZ_INT>         vSortedList;

	PageQuestionSort():PageQuestionBase(PAGE_QUESTION_SORT)
	{}
};

//图像选择题image select
struct PageQuestionImageSelect:public PageQuestionBase
{
	std::string                 strQuestion;
	std::vector<std::string>    vStrImage;
	std::vector<QZ_INT>         vAnswers;

	PageQuestionImageSelect():PageQuestionBase(PAGE_QUESTION_IMAGE_CHOICE)
	{}
};

//题目列表5
struct PageQuestionList:public PageBaseElements
{
	PageRichText					stTitle;
	std::vector<PageQuestionBase*>	vQuestions;

	PageQuestionList():PageBaseElements(PAGE_OBJECT_QUESTION_LIST)
	{}

	~PageQuestionList()
	{
		ClearObjectInVector(vQuestions);
	}
};

//单张图片6
struct PageImage:public PageBaseElements
{
	PageRichText	stTitle;
	std::string		strImgPath;

	PageImage():PageBaseElements(PAGE_OBJECT_IMAGE)
	{}
};

//画廊7
struct PageImageListSubImage
{
	std::string		strImgPath;
	PageRichText	stImgComment;
};

struct PageImageList:public PageBaseElements
{
	PageRichText	stTitle;
	QZ_BOOL			isComment;
	QZ_BOOL			isSmallImage;
	std::vector<PageImageListSubImage>	vImages;

	PageImageList():PageBaseElements(PAGE_OBJECT_IMAGE_LIST),isComment(QZ_FALSE),isSmallImage(QZ_FALSE)
	{}
};

//声音8
struct PageVoice:public PageBaseElements
{
	std::string		strVoicePath;
	PageRichText	stTitle;

	PageVoice():PageBaseElements(PAGE_OBJECT_VOICE)
	{}
};

//文字滚动视图 9
struct PageTextRoll:public PageBaseElements
{
	std::string strFilePath;

	PageTextRoll():PageBaseElements(PAGE_OBJECT_TEXT_ROLL)
	{}
};

//web链接10
struct PageWebLink:public PageBaseElements
{
	std::string	strHtmlPath;

	PageWebLink():PageBaseElements(PAGE_OBJECT_WEB_LINK)
	{}
};

#endif//_QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGEOBJS_H_
