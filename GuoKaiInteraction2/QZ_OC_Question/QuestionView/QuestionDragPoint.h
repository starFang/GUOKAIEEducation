//
//  QuestionDragPoint.h
//  Question
//
//  Created by qanzone on 13-10-10.
//  将文字拖动到图片
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionDrag1.h"
#import "PageQuestionDragPoint1.h"
#include "QZEpubPageObjs.h"

@protocol QDragAnswerVerifyDelegate <NSObject>

- (void)isToVerifyAnswer;
- (void)isReadyVerifiedAnswers;
- (void)isToEliminateAnswer;
- (void)initQuestionChoiceData:(PageQuestionConnection *)pQuestionC;
@end


@interface QuestionDragPoint : UIView<UIGestureRecognizerDelegate>
{
    UILabel *titleNumber;
    UILabel *titleContent;
    UIImageView *backImageView;
    PageQuestionDrag1 *_dragQuestion;
    
    id<QDragAnswerVerifyDelegate>delegate;
//    拖动控制
    CGPoint distancePoint;
    CGPoint firstPoint;
    CGPoint startPoint;
//    记录最初的坐标数组ZQ_BOX类型
    NSMutableArray *imageArrayRect;
//    记录答案数组的坐标
    NSMutableArray *answerArray;
//    判断是否验证答案
    BOOL isVerifiedAnswer;
}
@property (nonatomic, copy) NSString *questionTitleNumber;
@property (nonatomic, copy) NSString *questionTitleContent;
@property (nonatomic, retain) PageQuestionDrag1 *dragQuestion;
@property (nonatomic, assign) id<QDragAnswerVerifyDelegate>delegate;
- (void)initQuestionChoiceData:(PageQuestionDrag *)dragQuset;
- (void)composition;

- (void)rightAnswerVerift;
- (void)clearAnswerButton;
- (void)isCloseTheInputTextView;
- (void)theAnswerIsToVerifyWhether;

@end
