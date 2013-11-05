//
//  Database.m
//  JsonDemo
//
//  Created by DuHaiFeng on 13-7-24.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import "Database.h"
#import "QZLineDataModel.h"

//静态全局变量(唯一数据库操作类对象)
static Database * gl_database=nil;

@implementation Database
+(Database*)sharedDatabase
{
    if (!gl_database) {
        gl_database=[[Database alloc] init];
    }
    return gl_database;
}

+(NSString*)filePath:(NSString *)fileName
{
    //当前程序的沙盒目录
    NSString *path = [DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",BOOKNAME]];
    NSFileManager *fm=[NSFileManager defaultManager];
    //检查指定的缓存目录是否存在
    if ([fm fileExistsAtPath:path])
    {
        //检查要保存的文件名是否合法
        if (fileName && [fileName length]!=0)
        {
            //拼接全路径
            path=[path stringByAppendingPathComponent:fileName];
        }
    }else{
        NSLog(@"缓存目录不存在");
    }
    return path;
}

//创建表PAGEINFORMATION表，记录数据
-(void)createTable
{
    NSArray *array=[NSArray arrayWithObjects:@"CREATE TABLE PageInfo (id integer PRIMARY KEY AUTOINCREMENT DEFAULT 0,createTime TEXT DEFAULT NULL,pageNumber TEXT DEFAULT NULL,startIndex TEXT DEFAULT NULL,endIndex TEXT DEFAULT NULL,lineWords TEXT DEFAULT NULL,writeIn TEXT DEFAULT NULL,lineColor TEXT DEFAULT NULL)", nil];
    
    for (NSString *sql in array)
    {
        //执行sql语句
        //创建表，增，删，改都用这个方法
        if (![fmdb executeUpdate:sql])
        {
            NSLog(@"创建表失败:%@",[fmdb lastErrorMessage]);
        }
    }
}

- (void)createTableWithBookMark
{
    NSArray *array=[NSArray arrayWithObjects:@"CREATE TABLE bookMark (id integer  PRIMARY KEY AUTOINCREMENT DEFAULT 0,createTime Timestamp DEFAULT 0,modeTime Timestamp DEFAULT 0,author Varchar,chapterId Varchar DEFAULT NULL,fileOffset integer DEFAULT NULL,chapterIndex integer DEFAULT NULL,paraIndex integer DEFAULT NULL,autoIndex integer DEFAULT NULL,comment TEXT DEFAULT NULL)", nil];
    
    for (NSString *sql in array)
    {
        //执行sql语句
        //创建表，增，删，改都用这个方法
        if (![fmdb executeUpdate:sql])
        {
         NSLog(@"创建表失败:%@",[fmdb lastErrorMessage]);
        }
    }
}

-(id)init
{
    if (self=[super init])
    {
        //实例化第三方数据库操作类对象
        //如果user.db文件不存在就创建新的
        //存在就直接使用
        fmdb=[[FMDatabase databaseWithPath:[Database filePath:@"book.db"]] retain];
        //尝试打开数据库
        if ([fmdb open])
        {
            //创建数据表
            [self createTable];
//            [self createTableWithBookMark];
        }else{
            NSLog(@"数据库未打开");
        }
    }
    return self;
}

//插入一条记录
//变参方法，每个?号代表一个字段值,所有参数必须为对象类类型
-(void)insertItem:(QZLineDataModel *)item
{
    if ([self existsItem:item])
    {
        return;
    }
    NSString *sql=[NSString stringWithFormat:@"insert into PageInfo (createTime,pageNumber,startIndex,endIndex,writeIn,lineColor,lineWords) values (?,?,?,?,?,?,?)"];
    if (![fmdb executeUpdate:sql,item.lineDate,item.linePageNumber,item.lineStartIndex,item.lineEndIndex,item.lineCritique,item.lineColor,item.lineWords])
    {
        NSLog(@"插入失败 :%@",[fmdb lastErrorMessage]);
    }
}
-(void)insertArray:(NSArray *)array
{
    //开始批量操作
    [fmdb beginTransaction];
    for (QZLineDataModel *item in array)
    {
        [self insertItem:item];
    }
    //提交所有修改
    [fmdb commit];
}

-(NSArray*)selectData:(NSInteger)startIndex count:(NSInteger)count
{
    //查询指定位置startIndex开始的count条记录
    NSString *sql=[NSString stringWithFormat:@"select username,uid,headimage,realname limit %d,%d",startIndex,count];
    NSMutableArray *array=[NSMutableArray array];
    //执行查询
    FMResultSet *rs=[fmdb executeQuery:sql];
    //如果有记录
    while ([rs next])
    {
        //此方法是一组方法
        //根据字段类型选择不同方法
        QZLineDataModel *item=[[[QZLineDataModel alloc] init] autorelease];
        item.lineWords = [rs stringForColumn:@"lineWords"];
        item.lineCritique=[rs stringForColumn:@"writeIn"];
        item.lineDate = [rs stringForColumn:@"createTime"];
        item.linePageNumber=[rs stringForColumn:@"pageNumber"];
        item.lineStartIndex=[rs stringForColumn:@"startIndex"];
        item.lineEndIndex = [rs stringForColumn:@"endIndex"];
        item.lineColor = [rs stringForColumn:@"lineColor"];
        [array addObject:item];
    }
    return array;
}

- (NSArray *)selectData:(NSInteger)pageNum
{
    NSString *sql = [NSString stringWithFormat:@"select * from PageInfo where pageNumber = %d",pageNum];
    FMResultSet * rs = [fmdb executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([rs next])
    {
        QZLineDataModel *item=[[QZLineDataModel alloc] init];
        //此方法是一组方法//根据字段类型选择不同方法
        item.lineID = [rs stringForColumn:@"id"];
        item.lineWords = [rs stringForColumn:@"lineWords"];
        item.lineCritique=[rs stringForColumn:@"writeIn"];
        item.lineDate = [rs stringForColumn:@"createTime"];
        item.linePageNumber=[rs stringForColumn:@"pageNumber"];
        item.lineStartIndex=[rs stringForColumn:@"startIndex"];
        item.lineEndIndex = [rs stringForColumn:@"endIndex"];
        item.lineColor = [rs stringForColumn:@"lineColor"];
        [array addObject:item];
        [item release];
    }
    return [array autorelease];
}

-(NSArray *)selectAllData
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM PageInfo ORDER BY pageNumber ASC"];
    FMResultSet * rs = [fmdb executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([rs next])
    {
        QZLineDataModel *item=[[QZLineDataModel alloc] init];
        item.lineID = [rs stringForColumn:@"id"];
        item.lineWords = [rs stringForColumn:@"lineWords"];
        item.lineCritique=[rs stringForColumn:@"writeIn"];
        item.lineDate = [rs stringForColumn:@"createTime"];
        item.linePageNumber=[rs stringForColumn:@"pageNumber"];
        item.lineStartIndex=[rs stringForColumn:@"startIndex"];
        item.lineEndIndex = [rs stringForColumn:@"endIndex"];
        item.lineColor = [rs stringForColumn:@"lineColor"];
        [array addObject:item];
        [item release];
    }    
    return [array autorelease];
}

-(BOOL)existsItem:(QZLineDataModel *)item
{
    NSString *sql=[NSString stringWithFormat:@"select username from user where uid=?"];
    FMResultSet *rs=[fmdb executeQuery:sql,item.linePageNumber];
    while ([rs next])
    {
        return YES;
    }
    return NO;
}

-(NSInteger)count
{
    NSString *sql=[NSString stringWithFormat:@"select count(uid) from user"];
    FMResultSet *rs=[fmdb executeQuery:sql];
    while ([rs next])
    {
        //因为结果中有一列，所以通过索引获得
        return [rs intForColumnIndex:0];
    }
    return 0;
}

- (void)update:(NSString *)newStr WithOld:(NSString *)oldStr with:(NSString *)lID
{
   [fmdb executeUpdate:@"UPDATE PageInfo SET lineColor = ? WHERE lineColor = ? AND id = ? ",newStr,newStr,lID];
    NSLog(@"修改成功");
}

- (void)deleteLine:(NSInteger)lID
{
    [fmdb executeUpdate:@"DELETE FROM PageInfo WHERE id = ?",[NSString stringWithFormat:@"%d",lID]];
    NSLog(@"删除成功！！！");
}

- (void)deletePageData:(NSString *)pageNumber
{
    [fmdb executeUpdate:@"DELETE FROM PageInfo WHERE pageNumber = ?",pageNumber];
}

@end
