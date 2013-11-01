//
//  PageQuestionFillBlank.h
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//

//struct PageQuestionFillBlank:public PageQuestionBase
//{
//	std::vector<PageQuestionFillBlankItem> vDescription;
//};


#import "PageQuestionBase1.h"

@interface PageQuestionFillBlank1 : PageQuestionBase1
{
    NSMutableArray *vDescription;
}

@property (nonatomic, retain)NSMutableArray *vDescription;

@end
