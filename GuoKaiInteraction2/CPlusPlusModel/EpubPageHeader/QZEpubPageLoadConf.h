#ifndef _QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGELOADCONF_H_
#define _QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGELOADCONF_H_

//#include "XHTMLSaxParser.h"
#include "QZEpubLibReturnCode.h"
#include "QZEpubPageObjs.h"
#include <vector>
#include <string>
#include <map>

class QZEpubPageLoadConf
{
private:
	std::vector<std::string>		m_vStack;			//标志正在解析标签的层次位置
	std::vector<PageBaseElements*>	m_vPosList;			//所有的坐标和对象对应关系
	std::string						m_strContent;		//所有可选文字的字符串

	//辅助成员变量
	std::map<std::string,PageElementType>	m_mPageElemTypeMapping;
	std::map<std::string,PageRichTextPieceType>	m_mRichTextTypeMapping;
	QZ_LONG							m_nChapter;
	QZ_LONG							m_nPage;
	std::vector<PageRichText*>		m_vPageRichText;	//富文本列表

public:
	//构造/析构函数
	QZEpubPageLoadConf();
	~QZEpubPageLoadConf();

	//三个回调函数
	static QZ_VOID StartElementCallback(QZ_VOID *user_data,const QZ_CHAR *name,const QZ_CHAR **attrs);
	static QZ_VOID EndElementCallback(QZ_VOID *user_data,const QZ_CHAR *name);
	static QZ_VOID CharactersCallback(QZ_VOID *user_data,const QZ_CHAR *ch,int len);

	//解析配置文件
	QZ_ReturnCode Load(const QZ_CHAR* fileName);

	//获取所有的位置信息
	QZ_ReturnCode GetPostionList(std::vector<PageBaseElements*>& vPosList);

	//获取字符串
	std::string	GetContentStr();

	//获取需要绘制的对象列表
	std::vector<QZ_LONG> GetDrawableObjList();

private:

	//处理属性
	QZ_ReturnCode ProcessAttribute(const QZ_CHAR *name,const QZ_CHAR **attrs);

	//处理富文本
	QZ_ReturnCode ProcessRichTexts(const QZ_CHAR *ch);

	//处理内容
	QZ_ReturnCode ProcessPosObjs(const QZ_CHAR *ch);

	//处理文字相关
	QZ_ReturnCode ReadTextPos(const QZ_CHAR *ch);

	//将字符串坐标转为rect的坐标
	QZ_ReturnCode ProcessTextPos(const QZ_CHAR *ch,QZ_BOX& rect);

	//读取tooltip
	QZ_ReturnCode ReadToolTip(const QZ_CHAR *ch);

	//读取带有图片的tooltip
	QZ_ReturnCode ReadToolImageTip(const QZ_CHAR *ch);

	//读取navrect
	QZ_ReturnCode ReadNavRect(const QZ_CHAR *ch);

	//读取navbutton
	QZ_ReturnCode ReadNavButton(const QZ_CHAR *ch);

	//读取通用坐标
	QZ_ReturnCode ReadCommonRect(const QZ_CHAR *ch);

	//navbutton 添加选项
	QZ_ReturnCode NavButtonAddItem();

	//读取video 
	QZ_ReturnCode ReadVideo(const QZ_CHAR *ch);

	//读取问题列表
	QZ_ReturnCode ReadQuestionList(const QZ_CHAR *ch);

	//questionlist 添加问题
	QZ_ReturnCode QuestionListAddItem(const QZ_CHAR **attrs);

	//读取image
	QZ_ReturnCode ReadImage(const QZ_CHAR *ch);

	//读取imagelist
	QZ_ReturnCode ReadImageList(const QZ_CHAR *ch);

	//读取voice
	QZ_ReturnCode ReadVoice(const QZ_CHAR *ch);

	//读取rollview
	QZ_ReturnCode ReadTextRoll(const QZ_CHAR *ch);

	//读取weblink
	QZ_ReturnCode ReadWebLink(const QZ_CHAR *ch);
};

#endif//_QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGELOADCONF_H_
