//
//  QZDirectDataModel.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-11-2.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZDirectDataModel.h"

@implementation QZDirectDataModel
@synthesize dPageNumber = _dPageNumber;
@synthesize dPageTitle  =_dPageTitle;

- (NSString *)description
{
    return [NSString stringWithFormat:@"DT : %@ DPN :%@",self.dPageTitle,self.dPageNumber];
}

@end
