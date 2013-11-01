//
//  PageQuestionList.m
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionList1.h"

@implementation PageQuestionList1
@synthesize titleName = _titleName;
@synthesize vQuestions = _vQuestions;

- (id)init
{
    self = [super init];
    if (self) {
        self.vQuestions = [[NSMutableArray alloc]init];
    }
    return self;
}


- (void)dealloc
{
    [self.vQuestions release];
    [super dealloc];
}

@end
