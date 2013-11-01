//
//  PageQuestionFillBlank.m
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionFillBlank1.h"

@implementation PageQuestionFillBlank1

@synthesize vDescription;

- (id)init
{
    self = [super init];
    if (self) {
        self.vDescription = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [self.vDescription release];
    [super dealloc];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",self.vDescription];
}

@end
