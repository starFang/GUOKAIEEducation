//
//  QuestionChoice.h
//  Question
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionChoice1.h"
#include "QZEpubPageObjs.h"
@protocol AnswerVerifyDelegate <NSObject>
- (void)isToVerifyAnswer;
- (void)isReadyVerifiedAnswers;
- (void)isToEliminateAnswer;
@end

@interface QuestionChoice : UIView
{
    NSString *_questionTitleNumber;
    PageQuestionChoice1 *qChoice;
    UILabel *titleNumber;
    UILabel *titleContent;
    
//    设置代理
    id<AnswerVerifyDelegate>delegate;
    
//    用来记录是否验证答案
    BOOL isVerifiedAnswer;
//    用来记录答案的个数
    NSMutableArray *answerNumber;
    
}
@property (nonatomic, copy) NSString *questionTitleNumber;
@property (nonatomic, assign) id<AnswerVerifyDelegate>delegate;
@property (nonatomic, retain) PageQuestionChoice1 *qChoice;

- (void)rightAnswerVerift;
- (void)clearAnswerButton;
- (void)isCloseTheInputTextView;
- (void)theAnswerIsToVerifyWhether;
- (void)initQuestionChoiceData:(PageQuestionChoice *)qChoiceData;
- (void)composition;
@end
