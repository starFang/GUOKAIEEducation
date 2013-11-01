//
//  PageQuestionImageSelect.m
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//



#import "PageQuestionImageSelect1.h"

@implementation PageQuestionImageSelect1

@synthesize strQuestion;
@synthesize vAnswers;
@synthesize vStrImage;

- (id)init
{
    self = [super init];
    if (self) {
        self.vStrImage = [[NSMutableArray alloc]init];
        self.vAnswers = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [self.vAnswers release];
    [self.vStrImage release];
    [super dealloc];
}


-(NSString *)description
{

    return [NSString stringWithFormat:@"\n%@\n%@\n%@\n",self.strQuestion,self.vAnswers,self.vStrImage];
}
@end
