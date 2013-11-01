//
//  PageQuestionImageSelect.h
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//
//ÕºœÒ—°‘ÒÃ‚image select
//struct PageQuestionImageSelect:public PageQuestionBase
//{
//	std::string                 strQuestion;
//	std::vector<std::string>    vStrImage;
//	std::vector<QZ_INT>         vAnswers;
//};
#import "PageQuestionBase1.h"

@interface PageQuestionImageSelect1 : PageQuestionBase1
{
    NSString * strQuestion;
    NSMutableArray *vStrImage;
    NSMutableArray *vAnswers;
}

@property (nonatomic, copy) NSString * strQuestion;
@property (nonatomic, retain) NSMutableArray *vStrImage;
@property (nonatomic, retain) NSMutableArray *vAnswers;

@end
