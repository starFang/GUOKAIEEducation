//
//  PageQuestionDragPoint.m
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionDragPoint1.h"

@implementation PageQuestionDragPoint1
@synthesize rect;
@synthesize nAnswer;
- (void)dealloc
{
    [self.rect release];
    self.rect = nil;
    [super dealloc];
}
@end
