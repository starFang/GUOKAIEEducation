//
//  DataManager.h
//  Zip1Demo
//
//  Created by qanzone on 13-9-11.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

- (NSString *)FileContentPath:(NSString *)bookName;
- (NSString *)fileContentImagePath:(NSString *)bookName;
+(NSMutableArray *)getArrayFromPlist:(NSString *)path;
//下划线颜色
+(NSString *) FileColorPath;
//取出下划线的颜色
+(NSString *)getStringFromPlist:(NSString *)path;
@end
