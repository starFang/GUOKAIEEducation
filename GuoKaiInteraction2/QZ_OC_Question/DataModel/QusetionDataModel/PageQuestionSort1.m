//
//  PageQuestionSort.m
//  Question
//
//  Created by qanzone on 13-10-13.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionSort1.h"

@implementation PageQuestionSort1

@synthesize strQuestion;
@synthesize vSortedList;
@synthesize vStrTexts;

- (id)init
{
    self = [super init];
    if (self) {
        self.vStrTexts = [[NSMutableArray alloc]init];
        self.vSortedList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [self.vSortedList release];
    self.vSortedList = nil;
    [self.vStrTexts release];
    self.vStrTexts = nil;
    [super dealloc];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\n%@\n%@\n",self.strQuestion,self.vStrTexts,self.vSortedList];
}

@end
