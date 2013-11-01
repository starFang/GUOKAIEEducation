//
//  PageQuestionConnection.m
//  Question
//
//  Created by qanzone on 13-10-12.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionConnection1.h"

@implementation PageQuestionConnection1
@synthesize strQuestion;
@synthesize vAnswers;
@synthesize vLeftSide;
@synthesize vRightSide;

- (id)init
{
    self = [super init];
    if (self) {
        self.vRightSide = [[NSMutableArray alloc]init];
        self.vLeftSide = [[NSMutableArray alloc]init];
        self.vAnswers = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [self.vAnswers release];
    self.vAnswers = nil;
    [self.vLeftSide release];
    self.vLeftSide = nil;
    [self.vRightSide release];
    self.vRightSide = nil;
    [super dealloc];
}

@end
