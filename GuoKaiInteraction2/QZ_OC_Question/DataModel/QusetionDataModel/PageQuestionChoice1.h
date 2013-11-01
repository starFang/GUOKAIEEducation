//
//  PageQuestionChoice.h
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionBase1.h"

@interface PageQuestionChoice1 : PageQuestionBase1

{
    NSString *strQuestion;
	NSMutableArray *vChoices;
	NSMutableArray *vAnswer;
}

@property (nonatomic, copy)NSString *strQuestion;
@property (nonatomic, retain)NSMutableArray *vChoices;
@property (nonatomic, retain)NSMutableArray *vAnswer;

@end
