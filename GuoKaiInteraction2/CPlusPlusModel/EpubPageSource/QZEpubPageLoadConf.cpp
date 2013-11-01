#include "QZEpubPageLoadConf.h"
#include "QZCommon.h"
#include <iostream>
#include "CSSCommonFun.h"

using namespace std;

//构造函数
QZEpubPageLoadConf::QZEpubPageLoadConf():m_nChapter(0L),m_nPage(0L)
{
	m_mPageElemTypeMapping["obj_type_text"] = PAGE_OBJECT_CHARACTER;
	m_mPageElemTypeMapping["obj_type_1"] = PAGE_OBJECT_TOOL_TIP;
	m_mPageElemTypeMapping["obj_type_1_2"] = PAGE_OBJECT_TOOL_IMAGE_TIP;
	m_mPageElemTypeMapping["obj_type_2"] = PAGE_OBJECT_NAV_RECT;
	m_mPageElemTypeMapping["obj_type_3"] = PAGE_OBJECT_NAV_BUTTON;
	m_mPageElemTypeMapping["obj_type_4"] = PAGE_OBJECT_VIDEO;
	m_mPageElemTypeMapping["obj_type_5"] = PAGE_OBJECT_QUESTION_LIST;
	m_mPageElemTypeMapping["obj_type_6"] = PAGE_OBJECT_IMAGE;
	m_mPageElemTypeMapping["obj_type_7"] = PAGE_OBJECT_IMAGE_LIST;
	m_mPageElemTypeMapping["obj_type_8"] = PAGE_OBJECT_VOICE;
	m_mPageElemTypeMapping["obj_type_9"] = PAGE_OBJECT_TEXT_ROLL;
	m_mPageElemTypeMapping["obj_type_10"] = PAGE_OBJECT_WEB_LINK;

	m_mRichTextTypeMapping["text_type_begin_tool1"] = PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN;
	m_mRichTextTypeMapping["text_type_text_tool1"] = PAGE_RICH_TEXT_PIECE_TEXT;
	m_mRichTextTypeMapping["text_type_end_tool1"] = PAGE_RICH_TEXT_PIECE_PARAGRAPH_END;
	m_mRichTextTypeMapping["text_type_prefix_dot_tool1"] = PAGE_RICH_TEXT_PIECE_DOT;

}

//析构函数
QZEpubPageLoadConf::~QZEpubPageLoadConf()
{
	ClearObjectInVector(m_vPageRichText);
}

//三个回调函数
QZ_VOID QZEpubPageLoadConf::StartElementCallback(QZ_VOID *user_data,const QZ_CHAR *name,const QZ_CHAR **attrs)
{
	//获取对象指针
	QZEpubPageLoadConf* epubParser = (QZEpubPageLoadConf*)user_data;

	//将正在解析的标签压栈
	if ((ISSTREQUAL(name,"html") || ISSTREQUAL(name,"body")) 
		&& epubParser->m_vStack.size() == 0)
		return;
	epubParser->m_vStack.push_back(name);

	epubParser->ProcessAttribute(name,attrs);
}

QZ_VOID QZEpubPageLoadConf::EndElementCallback(QZ_VOID *user_data,const QZ_CHAR *name)
{
	//将处理完的标签弹出栈
	QZEpubPageLoadConf* epubParser = (QZEpubPageLoadConf*)user_data;
	if (!epubParser->m_vStack.empty())
		epubParser->m_vStack.pop_back();
}

