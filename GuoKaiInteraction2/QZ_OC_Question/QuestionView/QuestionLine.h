//
//  QuestionLine.h
//  Question
//
//  Created by qanzone on 13-10-9.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionConnection1.h"
#include "QZEpubPageObjs.h"
@protocol QuestionLineAnswerVerifyDelegate <NSObject>

- (void)isToVerifyAnswer;
- (void)isReadyVerifiedAnswers;
- (void)isToEliminateAnswer;

@end

@interface QuestionLine : UIView
{
    UILabel *titleNumber;
    UILabel *titleContent;
    CGPoint p1;
    CGPoint p2;
    id<QuestionLineAnswerVerifyDelegate>delegate;
    NSMutableArray *pointToPointArray;
//    正确答案的点的数组
    NSMutableArray *theCorrectPointAnswerArray;
    PageQuestionConnection1 *qConnection;
//    记录是否验证答案
    BOOL isVerifiedAnswer;
}

@property (nonatomic, copy) NSString *questionTitleNumber;
@property (nonatomic, assign) id<QuestionLineAnswerVerifyDelegate>delegate;
@property (nonatomic, retain) PageQuestionConnection1 *qConnection;
- (void)initQuestionChoiceData:(PageQuestionConnection *)pQuestionC;
- (void)composition;
- (void)rightAnswerVerift;
- (void)clearAnswerButton;
- (void)isCloseTheInputTextView;
- (void)theAnswerIsToVerifyWhether;

@end
