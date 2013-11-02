//
//  QZParsingAndExtractingData.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-22.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZParsingAndExtractingData.h"
#import "ZipArchive.h"
#import "DataManager.h"

@implementation QZParsingAndExtractingData

- (void)dealloc
{
    [aOPSPath release];
    [xmlParser release];
    [super dealloc];
}
- (void)initIncomingData:(NSString *)bookName
{
    EpubBookName = [NSString stringWithString:bookName];
}
- (void)composition
{
    xmlParser = [[XMLParserBookData alloc]init];
    [self unZipData];
    [self parseData];
}

-(void)unZipData
{
    NSString *bookPath = [DOCUMENT stringByAppendingPathComponent:BOOKNAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bookPath])
    {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:EpubBookName ofType:@"zip"];
//    文件解压
        BOOL result;
        ZipArchive *za = [[ZipArchive alloc] init];
        if ([za UnzipOpenFile:filePath])
        {
//        文件准备解压缩
//        取得路径将数据写成文件内容，保存在Document文件夹中
            result = [za UnzipFileTo:[self dataFilePath:EpubBookName] overWrite:YES];
            [za UnzipCloseFile];
        }else{
            NSLog(@"%@ 解压未完成",EpubBookName);
        }
        //解压
        [za release];
    }
}

#pragma mark - 取得对应书名Documents的电子书的路径
-(NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

-(void)parseData
{
    NSString *bookName = [NSString stringWithString:EpubBookName];
#pragma mark - 文件解析第一步：1
#pragma mark - 由/META-INF/container.xml ==> 得到OPS/ibooks.opf
    NSString *opfPath = [xmlParser parse:bookName];
#pragma mark - 文件解析第二步：1
    NSString *bookPath = [DOCUMENT stringByAppendingPathComponent:bookName] ;
    inOpfPath=[bookPath stringByAppendingPathComponent:opfPath];
    
    NSArray * array=[inOpfPath componentsSeparatedByString:@"/"];
    //    分解路径得到OPS路径
    aOPSPath=[[NSMutableString alloc]initWithString:@""];
    for (int i=0; i<array.count-1; i++)
    {
        [aOPSPath appendString:[array objectAtIndex:i]];
        [aOPSPath appendString:@"/"];
    }
    NSString * ncxPath = [xmlParser parseNCX:inOpfPath];
    
#pragma mark - 文件解析第三步：OPF部分解析1
    NSMutableDictionary * dictBookData = [xmlParser GetBaseInfo:[bookPath stringByAppendingPathComponent:opfPath]];

#pragma mark - 文件解析第四步：NCX文件解析1
    NSArray * arrayNCX=[xmlParser GetBookDirectory:[aOPSPath stringByAppendingPathComponent:ncxPath]];

#pragma mark - 保存解析的目录和html顺序数组
    //    目录
    NSMutableArray *contentArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i<[[arrayNCX objectAtIndex:0] allKeys].count; i++)
    {
        //epub书中的目录有\n  ，这里是去掉\n
        NSString *contentTitle = [[[arrayNCX objectAtIndex:0]valueForKey:[NSString stringWithFormat:@"%d",i]]stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        //去空格
        contentTitle = [contentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //标准形式的目录的内容放入数组
        [contentArr addObject:contentTitle];
    }
    DataManager * dataManager = [[DataManager alloc]init];
    [contentArr writeToFile:[dataManager FileContentPath:bookName] atomically:YES];
    //    文章内容
    //    新建一个用来存储HTML文件和其对应的k值的字典
    NSDictionary * dict=[arrayNCX objectAtIndex:1];
    arrayHTML = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < [dict.allKeys count]; i++)
    {
        [arrayHTML addObject:[dict objectForKey:[NSString stringWithFormat:@"%d",i]]];
    }
    NSMutableArray *imageArray = [NSMutableArray array];
    //    遍历字典，找出其中的所有HTML中的图片标签和配置文件标签
    for (int i = 0; i< [arrayHTML count]; i++)
    {
        NSString * strKey = [arrayHTML objectAtIndex:i];
        //      下面是用来解析HTML，取得内容的
        NSArray *contentImageData = [[NSArray alloc]initWithArray:[xmlParser getHTMLData:[aOPSPath stringByAppendingPathComponent:strKey]]];
            [imageArray addObject:contentImageData ];
    }
    [imageArray writeToFile:[dataManager fileContentImagePath:bookName] atomically:YES];
    [dataManager release];
    
    [self getTheDirectory];
}

- (void)getTheDirectory
{
    NSMutableArray * arrayDirectory = [[NSMutableArray alloc]init];
    NSArray * array = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/contentDict.plist",BOOKNAME]];
    for (int i = 0; i < [array count]; i++)
    {
        NSMutableString *subDirectory = [NSMutableString string];
        [subDirectory setString:[array objectAtIndex:i]];
        NSMutableString * strDirect = [NSMutableString string];
        if ([[[[[subDirectory componentsSeparatedByString:@"|"] objectAtIndex:1] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]  == 1 )
        {
            //            一级标题
            [strDirect setString:[[subDirectory componentsSeparatedByString:@"|"] objectAtIndex:0]];
            
        }else if ([[[[[subDirectory componentsSeparatedByString:@"|"] objectAtIndex:1] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue] == 2)
        {
            //            二级标题
            [strDirect setString:[NSString stringWithFormat:@"        %@",[[subDirectory componentsSeparatedByString:@"|"] objectAtIndex:0]]];
        }
        [[[[subDirectory componentsSeparatedByString:@"|"] objectAtIndex:1] componentsSeparatedByString:@"-"] objectAtIndex:1];
        //        添加数据
        NSMutableArray *subArray = [NSMutableArray array];
        [subArray addObject:strDirect];
        [subArray addObject:[[[[subDirectory componentsSeparatedByString:@"|"] objectAtIndex:1] componentsSeparatedByString:@"-"] objectAtIndex:1]];
        [arrayDirectory addObject:subArray];
    }
    
    DataManager *dataManager = [[DataManager alloc]init];
    [arrayDirectory writeToFile:[dataManager FileContentPath:BOOKNAME] atomically:YES];
    [dataManager release];
}


@end
