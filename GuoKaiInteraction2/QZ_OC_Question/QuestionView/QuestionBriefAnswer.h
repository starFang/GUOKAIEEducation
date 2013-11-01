//
//  QuestionBriefAnswer.h
//  Question
//
//  Created by qanzone on 13-10-11.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionBriefAnswer1.h"
#include "QZEpubPageObjs.h"

@protocol QBriefAnswerVerifyDelegate <NSObject>

- (void)isToVerifyAnswer;
- (void)isReadyVerifiedAnswers;
- (void)isToEliminateAnswer;
- (CGFloat)superviewHeight;
- (CGFloat)superviewOriginY;

@end

@interface QuestionBriefAnswer : UIView<UITextViewDelegate>
{
    UILabel *titleNumber;
    UILabel *titleContent;
    PageQuestionBriefAnswer1 *_qBrifeAnswer;
    id<QBriefAnswerVerifyDelegate>delegate;
    //    用来记录是否验证答案
    BOOL isVerifiedAnswer;
    //    用来记录输入的答案
    NSMutableString *inputAnswerString;
//    用来存储输入框的frame信息
    CGRect inputTVFrame;
    NSTimeInterval aniDuration;
    
}

@property (nonatomic ,retain)PageQuestionBriefAnswer1 *qBrifeAnswer;
@property (nonatomic, copy) NSString *questionTitleNumber;
@property (nonatomic, assign)id<QBriefAnswerVerifyDelegate>delegate;

//- (void)creatquestionTitleNumber;
//- (void)creatquestionTitleContent;
- (void)rightAnswerVerift;
- (void)clearAnswerButton;
- (void)isCloseTheInputTextView;
- (void)theAnswerIsToVerifyWhether;
- (void)initQuestionChoiceData:(PageQuestionBriefAnswer *)qBriefAnswerData;
- (void)composition;
@end
