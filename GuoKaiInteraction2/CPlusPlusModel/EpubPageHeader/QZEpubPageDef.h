#ifndef _GUOKAIEPUBPAGE_H_
#define _GUOKAIEPUBPAGE_H_

//===========================================================================
// 通用类型

typedef void			QZ_VOID;

typedef char			QZ_CHAR;
typedef unsigned char	QZ_BYTE, QZ_UCHAR;

typedef short			QZ_SHORT;
typedef unsigned short	QZ_USHORT;

typedef int				QZ_INT;
typedef unsigned int	QZ_UINT;

typedef long			QZ_LONG;
typedef unsigned long	QZ_ULONG;

typedef long        	QZ_OFFSET;



typedef long long		QZ_INT64;
typedef unsigned long long	QZ_UINT64;

typedef float			QZ_FLOAT;
typedef double			QZ_DOUBLE;
typedef float			QZ_REAL;

typedef bool			QZ_BOOL;

#define QZ_NULL			0
#define QZ_TRUE			true
#define QZ_FALSE		false


struct QZ_POS 
{
	QZ_DOUBLE X;
	QZ_DOUBLE Y;

	QZ_POS():X(0.0),Y(0.0)
	{}

	QZ_POS(QZ_DOUBLE x, QZ_DOUBLE y)
		: X(x), Y(y)
	{}

	QZ_BOOL operator==(const QZ_POS& pos) const
	{
		return X == pos.X && Y == pos.Y;
	}

	QZ_BOOL operator!=(const QZ_POS& pos) const
	{
		return !(*this == pos);
	}
};

struct QZ_BOX 
{
	QZ_DOUBLE X0;
	QZ_DOUBLE Y0;    // 左上角坐标
	QZ_DOUBLE X1;
	QZ_DOUBLE Y1;    // 右下角坐标

	QZ_BOX()
		:X0(0.0), Y0(0.0), X1(0.0), Y1(0.0)
	{}

	QZ_BOX(QZ_DOUBLE x0, QZ_DOUBLE y0, QZ_DOUBLE x1, QZ_DOUBLE y1)
		: X0(x0), Y0(y0), X1(x1), Y1(y1)
	{}

	// 判断是否为空区域
	QZ_BOOL IsEmpty() const
	{
		return (X0 == X1 && Y0 == Y1);
	}

	// 判断点是否位于BOX内
	QZ_BOOL PosInBox(const QZ_POS& pos) const
	{
		return (pos.X >= X0 && pos.X <= X1 && pos.Y >= Y0 && pos.Y <= Y1);
	}

	// 判断是否包含目标BOX
	QZ_BOOL ContainsBox(const QZ_BOX& box) const
	{
		return (X0 <= box.X0 && X1 >= box.X1 && Y0 <= box.Y0 && Y1 >= box.Y1);
	}

	// 判断两个BOX是否有交集
	QZ_BOOL IsIntersect(const QZ_BOX& box) const
	{
		return (X0 <= box.X1 && X1 >= box.X0 && Y0 <= box.Y1 && Y1 >= box.Y0);
	}
};

struct QZ_POINT 
{
	QZ_LONG X;
	QZ_LONG Y;

	QZ_POINT()
		: X(0), Y(0)
	{}

	QZ_POINT(QZ_LONG x, QZ_LONG y)
		: X(x), Y(y)
	{}

	QZ_BOOL operator==(const QZ_POINT& pos) const
	{
		return (X == pos.X) && (Y == pos.Y);
	}

	QZ_BOOL operator!=(const QZ_POINT& pos) const
	{
		return !(*this == pos);
	}
};

typedef struct __QZ_ARGBCOLOR
{
	QZ_INT rgbAlpha;
	QZ_INT rgbRed;
	QZ_INT rgbGreen;
	QZ_INT rgbBlue;

	__QZ_ARGBCOLOR()
		: rgbAlpha(255), rgbRed(0), rgbGreen(0), rgbBlue(0)
	{}

	__QZ_ARGBCOLOR(QZ_INT rgbAlpha, QZ_INT rgbRed, QZ_INT rgbGreen, QZ_INT rgbBlue)
		: rgbAlpha(rgbAlpha), rgbRed(rgbRed), rgbGreen(rgbGreen), rgbBlue(rgbBlue)
	{}

	QZ_BOOL operator==(const __QZ_ARGBCOLOR& color) const
	{
		return rgbAlpha == color.rgbAlpha && rgbRed == color.rgbRed && rgbGreen == color.rgbGreen && rgbBlue == color.rgbBlue;
	}

	QZ_BOOL operator!=(const __QZ_ARGBCOLOR& color) const
	{
		return !(*this == color);
	}

} QZ_ARGBCOLOR;

#include <cstdlib>
#include <cstring>


#define QZ_MALLOC malloc
#define QZ_FREE   free
#define QZ_REALLOC realloc
#define QZ_MALLOC_OBJ_N(t, n) ((t*)QZ_MALLOC(sizeof(t) * (n)))
#define QZ_MALLOC_OBJ(t) ((t*)QZ_MALLOC(sizeof(t)))

inline void* QzMallocZ(long size)
{
	void* p = QZ_MALLOC(size);
	if (QZ_NULL != p)
	{
		memset(p, 0, size);
	}
	return p;
}

#define QZ_MALLOCZ QzMallocZ
#define QZ_MALLOCZ_OBJ_N(t, n) ((t*)QZ_MALLOCZ(sizeof(t) * (n)))
#define QZ_MALLOCZ_OBJ(t) ((t*)QZ_MALLOCZ(sizeof(t)))

template <typename Pointer>
inline QZ_VOID SafeReleasePointer(Pointer& ptr)
{
	if (ptr != QZ_NULL)
	{
		ptr->Release();
		ptr = QZ_NULL;
	}
}

template <typename T>
inline QZ_VOID SafeDeletePointer(T* & pointer)
{
	if (pointer)
	{
		delete pointer;
		pointer = QZ_NULL;
	}
}


template <typename Pointer>
inline QZ_VOID SafeDeleteArrayPointer(Pointer& pointer)
{
	if (pointer)
	{
		delete[] pointer;
		pointer = QZ_NULL;
	}
}


template<typename T>
inline QZ_VOID SafeFreePointer(T*& pointer)
{
	if (pointer)
	{
		QZ_FREE(pointer);
		pointer = QZ_NULL;
	}
}

template <typename Iterator>
inline QZ_VOID DeleteObjInRange(const Iterator& iterBegin, const Iterator& iterEnd)
{
	for (Iterator iter = iterBegin; iter != iterEnd; iter++)
	{
		if (*iter)
		{
			delete (*iter);
		}
	}
}

template <typename Pointer>
inline QZ_VOID SafeDeleteVector(Pointer& pointer)
{
	if (pointer)
	{
		DeleteObjInRange(pointer->begin(), pointer->end());
		delete pointer;
		pointer = QZ_NULL;
	}
}

template <typename Vector>
inline QZ_VOID ClearObjectInVector(Vector& vec)
{
	DeleteObjInRange(vec.begin(), vec.end());
	vec.clear();
}


#endif//_GUOKAIEPUBPAGE_H_
