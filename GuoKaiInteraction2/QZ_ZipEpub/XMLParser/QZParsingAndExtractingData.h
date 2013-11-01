//
//  QZParsingAndExtractingData.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-22.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParserBookData.h"
@interface QZParsingAndExtractingData : NSObject
{
    NSString *EpubBookName;
    //    文件container.xml文件路径
    NSMutableString * rootPath;
    //    OPF（xml格式） 文件路径
    NSString *inOpfPath;
    //    OPS 文件夹路径
    NSMutableString * aOPSPath;
    //    NCX（xml格式） 文件路径
    NSString * inNCXPath;
    XMLParserBookData *xmlParser;
    
    NSMutableArray *arrayHTML;
}
- (void)initIncomingData:(NSString *)bookName;
- (void)composition;

@end
