#ifndef _QZEPUBREADINGDATA_H_
#define _QZEPUBREADINGDATA_H_

#include <vector>
#include <string>

/*
 *  说 明：引用点的定义
 */
class RefPos
{
	std::string		m_strChapterID;					//章节文件的ID，文档内唯一
	long			m_lOffSet;						//章节文件内的二进制偏移量，从0开始
    
	long			m_lChapterIndex;				//（可选）引用点的章节索引，从0开始
    //临时工程中 表示第几页
	long			m_lParaIndex;					//（可选）引用点的段索引，从0开始
    //临时工程中 表示一页中的第几个字
	long			m_lAtomIndex;					//（可选）引用点所在段的原子索引，从0开始

public:
	RefPos():m_lAtomIndex(0),m_lChapterIndex(0),m_lOffSet(0),m_lParaIndex(0)
	{}
	
	RefPos(std::string strChapterID,long offSet,long chapterIndex = 0,long paraIndex = 0,long automIndex = 0)
	{
		m_strChapterID = strChapterID;
		m_lOffSet = offSet;
		m_lChapterIndex = chapterIndex;
		m_lParaIndex = paraIndex;
		m_lAtomIndex = automIndex;
	}
	
	//获取章节文件的ID
	std::string GetChapterID(){	return m_strChapterID;}

	//设置章节文件的ID
	void SetChapterID(const std::string& strChapterID)
	{ m_strChapterID = strChapterID;}

	//获取文件内的二进制偏移
	long GetOffSet() const
	{return	m_lOffSet;}

	//设置文件内的二进制偏移
	void SetOffSet(long offSet){ m_lOffSet = offSet;}

	//获取章节索引
	long GetChapterIndex() const
	{return m_lChapterIndex;}

	//设置章节索引
	void SetChapterIndex(long chapterIndex){ m_lChapterIndex = chapterIndex;}

	//获取段落索引
	long GetParaIndex() const
	{return m_lParaIndex;}

	//设置段落索引
	void SetParaIndex(long paraIndex){ m_lParaIndex = paraIndex;};

	//获取圆点在段落的索引点
	long GetAutoIndex() const
	{return m_lAtomIndex;}

	//设置圆点在段落的索引点
	void SetAutoIndex(long autoIndex){ m_lAtomIndex = autoIndex;}

	bool operator>(RefPos& refPos)
	{
		return m_lChapterIndex > refPos.m_lChapterIndex ||
			   (m_lChapterIndex == refPos.m_lChapterIndex && m_lParaIndex > refPos.m_lParaIndex) ||
			   (m_lChapterIndex == refPos.m_lChapterIndex && m_lParaIndex == refPos.m_lParaIndex && m_lAtomIndex > refPos.m_lAtomIndex);
	}

	bool operator==(RefPos& refPos)
	{
		return  m_lChapterIndex == refPos.m_lChapterIndex && 
				m_lParaIndex == refPos.m_lParaIndex && 
				m_lAtomIndex == refPos.m_lAtomIndex;
	}

	bool operator<(RefPos& refPos)
	{
		return m_lChapterIndex < refPos.m_lChapterIndex ||
			(m_lChapterIndex == refPos.m_lChapterIndex && m_lParaIndex < refPos.m_lParaIndex) ||
			(m_lChapterIndex == refPos.m_lChapterIndex && m_lParaIndex == refPos.m_lParaIndex && m_lAtomIndex < refPos.m_lAtomIndex);
	}
};


/*
 * 说 明：引用的定义
 */
class RefContent
{
	bool			m_bIsSimpleRef;					//表示是否为简单引用
	RefPos			m_tStartPos;					//当m_bIsSimpleRef为简单引用时，则为简单引用位置 当m_bIsSimplePos为段引用的时候，m_tStartPos为段引用的开始位置
	RefPos			m_tEndPos;						//当m_bIsSimplePos为段引用时有效，m_tStartPos为段引用的结束位置
	std::string		m_sRefText;						//（可选）引用范围内的文本内容。

public:
	RefContent():m_bIsSimpleRef(false)
	{}

	RefContent(RefPos simPos,std::string refText = ""):m_bIsSimpleRef(true)
	{
		m_tStartPos = simPos;
		m_sRefText = refText;
	}

	RefContent(RefPos startPos,RefPos endPos,std::string refText=""):m_bIsSimpleRef(false)
	{
		m_tStartPos = startPos;
		m_tEndPos = endPos;
		m_sRefText = refText;
	}

	//查看是否为简单引用
	bool IsSimpleRef() const
	{return m_bIsSimpleRef;}

	//设置引用类型
	void SetSimpleRef(bool bSimpleRef){ m_bIsSimpleRef = bSimpleRef;}

	//获取开始位置
	RefPos GetStartPos() const
	{return m_tStartPos;}

	//设置开始位置
	void SetStartPos(const RefPos& refPos){ m_tStartPos = refPos;}

	//获取结束位置
	RefPos GetEndPos() const
	{return m_tEndPos;}

	//设置结束位置
	void SetEndPos(const RefPos& refPos){m_tEndPos = refPos;}

	//获取引用内容
	std::string GetRefText() const
	{return m_sRefText;}

	//设置引用内容
	void SetRefText(const std::string& strText){m_sRefText = strText;}
};

//阅读数据类型
enum QZ_READING_DATA_TYPE
{
	QZ_READING_DATA_UNKNOW,							//未知类型
	QZ_READING_DATA_BOOKMARK,						//标签类型
	QZ_READING_DATA_COMMENT							//批注书摘类型
};


