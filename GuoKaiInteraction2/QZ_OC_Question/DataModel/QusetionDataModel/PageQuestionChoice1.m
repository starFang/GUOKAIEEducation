//
//  PageQuestionChoice.m
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionChoice1.h"

@implementation PageQuestionChoice1

@synthesize strQuestion;
@synthesize vAnswer;
@synthesize vChoices;

- (void)dealloc
{
    [self.vChoices release];
    self.vChoices = nil;
    [self.vAnswer release];
    self.vAnswer = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        vAnswer = [[NSMutableArray alloc]init];
        vChoices = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
