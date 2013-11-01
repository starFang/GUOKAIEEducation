//
//  QuestionRootView.h
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionList1.h"

#import "QuestionChoice.h"
#import "QuestionLine.h"
#import "QuestionDragPoint.h"
#import "QuestionBriefAnswer.h"
#import "QuestionSort.h"
#import "QuestionFillBlank.h"
#import "QuestionImageSelect.h"
#import "CTView.h"
#include "QZEpubPageObjs.h"

@interface QuestionRootView : UIView
<AnswerVerifyDelegate,UIScrollViewDelegate,QuestionLineAnswerVerifyDelegate,QDragAnswerVerifyDelegate,QBriefAnswerVerifyDelegate,QuestionSortAnswerVerifyDelegate,QFillBlankAnswerVerifyDelegate,QISelectArVerifyDelegate>
{
    UIScrollView *qSc;
   
    PageQuestionList *pQuestionList;
    CTView *ctv;
    CGFloat titHeight;
}

- (void)composition;
- (void)initIncomingData:(PageQuestionList*)pQuestionList;
@end
