//
//  PageQuestionDrag.m
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionDrag1.h"

@implementation PageQuestionDrag1

@synthesize strBackGroundImage = _strBackGroundImage;
@synthesize strQuestion = _strQuestion;
@synthesize vImageSide = _vImageSide;
@synthesize vStringSide = _vStringSide;

- (id)init
{
    self = [super init];
    if (self) {
        self.vStringSide = [[NSMutableArray alloc]init];
        self.vImageSide = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)dealloc
{
    [self.vImageSide release];
    self.vImageSide = nil;
    [self.vStringSide release];
    self.vStringSide = nil;
    [super dealloc];
}
@end
