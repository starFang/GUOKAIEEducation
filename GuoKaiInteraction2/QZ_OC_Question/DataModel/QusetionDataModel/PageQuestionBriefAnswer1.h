//
//  PageQuestionBriefAnswer.h
//  Question
//
//  Created by qanzone on 13-10-11.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionBase1.h"

@interface PageQuestionBriefAnswer1 : PageQuestionBase1
{
    NSString *_strQuestion;
    NSString *_strAnswer;
}

@property (nonatomic, copy) NSString *strQuestion;
@property (nonatomic, copy) NSString *strAnswer;

@end
