//
//  QuestionSort.h
//  Question
//
//  Created by qanzone on 13-10-13.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionSort1.h"
#include "QZEpubPageObjs.h"
@protocol QuestionSortAnswerVerifyDelegate <NSObject>

- (void)isToVerifyAnswer;
- (void)isReadyVerifiedAnswers;
- (void)isToEliminateAnswer;
@end


@interface QuestionSort : UIView
<UITableViewDataSource,UITableViewDelegate,QuestionSortAnswerVerifyDelegate>
{
    
    UITableView *_answerTableView;
    PageQuestionSort1 *qSort;
    UILabel *titleNumber;
    UILabel *titleContent;
    id<QuestionSortAnswerVerifyDelegate>delegate;
    //    用来记录是否验证答案
    BOOL isVerifiedAnswer;
    NSMutableArray * resultArray;
}

@property (nonatomic, retain)PageQuestionSort1 *qSort;
@property (nonatomic, copy) NSString *questionTitleNumber;
@property (nonatomic, retain)UITableView *answerTableView;
@property (nonatomic, assign)id<QuestionSortAnswerVerifyDelegate>delegate;

- (void)initQuestionChoiceData:(PageQuestionSort *)pQuestionSort;
- (void)composition;

- (void)creatquestionTitleNumber;
- (void)creatquestionTitleContent;
- (void)rightAnswerVerift;
- (void)clearAnswerButton;
- (void)isCloseTheInputTextView;

@end
