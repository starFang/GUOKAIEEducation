//
//  QZ_BOX.m
//  Question
//
//  Created by qanzone on 13-10-10.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZ_BOX1.h"

@implementation QZ_BOX1

@synthesize x0;
@synthesize x1;
@synthesize y0;
@synthesize y1;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f-%f-%f-%f",x0,y0,x1,y1];
}

@end
