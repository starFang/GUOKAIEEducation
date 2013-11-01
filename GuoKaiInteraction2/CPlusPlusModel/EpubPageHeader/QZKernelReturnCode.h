//===========================================================================
// Summary:
//     Kernel返回值的定义
// Usage:
//     Null
// Remarks:
//     Null
// Date:
//     2013-08-18
// Author:
//     xk(xk@qanzone.com)
//===========================================================================

#ifndef __KERNEL_COMMONLIBS_KERNELBASE_QZKERNELRETURNCODE_H_
#define __KERNEL_COMMONLIBS_KERNELBASE_QZKERNELRETURNCODE_H_

typedef long QZ_ReturnCode;

// 成功
#define QZR_OK                      0L
// 失败
#define QZR_FAILED                  1L
// 无法预知的失败
#define QZR_UNPREDICTABLE_ERROR     2L
// 没有实现
#define QZR_NOIMPLEMENT             3L
// 未初始化
#define QZR_UNINIT                  4L
// 无效参数
#define QZR_VALIDINPARAM			5L
// 内存错误
#define QZR_MEMORY_ERROR			7L


// 各模块自定义的错误返回码
// QZR_模块名_BASEVALUE	1000L
// QZR_模块名_MAXVALUE 1999L
#define QZR_CRYPT_BASEVALUE			1000L
#define QZR_CRYPT_MAXVALUE			1999L

//Epub解析错误
#define QZR_EPUBLIB_BASEVALUE		2000L
#define QZR_EPUBLIB_MAXVALUE		2999L

// 流式读写错误码
#define QZR_STREAM_BASEVALUE		3000L
#define QZR_STREAM_MAXVALUE			3999L
#endif//__KERNEL_COMMONLIBS_KERNELBASE_QZKERNELRETURNCODE_H_