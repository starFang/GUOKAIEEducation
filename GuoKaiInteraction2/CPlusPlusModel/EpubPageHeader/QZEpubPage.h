//===========================================================================
// Summary:
//     epub中页面的类，用于管理每一页中的内容
// Usage:
//     Null
// Remarks:
//     Null
// Date:
//     2013-09-17
// Author:
//     chenjunfa(chenjunfa@qanzone.com)
//===========================================================================

#ifndef _QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGE_H_
#define _QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGE_H_
#include "QZEpubPageObjs.h"
#include "QZEpubLibReturnCode.h"

using namespace std;

class QZEpubPage
{
	vector<PageBaseElements*>	m_vPosList;			//所有的坐标和对象对应关系
	string						m_strContent;		//所有可选文字的字符串
	vector<QZ_LONG>				m_vObjectiveList;	//需要客户端绘制的对象列表

public:

	//构造函数
	QZEpubPage();

	//析构函数
	~QZEpubPage();

	//-------------------------------------------
	// Summary:
	//     判断点pt在页面中是什么对象
	// Parameters:
	//     [in]  strPath : 数据文件地址
	// ReturnValue:
	//     QZ_ReturnCode : 解析结果
	//-------------------------------------------
	QZ_ReturnCode LoadData(string strPath);

	//-------------------------------------------
	// Summary:
	//     判断点pt在页面中是什么对象
	// Parameters:
	//     [in]  pt :点坐标
	// ReturnValue:
	//     QZ_NULL : 该位置没有可交互对象
	//     others  : 对象的指针
	//-------------------------------------------
	const PageBaseElements* HitTestElement(QZ_POS pt);

	//-------------------------------------------
	// Summary:
	//     获取选中文字的行框集合
	// Parameters:
	//     [in]  begin 开始文字的三级索引
	//	   [in]  end   结束文字的三级索引
	// ReturnValue:
	//     行框集合
	//-------------------------------------------
	vector<QZ_BOX> GetSelectTextRects(BookIndex begin,BookIndex end);

	//-------------------------------------------
	// Summary:
	//     获取绘制列表的接口
	// Parameters:
	//     [in]  null
	// ReturnValue:
	//     对象列表
	//-------------------------------------------
	vector<const PageBaseElements*> GetDrawableObjList();


	//通过字符index获取该字符
	std::string GetCharacterByIndex(QZ_LONG lIndex);

	//通过字符开始index和字符结束index获取字符串
	std::string GetCharacterPiece(QZ_LONG lBegin,QZ_LONG lEnd);
private:
	QZ_BOOL HasVerticalIntersection(QZ_BOX rect1,QZ_BOX rect2);

	//通过首字节获取字符长度
	QZ_UINT GetCharSize(QZ_BYTE ch);

	//通过字符index获取字符在字符串中的起始位置
	QZ_LONG GetCharacterBeginPos(QZ_LONG index);
};

#endif //_QZKERNEL_EPUBKIT_EPUBLIB_EXPORT_QZEPUBPAGE_H_
