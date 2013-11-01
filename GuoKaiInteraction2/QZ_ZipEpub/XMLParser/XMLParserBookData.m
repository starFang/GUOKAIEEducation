//
//  XMLParserBookData.m
//  Zip1Demo
//
//  Created by qanzone on 13-9-11.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "XMLParserBookData.h"

@implementation XMLParserBookData
//OPF
@synthesize creator;
@synthesize description;
@synthesize subject;
@synthesize temp_info;
@synthesize temp_key;
@synthesize title;
//NCX
@synthesize rootPath;
@synthesize dict_src;
@synthesize dict_text;
@synthesize mString;
@synthesize array;
//HTML内容
@synthesize htmlDictImage;
@synthesize htmlDictXML;
@synthesize htmlArrayData;


#pragma mark - 文件解析第一步：2
-(NSString *)parse:(NSString *)bookName
{
    NSString *bookPath = [DOCUMENT stringByAppendingPathComponent:bookName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bookPath])
    {
#pragma mark - 文件的开始路径/META-INF/container.xml
        NSString * containerPath = [NSString stringWithFormat:@"%@%@",bookPath ,@"/META-INF/container.xml"];
        if ([fileManager fileExistsAtPath:containerPath])
        {
            NSFileHandle * file=[NSFileHandle fileHandleForReadingAtPath:containerPath];
            NSData * xmlData=[file readDataToEndOfFile];
            NSXMLParser * xmlParser=[[NSXMLParser alloc]initWithData:xmlData];
            xmlParser.delegate = self;
            
            if([xmlParser parse])
            {
                return rootPath;
            }else{
                
                NSLog(@"文件无法解析啦！！");
            }
        }
    }else{
        NSLog(@"not exists");
    }    
    return nil;
}

#pragma mark - 文件解析第二步：2
-(NSString *)parseNCX:(NSString *)opfPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:opfPath])
    {
        NSFileHandle * file=[NSFileHandle fileHandleForReadingAtPath:opfPath];
        NSData * xmlData=[file readDataToEndOfFile];
        NSXMLParser * xmlParser=[[NSXMLParser alloc]initWithData:xmlData];
        xmlParser.delegate = self;
        
        if([xmlParser parse])
        {
            return inNCXPath;
        }else
        {
            NSLog(@"文件无法解析啦！！");
        }
    }
    else return nil;
}

#pragma mark - 文件解析第三步：OPF部分解析2
-(NSMutableDictionary *)GetBaseInfo:(NSString *)xmlPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:xmlPath] )
    {
        NSFileHandle * file = [NSFileHandle fileHandleForReadingAtPath:xmlPath];
        NSData * xmlData = [file readDataToEndOfFile];
        NSXMLParser * xmlParser = [[NSXMLParser alloc]initWithData:xmlData];
        [xmlParser setDelegate:self];
        
        bookDataDict = [[NSMutableDictionary alloc]init];
        temp_key = [[NSMutableString alloc]init];
        
        if([xmlParser parse])
        {
            return bookDataDict;
        }
        else return nil;
    }
    else return nil;
}

#pragma mark - 文件解析第四步：NCX文件解析2
-(NSArray *)GetBookDirectory:(NSString *)xmlPath
{
    
    NSFileHandle * file=[NSFileHandle fileHandleForReadingAtPath:xmlPath];
    NSData * xmlData=[file readDataToEndOfFile];
    NSXMLParser * xmlParser=[[NSXMLParser alloc]initWithData:xmlData];
    [xmlParser setDelegate:self];
    dict_src=[[NSMutableDictionary alloc]init];
    dict_text=[[NSMutableDictionary alloc]init];
    num_src=0;
    num_text=0;
    num_page = 0;
    flag_point=NO;
    flagNCX=NO;
    if([xmlParser parse])
    {
        array=[[NSArray alloc]initWithObjects:dict_text,dict_src, nil];
        return array;
    }
    else return nil;
}

#pragma mark - HTML内容解析
- (NSArray *)getHTMLData:(NSString *)filePath
{
    NSFileHandle * filehandele=[NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData * tdata=[filehandele readDataToEndOfFile];
    NSXMLParser * xmlParser=[[NSXMLParser alloc]initWithData:tdata];
    [xmlParser setDelegate:self];
    htmlDictImage = [[NSMutableDictionary alloc]init];
    htmlDictXML = [[NSMutableDictionary alloc]init];
    numSrc = 0;
    numAttribute = 0;
    flagHTML = NO;
    htmlArrayData = [[NSMutableArray alloc]init];
    if ([xmlParser parse])
    {
        return htmlArrayData;
    }
    else return nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    container.xml文件
    if([elementName isEqualToString:@"rootfile"])
    {
        rootPath=[attributeDict objectForKey:@"full-path"];
    }
    if ([elementName isEqualToString:@"item"]&&[[attributeDict objectForKey:@"media-type"] isEqualToString:@"application/x-dtbncx+xml"])
    {
        inNCXPath = [attributeDict objectForKey:@"href"];
    }
    
//    OPF
    if (   [elementName isEqualToString:@"dc:title"]
        || [elementName isEqualToString:@"dc:language"]
        || [elementName isEqualToString:@"dc:publisher"]
        || [elementName isEqualToString:@"dc:description"]
        || [elementName isEqualToString:@"dc:date"])
    {
        flagOPF=YES;
        [temp_key setString:elementName];
    }
       
//    NCX
    if([elementName isEqualToString:@"navPoint"])
    {
        flag_point=YES;
    }
    if([elementName isEqualToString:@"text"])
    {
        flagNCX=YES;
    }
    if([elementName isEqualToString:@"content"])
    {
        [dict_src setObject:[attributeDict objectForKey:@"src"] forKey:[[NSString alloc]initWithFormat:@"%d",num_src++]];
    }
    
#pragma mark - HTML <img src="image.jpg" attribute="xxxx.xml"/> 标签的解析
    if ([elementName isEqualToString:@"img"])
    {
        [htmlDictImage setObject:[attributeDict objectForKey:@"src"] forKey:[NSString stringWithFormat:@"%d",0]];
        [htmlArrayData addObject:htmlDictImage];
        [htmlDictXML setObject:[attributeDict objectForKey:@"attribute"] forKey:[NSString stringWithFormat:@"%d",1]];
        [htmlArrayData addObject:htmlDictXML];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(flagOPF)
    {
        if(temp_info!=nil)
        {
            [temp_info appendString:string];
        }
        else{
            temp_info=[[NSMutableString alloc]init];
            [temp_info setString:string];
        }
    }
    
    if (flagNCX && flag_point)
    {
        if(mString!=nil && string != nil)
        {
            [mString appendString:string];
            
        }else{
            mString=[[NSMutableString alloc]init];
            [mString setString:string];
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(flagOPF)
    {
        [bookDataDict setValue:temp_info forKey:temp_key];
        flagOPF=NO;
        temp_info=nil;
    }
    
    if (flagNCX && flag_point)
    {
        //      将目录字符串添加到dict_text中去 并且编号
        if (mString != nil)
        {
            [mString appendString:[NSString stringWithFormat:@"-%d",num_page]];
            [dict_text setObject:mString forKey:[NSString stringWithFormat:@"%d",num_text++]];
        }
        mString=nil;
        flagNCX=NO;
        flag_point=NO;
        num_page++;
    }
}

- (void)dealloc
{
    [htmlArrayData release];
    [htmlDictImage release];
    [htmlDictXML release];
    [super dealloc];
}

@end
