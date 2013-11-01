//
//  Database.h
//  JsonDemo
//
//  Created by DuHaiFeng on 13-7-24.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import <Foundation/Foundation.h>
//包含 第三方数据库封装类头文件
#import "FMDatabase.h"

@class QZLineDataModel;

@interface Database : NSObject
{
    //第三方数据库封装类对象
    FMDatabase *fmdb;
}

//类方法获得当前类对象
+(Database*)sharedDatabase;
//获得指定名称的文件在沙盒目录下的全路径
+(NSString*)filePath:(NSString*)fileName;
//插入一条记录
-(void)insertItem:(QZLineDataModel*)item;
//插入多条记录
-(void)insertArray:(NSArray *)array;
//读取指定位置startIndex开始的count条记录
-(NSArray*)selectData:(NSInteger)startIndex count:(NSInteger)count;
//读取指定页码的数据
- (NSArray *)selectData:(NSInteger)pageNum;
//获得数据库中的记录条数
-(NSInteger)count;
//查询要插入的新用户是否存在
-(BOOL)existsItem:(QZLineDataModel*)item;
//删除数据库中的一条数据
- (void)deleteLine:(NSInteger)lID;
//删除数据库中的当前页数据
- (void)deletePageData:(NSString *)pageNumber;
//修改数据库中，其中一条记录的下划线的颜色
- (void)update:(NSString *)newStr WithOld:(NSString *)oldStr with:(NSString *)lID;
@end



