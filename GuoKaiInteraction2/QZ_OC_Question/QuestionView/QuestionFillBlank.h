//
//  QuestionFillBlank.h
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionFillBlank1.h"
#include "QZEpubPageObjs.h"

@protocol QFillBlankAnswerVerifyDelegate <NSObject>

- (void)isToVerifyAnswer;
- (void)isReadyVerifiedAnswers;
- (void)isToEliminateAnswer;
- (CGFloat)superviewHeight;
- (CGFloat)superviewOriginY;

@end

@interface QuestionFillBlank : UIView<QFillBlankAnswerVerifyDelegate,UITextViewDelegate>
{
    id<QFillBlankAnswerVerifyDelegate>delegate;
    PageQuestionFillBlank1 *qFillBlank;
    UILabel *titleNumber;
    UILabel *titleContent;
    //    用来记录是否验证答案
    BOOL isVerifiedAnswer;
    
//    用来记录正确答案的个数
    NSInteger countOfAnswer;
//    用来记录输入的答案 和 正确的答案
    NSMutableArray *inputAnswerArray;
    NSMutableArray *rightAnswerArray;
    
    //    用来存储输入框的frame信息
    CGRect inputSCFrame;
    NSTimeInterval aniDuration;
//    键盘的高度
    CGFloat keyboardHeight;
 }
@property (nonatomic,assign) id<QFillBlankAnswerVerifyDelegate>delegate;
@property (nonatomic, copy) NSString *questionTitleNumber;
@property (nonatomic, retain) PageQuestionFillBlank1 *qFillBlank;
- (void)initQuestionChoiceData:(PageQuestionFillBlank *)pQuestionFillBlank;
- (void)composition;

- (void)rightAnswerVerift;
- (void)clearAnswerButton;
- (void)isCloseTheInputTextView;
- (void)theAnswerIsToVerifyWhether;


@end
