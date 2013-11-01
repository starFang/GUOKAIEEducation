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

#include "QZEpubPage.h"
#include <fstream>
#include "QZEpubPageLoadConf.h"

using namespace std;

//构造函数
QZEpubPage::QZEpubPage()
{}

//析构函数
QZEpubPage::~QZEpubPage()
{
	ClearObjectInVector(m_vPosList);
}

const PageBaseElements* QZEpubPage::HitTestElement(QZ_POS pt)
{
	for (vector<PageBaseElements*>::iterator iBegin = m_vPosList.begin();
		iBegin != m_vPosList.end();iBegin++)
	{
		if ((*iBegin)->rect.PosInBox(pt))
		{
			return (*iBegin);
		}
	}

	return QZ_NULL;
}

QZ_ReturnCode QZEpubPage::LoadData(string strPath)
{
	QZEpubPageLoadConf pageLoad;
	if (QZR_EPUBLIB_OPENFILE_FAIL == pageLoad.Load(strPath.c_str()))
	{
		return QZR_EPUBLIB_OPENFILE_FAIL;
	}

	pageLoad.GetPostionList(m_vPosList);
	m_vObjectiveList = pageLoad.GetDrawableObjList();
	m_strContent = pageLoad.GetContentStr();

	return QZR_OK;
}

vector<const PageBaseElements*> QZEpubPage::GetDrawableObjList()
{
	vector<const PageBaseElements*> vResult;
	for (vector<QZ_LONG>::iterator iBegin = m_vObjectiveList.begin();
		iBegin != m_vObjectiveList.end(); iBegin++)
	{
		vResult.push_back(m_vPosList[*iBegin]);
	}

	return vResult;
}

#include <iostream>

vector<QZ_BOX> QZEpubPage::GetSelectTextRects(BookIndex begin,BookIndex end)
{
    if (begin.nCharacter > end.nCharacter)
    {
        begin.nCharacter = begin.nCharacter + end.nCharacter;
        end.nCharacter = begin.nCharacter - end.nCharacter;
        begin.nCharacter = begin.nCharacter - end.nCharacter;
    }
	vector<QZ_BOX>  vBoxs;
	for (QZ_LONG i = begin.nCharacter ,j = begin.nCharacter ;i < (QZ_LONG)m_vPosList.size() && j <= end.nCharacter; i++)
	{
		if (m_vPosList[i]->m_elementType == PAGE_OBJECT_CHARACTER)
		{
            PageCharacter* p = (PageCharacter*)m_vPosList[i];
            if (p->nIndex.nCharacter != j)
            {
                continue;
            }
    
			if (vBoxs.empty())
			{
				vBoxs.push_back(m_vPosList[i]->rect);
			}
			else
			{
				QZ_BOX& boxLast = vBoxs.back();
				if (HasVerticalIntersection(boxLast,m_vPosList[i]->rect))
				{
					QZ_DOUBLE space = m_vPosList[i]->rect.X0 - boxLast.X1;
					if (space < boxLast.X1 - boxLast.X0)
					{
						boxLast.X1 = m_vPosList[i]->rect.X1;
						boxLast.Y0 = boxLast.Y0 < m_vPosList[i]->rect.Y0 ? boxLast.Y0 : m_vPosList[i]->rect.Y0;
						boxLast.Y1 = boxLast.Y1 > m_vPosList[i]->rect.Y1 ? boxLast.Y1 : m_vPosList[i]->rect.Y1;
					}
					else
					{
						vBoxs.push_back(m_vPosList[i]->rect);
					}
				}
				else
				{
					vBoxs.push_back(m_vPosList[i]->rect);
				}
			}
            j++;
        }
	}
	return vBoxs;
}

QZ_BOOL QZEpubPage::HasVerticalIntersection(QZ_BOX rect1,QZ_BOX rect2)
{
	QZ_DOUBLE len = rect1.Y0 + rect1.Y1 - rect2.Y0 - rect2.Y1;
	len = len > 0 ? len : -len;

	QZ_DOUBLE lenTotal = rect1.Y1 - rect1.Y0 + rect2.Y1 - rect2.Y0;

	if (len <= lenTotal)
		return QZ_TRUE;
	else
		return QZ_FALSE;
}

//通过字符index获取该字符
std::string QZEpubPage::GetCharacterByIndex(QZ_LONG lIndex)
{
	QZ_LONG length = GetCharacterBeginPos(lIndex);

	if (length == -1)
	{
		return "";
	}

	if (length < (QZ_LONG)m_strContent.length())
	{
		QZ_LONG lenChar = GetCharSize(m_strContent[length]);
		if (length + lenChar - 1< (QZ_LONG)m_strContent.length())
		{
			return m_strContent.substr(length,lenChar);
		}
	}

	return "";
}

std::string QZEpubPage::GetCharacterPiece(QZ_LONG lBegin,QZ_LONG lEnd)
{
    
	if (lEnd < lBegin)
	{
        lEnd = lEnd + lBegin;
        lBegin = lEnd - lBegin;
        lEnd = lEnd - lBegin;
	}

	QZ_LONG lBeginPos = GetCharacterBeginPos(lBegin);
	if (lBeginPos < 0)
		return "";

	QZ_LONG lEndPos = GetCharacterBeginPos(lEnd);
	if (lEndPos < 0)
		return "";

	lEndPos = lEndPos + GetCharSize(m_strContent[lEndPos]);

	return m_strContent.substr(lBeginPos,lEndPos - lBeginPos);
}

QZ_LONG QZEpubPage::GetCharacterBeginPos(QZ_LONG index)
{
	QZ_LONG length = 0;

	for (QZ_LONG nCount = 0; nCount < index;nCount++)
	{
		if (length < (QZ_LONG)m_strContent.length())
		{
			length += GetCharSize(m_strContent[length]);
		}
		else
		{
			return -1;
		}
	}

	return length;
}


//得到当前解析字符的长度
QZ_UINT QZEpubPage::GetCharSize(QZ_BYTE ch)
{
	QZ_INT i = 0;
	for (i =0 ;i <4;i++)
	{
		QZ_BYTE ua = 1;
		ua = ua << (8-i-1);
		QZ_BYTE result = ua&ch;
		if (0==result)
			break;
	}
	if (i==0)
		return 1;
	else if (i == 2)
		return 2;
	else if (i == 3)
		return 3;
	else
		return 4;
}