QZ_VOID QZEpubPageLoadConf::CharactersCallback(QZ_VOID *user_data,const QZ_CHAR *ch,int len)
{
	QZEpubPageLoadConf* epubParser = (QZEpubPageLoadConf*)user_data;

	//QZ_CHAR* safeCh = QZ_NULL;
	//	
	//if(strlen(ch) != len)
	//{
	//	safeCh = QZ_MALLOCZ_OBJ_N(QZ_CHAR,len+1);
	//	if (safeCh == QZ_NULL)
	//		return ;
	//	strncpy(safeCh,ch,len);
	//	ch = safeCh;
	//}
	//

	//读取位置信息
	if (epubParser->m_vStack.size() > 2
		&& epubParser->m_vStack[0]=="epubchapter"
		&& epubParser->m_vStack[1]=="epubpage"
		&& epubParser->m_vStack[2]=="positions")
	{
		epubParser->ProcessPosObjs(ch);
	}

	//读取如文本信息
	if (epubParser->m_vStack.size() > 2
		&& epubParser->m_vStack[0]=="epubchapter"
		&& epubParser->m_vStack[1]=="epubpage"
		&& epubParser->m_vStack[2]=="richtexts")
	{
		epubParser->ProcessRichTexts(ch);
	}

	//读取文字字符串
	if (epubParser->m_vStack.size() == 3 && epubParser->m_vStack[2] == "epubpagetext")
	{
		epubParser->m_strContent = ch;
	}

	//free(safeCh);
}

//解析配置文件
QZ_ReturnCode QZEpubPageLoadConf::Load(const QZ_CHAR* fileName)
{
	QZ_CHAR chunk[BLOCK_NUM];  
	QZ_INT num = 0;
	FILE* fd = QZ_NULL;  

	//打开文件
	fd = fopen(fileName, "rb");  
	if(NULL == fd) 
	{  
		return QZR_EPUBLIB_OPENFILE_FAIL;  
	}  

	//创建解析器
	XHTMLSaxParser sax;
	sax.CreateParser();

	sax.SetStartElementHandler(StartElementCallback);
	sax.SetEndElementHandler(EndElementCallback);
	sax.SetCharacterDataHandler(CharactersCallback);
	sax.SetUserData((QZ_VOID*)this);

	while((num = fread(chunk,1,BLOCK_NUM,fd)) >0) 
	{  
		sax.Parse(chunk,num,QZ_FALSE);
	}  
	sax.Parse(chunk,0,QZ_TRUE);

	fclose(fd);
	
		

	return QZR_OK;
}

//获取所有的位置信息
QZ_ReturnCode QZEpubPageLoadConf::GetPostionList(std::vector<PageBaseElements*>& vPosList)
{
	vPosList = m_vPosList;
	return QZR_OK;
}

//获取字符串
string QZEpubPageLoadConf::GetContentStr()
{
	return m_strContent;
}

//获取需要绘制的对象列表
vector<QZ_LONG> QZEpubPageLoadConf::GetDrawableObjList()
{
	vector<QZ_LONG>	vList;
	for (QZ_LONG i = 0; i < (QZ_LONG)m_vPosList.size();i++)
	{
		if (m_vPosList[i]->m_elementType != PAGE_OBJECT_CHARACTER)
		{
			vList.push_back(i);
		}
	}

	return vList;
}

