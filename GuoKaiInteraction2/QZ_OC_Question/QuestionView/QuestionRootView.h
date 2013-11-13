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

@protocol QZQuestionDelegate <NSObject>
//停止滚动后面的大视图
- (void)scrollStop;
- (void)scrollStart;
@end

@interface QuestionRootView : UIView
<AnswerVerifyDelegate,UIScrollViewDelegate,QuestionLineAnswerVerifyDelegate,QDragAnswerVerifyDelegate,QBriefAnswerVerifyDelegate,QuestionSortAnswerVerifyDelegate,QFillBlankAnswerVerifyDelegate,QISelectArVerifyDelegate,QZQuestionDelegate>
{
    UIScrollView *qSc;
    PageQuestionList *pQuestionList;
    CTView *ctv;
    CGFloat titHeight;
    id<QZQuestionDelegate>delegate;
}
@property (nonatomic, assign)id<QZQuestionDelegate>delegate;
- (void)composition;
- (void)initIncomingData:(PageQuestionList*)pQuestionList;
@end
