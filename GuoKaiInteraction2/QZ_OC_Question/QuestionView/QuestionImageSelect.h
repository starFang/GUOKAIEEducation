//
//  QuestionImageSelect.h
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageQuestionImageSelect1.h"
#include "QZEpubPageObjs.h"
@protocol QISelectArVerifyDelegate <NSObject>

- (void)isToVerifyAnswer;
- (void)isReadyVerifiedAnswers;
- (void)isToEliminateAnswer;

@end

@interface QuestionImageSelect : UIView<QISelectArVerifyDelegate>
{
    id<QISelectArVerifyDelegate>delegate;
    PageQuestionImageSelect1 *qImageSelect;
    
    UILabel *titleNumber;
    UILabel *titleContent;
    
    //    用来记录答案的个数
    NSMutableArray *answerNumber;
    //    用来记录是否验证答案
    BOOL isVerifiedAnswer;
    
}
@property (nonatomic, assign)id<QISelectArVerifyDelegate>delegate;
@property (nonatomic, retain)PageQuestionImageSelect1 *qImageSelect;
@property (nonatomic, copy) NSString *questionTitleNumber;

- (void)initQuestionChoiceData:(PageQuestionImageSelect *)pQuestionImageSelect;
- (void)composition;

- (void)isCloseTheInputTextView;
- (void)rightAnswerVerift;
- (void)clearAnswerButton;
- (void)theAnswerIsToVerifyWhether;

@end