QZ_ReturnCode QZEpubPageLoadConf::ProcessAttribute(const QZ_CHAR *name,const QZ_CHAR **attrs)
{
	if (m_vStack.size() == 4
		&& m_vStack[2]=="positions"
		&& m_vStack[3]=="position")
	{
		PageElementType type = PAGE_OBJECT_DEFAULT;
		//获取属性
		while (NULL != attrs && NULL != attrs[0]) 
		{
			if (ISSTREQUAL(attrs[0],"type"))
			{
				map<string,PageElementType>::iterator iPos = m_mPageElemTypeMapping.find(attrs[1]);
				if (iPos == m_mPageElemTypeMapping.end())
					return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
				type = iPos->second;
			}
			attrs = &attrs[2];
		}

		PageBaseElements*	pPosObj = QZ_NULL;
		switch(type)
		{
		case PAGE_OBJECT_CHARACTER:
			pPosObj = new PageCharacter();
			break;
		case PAGE_OBJECT_TOOL_TIP:
			pPosObj = new PageToolTip();
			break;
		case PAGE_OBJECT_TOOL_IMAGE_TIP:
			pPosObj = new PageToolImageTip();
			break;
		case PAGE_OBJECT_NAV_RECT:
			pPosObj = new PageNavRect();
			break;
		case PAGE_OBJECT_NAV_BUTTON:
			pPosObj = new PageNavButton();
			break;
		case PAGE_OBJECT_VIDEO:
			pPosObj = new PageVideo();
			break;
		case PAGE_OBJECT_QUESTION_LIST:
			pPosObj = new PageQuestionList();
			break;
		case PAGE_OBJECT_IMAGE:
			pPosObj = new PageImage();
			break;
		case PAGE_OBJECT_IMAGE_LIST:
			pPosObj = new PageImageList();
			break;
		case PAGE_OBJECT_VOICE:
			pPosObj = new PageVoice();
			break;
		case PAGE_OBJECT_TEXT_ROLL:
			pPosObj = new PageTextRoll();
			break;
		case PAGE_OBJECT_WEB_LINK:
			pPosObj = new PageWebLink();
			break;
		}

		if (pPosObj == QZ_NULL)
		{
			return QZR_MEMORY_ERROR;
		}

		m_vPosList.push_back(pPosObj);
	}
	else if (m_vStack.size() > 3
		&& m_vStack[2]=="richtexts"
		&& m_vStack[3]=="richtext")
	{
		if (m_vStack.size() == 4)
		{
			PageRichText* pRichTextObj = new PageRichText();
			if (pRichTextObj == QZ_NULL)
				return QZR_MEMORY_ERROR;

			//获取富文本类型
			while (NULL != attrs && NULL != attrs[0]) 
			{
				if (ISSTREQUAL(attrs[0],"type"))
				{
					if (ISSTREQUAL(attrs[1],"complextext"))
						pRichTextObj->isRichText = QZ_TRUE;
					else
						pRichTextObj->isRichText = QZ_FALSE;
				}
				attrs = &attrs[2];
			}

			m_vPageRichText.push_back(pRichTextObj);
		}
		else if (m_vStack.size() == 5 && m_vStack[4]=="rich_text_item")
		{
			//获取富文本节点类型
			string strItemType = "";
			while (NULL != attrs && NULL != attrs[0]) 
			{
				if (ISSTREQUAL(attrs[0],"type"))
					strItemType = attrs[1];
				attrs = &attrs[2];
			}

			map<string,PageRichTextPieceType>::iterator iPos = m_mRichTextTypeMapping.find(strItemType);
			if (iPos == m_mRichTextTypeMapping.end())
				return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;

			PageRIchTextPieceText richItem;
			richItem.pieceType = m_mRichTextTypeMapping[strItemType];
			m_vPageRichText.back()->vTextItemList.push_back(richItem);
		}
	}
	else if (m_vStack.size() == 6 && m_vStack[5]=="subbutton" && m_vPosList.back()->m_elementType == PAGE_OBJECT_NAV_BUTTON)
	{
		NavButtonAddItem();
	}
	else if (m_vStack.size() == 6 && m_vStack[5]=="questionobj")
	{
		QuestionListAddItem(attrs);
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ProcessRichTexts(const QZ_CHAR *ch)
{
	if (m_vStack.size() > 4
		&& m_vStack[2]=="richtexts"
		&& m_vStack[3]=="richtext")
	{
		if (m_vStack[4] == "text")
		{
			m_vPageRichText.back()->strText = ch;
		}
		else if (m_vStack.size() == 6 && m_vStack[4] == "rich_text_item")
		{
			if (m_vStack[5] == "text_indent")
				m_vPageRichText.back()->vTextItemList.back().nLength = StringToInt(ch);
			else if(m_vStack[5] == "font_color")
				m_vPageRichText.back()->vTextItemList.back().fontColor = StringToARGBColor(ch);
			else if(m_vStack[5] == "font_size")
				m_vPageRichText.back()->vTextItemList.back().fontSize = StringToInt(ch);
			else if(m_vStack[5] == "font_family")
				m_vPageRichText.back()->vTextItemList.back().fontFamily = ch;
			else if(m_vStack[5] == "text")
				m_vPageRichText.back()->vTextItemList.back().strText = ch;
			else if(m_vStack[5] == "is_italic")
				m_vPageRichText.back()->vTextItemList.back().isItalic = ISSTREQUAL(ch,"false") ? QZ_FALSE : QZ_TRUE;
			else if(m_vStack[5] == "is_bold")
				m_vPageRichText.back()->vTextItemList.back().isBold = ISSTREQUAL(ch,"false") ? QZ_FALSE : QZ_TRUE;
			else if(m_vStack[5] == "para_after")
				m_vPageRichText.back()->vTextItemList.back().nLength = StringToInt(ch);
		}
	}

	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ProcessPosObjs(const QZ_CHAR *ch)
{
	if (m_vStack.size() > 3
		&& m_vStack[2]=="positions"
		&& m_vStack[3]=="position")
	{
		switch(m_vPosList.back()->m_elementType)
		{
		case PAGE_OBJECT_CHARACTER:
			ReadTextPos(ch);
			break;
		case PAGE_OBJECT_TOOL_TIP:
			ReadToolTip(ch);
			break;
		case PAGE_OBJECT_TOOL_IMAGE_TIP:
			ReadToolImageTip(ch);
		case PAGE_OBJECT_NAV_RECT:
			ReadNavRect(ch);
			break;
		case PAGE_OBJECT_NAV_BUTTON:
			ReadNavButton(ch);
			break;
		case PAGE_OBJECT_VIDEO:
			ReadVideo(ch);
			break;
		case PAGE_OBJECT_QUESTION_LIST:
			ReadQuestionList(ch);
			break;
		case PAGE_OBJECT_IMAGE:
			ReadImage(ch);
			break;
		case PAGE_OBJECT_IMAGE_LIST:
			ReadImageList(ch);
			break;
		case PAGE_OBJECT_VOICE:
			ReadVoice(ch);
			break;
		case PAGE_OBJECT_TEXT_ROLL:
			ReadTextRoll(ch);
			break;
		case PAGE_OBJECT_WEB_LINK:
			ReadWebLink(ch);
			break;
		}
	}

	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadTextPos(const QZ_CHAR *ch)
{
	if (m_vStack.size() != 5)
		return QZR_OK;

	ReadCommonRect(ch);

	PageCharacter* pPosObj = (PageCharacter*)m_vPosList.back();

	if(m_vStack[4]=="index")
	{
		pPosObj->nIndex.nChapter = m_nChapter;
		pPosObj->nIndex.nPage = m_nPage;
		pPosObj->nIndex.nCharacter = StringToLongInt(ch);
	}

	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ProcessTextPos(const QZ_CHAR *ch,QZ_BOX& rect)
{
	string strRect = ch;

	vector<string> vStr = split(strRect,' ');

	if (vStr.size() !=4)
		return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;

	rect.X0 = StringToDouble(vStr[0]);
	rect.Y0 = StringToDouble(vStr[1]);
	rect.X1 = StringToDouble(vStr[2]);
	rect.Y1 = StringToDouble(vStr[3]);

	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadCommonRect(const QZ_CHAR *ch)
{
	if (m_vStack.size() != 5)
		return QZR_OK;

	PageBaseElements * pPosObj = m_vPosList.back();

	if(m_vStack[4]=="rect")
	{
		ProcessTextPos(ch,pPosObj->rect);
	}

	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadToolTip(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);
	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageToolTip* pPosObj = (PageToolTip*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="width")
			pPosObj->nWidth = StringToLongInt(ch);
		else if (m_vStack[5]=="height")
			pPosObj->nHeight = StringToLongInt(ch);
		else if (m_vStack[5]=="bgcolor")
			pPosObj->bgColor = StringToARGBColor(ch);
		else if (m_vStack[5]=="buttonimage")
			pPosObj->strBtnImage = GetBase16Name(ch);
            //pPosObj->strBtnImage = ch;
		else if (m_vStack[5]=="buttontext")
			pPosObj->strBtnText = ch;
	}
	else if (nStackSize == 7 && m_vStack[5] == "tiptext")
	{
		QZ_INT nIndex = StringToInt(ch);
		if (nIndex >= (QZ_INT)m_vPageRichText.size())
			return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
		pPosObj->strTipText = *m_vPageRichText[nIndex];
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadToolImageTip(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);
	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageToolImageTip* pPosObj = (PageToolImageTip*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="width")
			pPosObj->nWidth = StringToLongInt(ch);
		else if (m_vStack[5]=="height")
			pPosObj->nHeight = StringToLongInt(ch);
		else if (m_vStack[5]=="htmlfile")
			pPosObj->filePath= GetBase16Name(ch);
		else if (m_vStack[5]=="buttonimage")
			pPosObj->strBtnImage = GetBase16Name(ch);
		else if (m_vStack[5]=="buttontext")
			pPosObj->strBtnText = ch;
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadNavRect(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageNavRect* pPosObj = (PageNavRect*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="chapter")
			pPosObj->nChapterIndex = StringToLongInt(ch);
		else if (m_vStack[5]=="page")
			pPosObj->nPageIndex = StringToLongInt(ch);
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadNavButton(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageNavButton* pPosObj = (PageNavButton*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="text")
			pPosObj->strTipText = ch;
		else if (m_vStack[5]=="width")
			pPosObj->nWidth = StringToLongInt(ch);
		else if (m_vStack[5]=="height")
			pPosObj->nHeight = StringToLongInt(ch);
	}
	if (nStackSize == 7)
	{
		if (m_vStack[6] == "chapter")
		{
			pPosObj->vBtnList.back().nChapterIndex = StringToInt(ch);
		}
		else if (m_vStack[6] == "page")
		{
			pPosObj->vBtnList.back().nPageIndex = StringToInt(ch);
		}
		else if (m_vStack[6] == "text")
		{
			pPosObj->vBtnList.back().strBtnText = ch;
		}
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::NavButtonAddItem()
{
	PageNavChildButton pt;
	PageNavButton* pObj =  (PageNavButton*)m_vPosList.back();
	pObj->vBtnList.push_back(pt);
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadVideo(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageVideo* pPosObj = (PageVideo*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="path")
		{
			pPosObj->strPath = GetBase16Name(ch);
		}
		else if (m_vStack[5]=="startimage")
		{
			pPosObj->strStartImage = GetBase16Name(ch);
		}		
	}
	else if (nStackSize == 7)
	{
		if (m_vStack[6] == "richtextindex")
		{
			QZ_INT nIndex = StringToInt(ch);
			if (nIndex >= (QZ_INT)m_vPageRichText.size())
				return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
			pPosObj->stTitle = *m_vPageRichText[nIndex];
		}
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadQuestionList(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageQuestionList* pPosObj = (PageQuestionList*)m_vPosList.back();

	if (nStackSize == 7 && m_vStack[5] == "title" && m_vStack[6] == "richtextindex")
	{
		QZ_INT nIndex = StringToInt(ch);
		if (nIndex >= (QZ_INT)m_vPageRichText.size())
			return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
		pPosObj->stTitle = *m_vPageRichText[nIndex];
	}
	else if (nStackSize >= 7 && m_vStack[5] == "questionobj")
	{
		PageQuestionType eType = pPosObj->vQuestions.back()->eType;
		

		if (eType == PAGE_QUESTION_IMAGE_CHOICE)
		{
			PageQuestionImageSelect* pQuestion = (PageQuestionImageSelect*)pPosObj->vQuestions.back();
			if (m_vStack.back() == "question")
			{
				pQuestion->strQuestion = ch;
			}
			else if (nStackSize == 8 && m_vStack[6]=="images" && m_vStack.back() == "image")
			{
				pQuestion->vStrImage.push_back(GetBase16Name(ch));
			}
			else if (nStackSize == 8 && m_vStack[6]=="answers" && m_vStack.back() == "answer")
			{
				pQuestion->vAnswers.push_back(StringToInt(ch));
			}
		}
		else if (eType == PAGE_QUESTION_SORT)
		{
			PageQuestionSort* pQuestion = (PageQuestionSort*)pPosObj->vQuestions.back();
			if (m_vStack.back() == "question")
			{
				pQuestion->strQuestion = ch;
			}
			else if (nStackSize == 8 && m_vStack[6]=="nodes" && m_vStack.back() == "node")
			{
				pQuestion->vStrTexts.push_back(ch);
			}
			else if (nStackSize == 8 && m_vStack[6]=="answers" && m_vStack.back() == "answer")
			{
				pQuestion->vSortedList.push_back(StringToInt(ch));
			}
		}
		else if (eType == PAGE_QUESTION_CONNECTION)
		{
			PageQuestionConnection* pQuestion = (PageQuestionConnection*)pPosObj->vQuestions.back();
			if (m_vStack.back() == "question")
			{
				pQuestion->strQuestion = ch;
			}
			else if (nStackSize == 8 && m_vStack[6]=="leftside" && m_vStack.back() == "node")
			{
				pQuestion->vLeftSide.push_back(ch);
			}
			else if (nStackSize == 8 && m_vStack[6]=="rightside" && m_vStack.back() == "node")
			{
				pQuestion->vRightSide.push_back(ch);
			}
			else if (nStackSize == 8 && m_vStack[6]=="answers" && m_vStack.back() == "answer")
			{
				pQuestion->vAnswers.push_back(StringToInt(ch));
			}
		}
		else if (eType == PAGE_QUESTION_BRIEF_ANSWER)
		{
			PageQuestionBriefAnswer* pQuestion = (PageQuestionBriefAnswer*)pPosObj->vQuestions.back();
			if (m_vStack.back() == "question")
			{
				pQuestion->strQuestion = ch;
			}
			else if (m_vStack.back() == "answer")
			{
				pQuestion->vStrAnswer = ch;
			}
		}
		else if (eType == PAGE_QUESTION_FILE_BLANK && nStackSize == 8)
		{
			PageQuestionFillBlank* pQuestion = (PageQuestionFillBlank*)pPosObj->vQuestions.back();
			if (m_vStack.back() == "type")
			{
				PageQuestionFillBlankItem item;
				string strValue = ch;
				item.isAnswer = strValue == "true" ? false :true;
				pQuestion->vDescription.push_back(item);
			}
			else if (m_vStack.back() == "text")
			{
				pQuestion->vDescription.back().strText = ch;
			}
		}
		else if (eType == PAGE_QUESTION_CHOICE)
		{
			PageQuestionChoice* pQuestion = (PageQuestionChoice*)pPosObj->vQuestions.back();
			if (m_vStack.back() == "question")
			{
				pQuestion->strQuestion = ch;
			}
			else if (m_vStack.back() == "option")
			{
				pQuestion->vChoices.push_back(ch);
			}
			else if(m_vStack.back() == "answer")
			{
				pQuestion->vAnswer.push_back(StringToInt(ch));
			}
		}
		else if (eType == PAGE_QUESTION_DRUG)
		{
			PageQuestionDrag* pQuestion = (PageQuestionDrag*)pPosObj->vQuestions.back();
			if (m_vStack.back() == "question")
			{
				pQuestion->strQuestion = ch;
			}
			else if (m_vStack.back() == "backimage")
			{
				pQuestion->strBackGroundImage = GetBase16Name(ch);
			}
			else if (m_vStack.back() == "rect")
			{
				PageQuestionDragPoint dp;
				ProcessTextPos(ch,dp.rect);
				pQuestion->vImageSide.push_back(dp);
			}
			else if (m_vStack.back() == "answerindex")
			{
				pQuestion->vImageSide.back().nAnswer = StringToInt(ch);
			}
			else if (m_vStack.back() == "answer")
			{
				pQuestion->vStringSide.push_back(ch);
			}
		}
	}
	
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::QuestionListAddItem(const QZ_CHAR **attrs)
{
	string strItemType;
	while (NULL != attrs && NULL != attrs[0]) 
	{
		if (ISSTREQUAL(attrs[0],"type"))
			strItemType = attrs[1];
		attrs = &attrs[2];
	}

	PageQuestionBase* pQuestionObj = QZ_NULL;
	if (strItemType == "selector")
		pQuestionObj = new PageQuestionChoice();
	else if (strItemType == "liner")
		pQuestionObj = new PageQuestionDrag();
	else if (strItemType == "fillblank")
		pQuestionObj = new PageQuestionFillBlank();
	else if (strItemType == "briefanswer")
		pQuestionObj = new PageQuestionBriefAnswer();
	else if (strItemType == "connection")
		pQuestionObj = new PageQuestionConnection();
	else if (strItemType == "sort")
		pQuestionObj = new PageQuestionSort();
	else if (strItemType == "imagechoice")
		pQuestionObj = new PageQuestionImageSelect();

	if (pQuestionObj == QZ_NULL)
		return QZR_MEMORY_ERROR;

	PageQuestionList* pObj =  (PageQuestionList*)m_vPosList.back();
	pObj->vQuestions.push_back(pQuestionObj);

	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadImage(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageImage* pPosObj = (PageImage*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="path")
		{
			pPosObj->strImgPath = GetBase16Name(ch);
		}
	}
	else if (nStackSize == 7)
	{
		if (m_vStack[6] == "richtextindex")
		{
			QZ_INT nIndex = StringToInt(ch);
			if (nIndex >= (QZ_INT)m_vPageRichText.size())
				return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
			pPosObj->stTitle = *m_vPageRichText[nIndex];
		}
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadImageList(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageImageList* pPosObj = (PageImageList*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="iscomment")
		{
			pPosObj->isComment = ISSTREQUAL(ch,"true") ? QZ_TRUE : QZ_FALSE;
		}
		else if (m_vStack[5]=="issmallimage")
		{
			pPosObj->isSmallImage = ISSTREQUAL(ch,"true") ? QZ_TRUE : QZ_FALSE;
		}
	}
	else if (nStackSize == 7)
	{
		if (m_vStack[6] == "richtextindex")
		{
			QZ_INT nIndex = StringToInt(ch);
			if (nIndex >= (QZ_INT)m_vPageRichText.size())
				return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
			pPosObj->stTitle = *m_vPageRichText[nIndex];
		}
	}
	else if (nStackSize == 8)
	{
		if (m_vStack[7] == "path")
		{
			PageImageListSubImage img;
			img.strImgPath = GetBase16Name(ch);
			pPosObj->vImages.push_back(img);
		}
	}
	else if (nStackSize == 9)
	{
		if (m_vStack[8] == "richtextindex")
		{
			QZ_INT nIndex = StringToInt(ch);
			if (nIndex >= (QZ_INT)m_vPageRichText.size())
				return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
			pPosObj->vImages.back().stImgComment = *m_vPageRichText[nIndex];
		}
	}

	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadVoice(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageVoice* pPosObj = (PageVoice*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="path")
		{
			pPosObj->strVoicePath = GetBase16Name(ch);
		}
	}
	else if (nStackSize == 7)
	{
		if (m_vStack[6] == "richtextindex")
		{
			QZ_INT nIndex = StringToInt(ch);
			if (nIndex >= (QZ_INT)m_vPageRichText.size())
				return QZR_EPUBLIB_PAGE_CONF_FROMAT_ERROR;
			pPosObj->stTitle = *m_vPageRichText[nIndex];
		}
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadTextRoll(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageTextRoll* pPosObj = (PageTextRoll*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="content")
		{
			pPosObj->strFilePath = GetBase16Name(ch);
		}
	}
	return QZR_OK;
}

QZ_ReturnCode QZEpubPageLoadConf::ReadWebLink(const QZ_CHAR *ch)
{
	ReadCommonRect(ch);

	QZ_INT nStackSize = m_vStack.size(); 
	if (nStackSize < 6)
		return QZR_OK;

	PageWebLink* pPosObj = (PageWebLink*)m_vPosList.back();

	if (nStackSize == 6)
	{
		if (m_vStack[5]=="content")
		{
			pPosObj->strHtmlPath = ch;
		}
	}
	return QZR_OK;
}