//标签、批注、书摘的基础数据
class ReadingBaseData
{
	long					m_lID;					//数据ID，在同一文档内必须唯一
	unsigned long			m_tCreateTime;			//创建时间
	QZ_READING_DATA_TYPE	m_eDataType;			//数据类型
	unsigned long			m_tLastModTime;			//（可选）最近一次修改时间
	std::string				m_strAuthor;			//（可选）作者

public:
	ReadingBaseData(QZ_READING_DATA_TYPE eDataType = QZ_READING_DATA_UNKNOW)
		:m_lID(0),m_eDataType(eDataType)
	{}

	virtual ~ReadingBaseData()
	{}

	//获取数据类型
	QZ_READING_DATA_TYPE GetDataType() const 
	{return m_eDataType;}

	//设置数据ID
	void SetID(const long ID){m_lID = ID;}				

	//获取数据ID
	long GetID() const
	{return m_lID;}

	//设置创建时间
	void SetCreateTime(const unsigned long createTime){ m_tCreateTime = createTime;}

	//获取社创建时间
	unsigned long GetCreateTime() const
	{return m_tCreateTime;}

	//设置最后修改时间
	void SetLastModTime(const unsigned long lastTime){ m_tLastModTime = lastTime;}

	//获取最后修改时间
	unsigned long GetLastModTime() const
	{ return m_tLastModTime;}

	//设置作者
	void SetAuthor(const std::string& strAuthor){ m_strAuthor = strAuthor;}

	//获取作者
	std::string GetAuthor() const 
	{ return m_strAuthor;}
};

//书签
class BookMark:public ReadingBaseData
{
	RefPos			m_tRefPos;						//引用位置
	std::string		m_strContent;					//摘要

public:
	BookMark():ReadingBaseData(QZ_READING_DATA_BOOKMARK)
	{}

	BookMark(RefPos refPos,std::string strContent = ""):ReadingBaseData(QZ_READING_DATA_BOOKMARK)
	{
		m_tRefPos = refPos;
		m_strContent =  strContent;
	}

	//设置引用位置
	void SetRefPos(const RefPos& refPos){ m_tRefPos = refPos;}

	//获取引用位置
	RefPos GetRefPos() const
	{return m_tRefPos;}

	//设置摘要
	void SetContent(const std::string& strContent){ m_strContent = strContent;}

	//获取摘要
	std::string GetContent() const
	{return m_strContent;}
};

//批注，书摘
class BookComment:public ReadingBaseData
{
	RefContent		m_tRefContent;					//引用内容
	std::string		m_strContent;					//（可选）批注文字内容，如果Content不存在，则退化为书摘，否则为批注。

public:
	BookComment():ReadingBaseData(QZ_READING_DATA_COMMENT)
	{}

	BookComment(const RefContent& refContent,std::string strContent=""):ReadingBaseData(QZ_READING_DATA_COMMENT)
	{
		m_tRefContent = refContent;
		m_strContent = strContent;
	}

	//设置引用内容
	void SetRefContent(const RefContent& refContent){m_tRefContent = refContent;}

	//获取引用内容
	RefContent GetRefContent() const
	{return m_tRefContent;}

	//设置引用内容
	void SetContent(const std::string& strContent){ m_strContent = strContent;}

	//获取引用内容
	std::string GetContent() const
	{return m_strContent;}
};

//阅读数据
class ReadingData
{
	std::string		m_strVersion;					//版本号，目前取值为1
	std::string		m_strBookID;					//图书内容文件的唯一标识
	std::string		m_strRevison;					//图书内容文件的修订版本号
	std::string		m_strKernelVersion;				//生成此阅读数据的内核版本号
	std::vector<ReadingBaseData*>	m_vReadingData;	//阅读数据

public:

	ReadingData(){}

	ReadingData(std::string strVersion,std::string strBookId,std::string strRevison,std::string strKernelVersion)
	{
		m_strVersion = strVersion;
		m_strBookID = strBookId;
		m_strRevison = strRevison;
		m_strKernelVersion = strKernelVersion;
	}

	~ReadingData()
	{
		ClearObjectInVector(m_vReadingData);
	}

	//设置版本号
	void SetVersion(const std::string& strVersion)
	{ m_strVersion = strVersion;}

	//获取版本号
	std::string GetVersion() const {return m_strVersion;}

	//获取文件标识
	std::string GetBookID() const {return m_strBookID;}

	//设置文件标识
	void SetBookID(const std::string& strBookID){ m_strBookID = strBookID;}

	//设置修订版本号
	void SetRevison(const std::string& strRevison){m_strRevison = strRevison;}

	//获取修订版本号
	std::string GetRevison(){return m_strRevison;}

	//设置内核版本号
	void SetKernelVersion(const std::string& kernelVersion){ m_strKernelVersion = kernelVersion;}

	//获取内核版本号
	std::string GetKernelVersion() const { return m_strKernelVersion;}

	//获取总标签等总数量
	long GetTotalNum() const {return m_vReadingData.size();}

	//获取第n个数据
	ReadingBaseData* GetObjByIndex(long index)
	{
		if (index < 0 || index >= (long)m_vReadingData.size())
		{
			return NULL;
		}
		
		return m_vReadingData[index];
	}

	//加入新的数据
	bool PushObj(ReadingBaseData* pBaseData)
	{
		if (pBaseData == NULL)
		{
			return false;
		}

		m_vReadingData.push_back(pBaseData);
		return true;
	}

	//获取所有数据
	const std::vector<ReadingBaseData*>& GetAllObjs(){return m_vReadingData;}
};

#endif//_QZEPUBREADINGDATA_H_
