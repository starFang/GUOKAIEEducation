//
//  XMLParserBookData.h
//  Zip1Demo
//
//  Created by qanzone on 13-9-11.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParserBookData : NSObject
<NSXMLParserDelegate>
{
    //    文件container.xml文件路径
    NSMutableString * rootPath;
    //    OPF（xml格式） 文件路径
    NSString *inOpfPath;
    //    OPS 文件夹路径
    NSMutableString * aOPSPath;
    //    NCX（xml格式） 文件路径
    NSString * inNCXPath;
    
    NSMutableDictionary *bookDataDict;
    BOOL flagOPF;
    BOOL flagNCX;
    BOOL flag_point;
    int num_text;
//    HTML <img src="image.jpg" attribute="xxxx.xml"/> 标签的解析
    int num_src;
    int num_page;
    int numSrc;
    int numAttribute;
    BOOL flagHTML;
    NSString * rootPathHTML;
}

-(NSString *)parse:(NSString *)bookName;
-(NSString *)parseNCX:(NSString *)opfPath;
#pragma mark - OPF
- (NSMutableDictionary *)GetBaseInfo:(NSString *)xmlPath;
@property (nonatomic, strong) NSString * title;

@property (nonatomic, strong) NSString * creator;

@property (nonatomic, strong) NSString * subject;

@property (nonatomic, strong) NSString * description;

@property (nonatomic, strong) NSMutableString * temp_key;

@property (nonatomic, strong) NSMutableString * temp_info;

#pragma mark - NCX 部分
- (NSArray *)GetBookDirectory:(NSString *)xmlPath;

@property (nonatomic, strong) NSString * rootPath;

@property (nonatomic, strong) NSMutableDictionary * dict_text;

@property (nonatomic, strong) NSMutableDictionary * dict_src;

@property (nonatomic, strong) NSMutableString * mString;

@property (nonatomic, strong) NSArray * array;

#pragma mark - HTML 部分
- (NSArray *)getHTMLData:(NSString *)xmlHtmlPath;
@property (nonatomic, strong) NSMutableArray *htmlArrayData;
@property (nonatomic, strong) NSMutableDictionary * htmlDictImage;
@property (nonatomic, strong) NSMutableDictionary * htmlDictXML;

@end
