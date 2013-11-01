//
//  PageQuestionList.h
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageBaseElements1.h"

@interface PageQuestionList1 : PageBaseElements1
{
//标题 先用字符串代替
    NSString *_titleName;
    NSMutableArray *_vQuestions;
}

@property (nonatomic, retain)NSMutableArray *vQuestions;
@property (nonatomic, copy)NSString *titleName;

@end
