//
//  QZBookMarkDataModel.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-11-2.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZBookMarkDataModel.h"

@implementation QZBookMarkDataModel

@synthesize bmDate = _bmDate;
@synthesize bmPageNumber = _bmPageNumber;
@synthesize bmPageTitle = _bmPageTitle;

- (NSString *)description
{
    return [NSString stringWithFormat:@"BMT : %@ BMD : %@ BMN :%d",self.bmPageTitle,self.bmDate,self.bmPageNumber];
}

@end
