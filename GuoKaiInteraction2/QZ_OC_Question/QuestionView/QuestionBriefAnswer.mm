//
//  QuestionBriefAnswer.m
//  Question
//
//  Created by qanzone on 13-10-11.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionBriefAnswer.h"
#import "PageQuestionBriefAnswer1.h"
#import <QuartzCore/QuartzCore.h>

@implementation QuestionBriefAnswer

@synthesize qBrifeAnswer = _qBrifeAnswer;
@synthesize questionTitleNumber;
@synthesize delegate;

- (void)dealloc
{
    [self.qBrifeAnswer release];
    [self.questionTitleNumber release];
    [titleNumber release];
    [titleContent release];
    [inputAnswerString release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        titleContent = [[UILabel alloc]init];
        titleNumber  = [[UILabel alloc]init];
        isVerifiedAnswer = NO;
        inputAnswerString = [[NSMutableString alloc]initWithString:@""];
    }
    return self;
}

- (void)initQuestionChoiceData:(PageQuestionBriefAnswer *)qBriefAnswerData
{
    self.qBrifeAnswer = [[PageQuestionBriefAnswer1 alloc]init];
    
    [self.qBrifeAnswer setStrQuestion:[NSString stringWithCString:qBriefAnswerData->strQuestion.c_str() encoding:NSUTF8StringEncoding]];
    [self.qBrifeAnswer setStrAnswer:[NSString stringWithCString:qBriefAnswerData->vStrAnswer.c_str() encoding:NSUTF8StringEncoding]];
}

- (void)composition
{
    [self creatquestionTitleNumber];
    [self creatquestionTitleContent];
    [self creatLine];
    [self creatTextView];
}

- (void)creatquestionTitleNumber
{
    titleNumber.numberOfLines = 0;
    titleNumber.text = self.questionTitleNumber;
    titleNumber.font = QUESTION_NUMBER_OF_QUESTIONS_FONT;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:QUESTION_NUMBER_OF_QUESTIONS_FONT constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleNumber.frame = CGRectMake(0, 15, self.frame.size.width, sizeTt.height);
    titleNumber.backgroundColor = [UIColor clearColor];
    [self addSubview:titleNumber];
}

- (void)creatquestionTitleContent
{
    titleContent.backgroundColor = [UIColor clearColor];
    titleContent.numberOfLines = 0;
    titleContent.text = self.qBrifeAnswer.strQuestion;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:QUESTION_TOPIC_FONT constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleContent.frame = CGRectMake(0,titleNumber.frame.size.height + 25, self.frame.size.width, sizeTt.height);
    titleContent.font = QUESTION_TOPIC_FONT;
    [self addSubview:titleContent];
}

- (void)creatLine
{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, titleContent.frame.size.height + titleNumber.frame.size.height +25, self.frame.size.width, 30);
    //    创建一个基于图片的上下文
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, 30));
    //    取出“当前”上下文--也就是在上一句中刚刚创建的上下文
    //    返回值为CGContextRef类型
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //    设置图片中线条的颜色和透明度
    CGContextSetRGBStrokeColor(ctx,0 , 0, 0, 1.0);
    //    设置线条的宽度
    CGContextSetLineWidth(ctx,5);
    
    CGContextMoveToPoint(ctx, 0, view.frame.size.height);
    CGContextAddLineToPoint(ctx,view.frame.size.width, view.frame.size.height );
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/2);
    [view addSubview:imageView];
    [self addSubview:view];
    [view release];
}

- (void)creatTextView
{
    UILabel * inputLabel = [[UILabel alloc]init];
    inputLabel.frame = CGRectMake(0, titleContent.frame.size.height + titleNumber.frame.size.height + 55, self.frame.size.width/2, 30);
    inputLabel.backgroundColor = [UIColor clearColor];
    inputLabel.font = QUESTION_ANSWER_FONT;
    inputLabel.text = @"请输入答案：";
    [self addSubview:inputLabel];
    [inputLabel release];
    
    inputTVFrame = CGRectMake(0,titleContent.frame.size.height + titleNumber.frame.size.height + 55 + 30 +10 , self.frame.size.width, self.frame.size.height - 60 -(titleContent.frame.size.height + titleNumber.frame.size.height + 55));
    
    UITextView *inputTV = [[UITextView alloc]initWithFrame:inputTVFrame];
    inputTV.delegate = self;
    inputTV.layer.borderColor = [UIColor grayColor].CGColor;
    inputTV.layer.borderWidth =1.0;
    inputTV.tag = QUESTION_BRIEFANSWER_TEXTVIEW_TAG;
    inputTV.font = [UIFont systemFontOfSize:35];
    [self addSubview:inputTV];
    [inputTV release];
    
   
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [inputAnswerString setString:textView.text];
   
    
    [self moveOutputBarWithKeyboardDuration:aniDuration];
    
    [self.delegate isToVerifyAnswer];
    return YES;
}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.width withDuration:animationDuration];
}

- (void)moveInputBarWithKeyboardHeight:(CGFloat)keyHeight withDuration:(NSTimeInterval)animationDuration
{
    UITextView *textView = (UITextView *)[self viewWithTag:QUESTION_BRIEFANSWER_TEXTVIEW_TAG];
    [UIView animateWithDuration:animationDuration animations:^{
        CGFloat supHeight = [self.delegate superviewHeight];
        CGFloat supOriginY = [self.delegate superviewOriginY];
        CGFloat distant = supHeight+supOriginY+inputTVFrame.origin.y+inputTVFrame.size.height;
        CGFloat intal = SFSH - 60 -(titleContent.FSH + titleNumber.FSH + 55);
        CGFloat hh = distant - (748-keyHeight);
        textView.frame = CGRectMake(0,titleContent.FSH + titleNumber.FSH + 95 , SFSW, intal - hh);
          }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    aniDuration = animationDuration;
}

- (void)moveOutputBarWithKeyboardDuration:(NSTimeInterval)animationDuration
{
    UITextView *textView = (UITextView *)[self viewWithTag:QUESTION_BRIEFANSWER_TEXTVIEW_TAG];
    [UIView animateWithDuration:animationDuration animations:^{       
        textView.frame = CGRectMake(inputTVFrame.origin.x, inputTVFrame.origin.y, inputTVFrame.size.width, inputTVFrame.size.height);
    }];
 }

#pragma mark - 验证答案
- (void)rightAnswerVerift
{
    isVerifiedAnswer = YES;
    [self inputAnswer];
    [self rightAnswer];
}

- (void)inputAnswer
{
    UITextView *inputTV = (UITextView *)[self viewWithTag:QUESTION_BRIEFANSWER_TEXTVIEW_TAG];
    inputTV.hidden = YES;
    
    UIScrollView * inputSc = [[UIScrollView alloc]initWithFrame:CGRectMake(inputTV.FOX, inputTV.FOY, inputTV.FSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, inputTV.FSH)];
    inputSc.layer.borderColor = [UIColor grayColor].CGColor;
    inputSc.layer.borderWidth = 1.0;
    inputSc.tag = QUESTION_BRIEFANSWER_INPUT_ANSWER_SCV_TAG;
    inputSc.showsHorizontalScrollIndicator = NO;
    inputSc.showsVerticalScrollIndicator = NO;
    
    UILabel *inputLable = [[UILabel alloc]init];
    inputLable.backgroundColor = [UIColor clearColor];
    CGSize sizeTt = [inputTV.text sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    inputLable.frame = CGRectMake(0, 0, inputTV.FSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, sizeTt.height);
    inputLable.text = inputTV.text;
    inputLable.font = QUESTION_ANSWER_FONT;
    inputSc.contentSize = CGSizeMake(SFSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, sizeTt.height);
    inputLable.numberOfLines = 0;
    [inputSc addSubview:inputLable];
    [inputLable release];
    [self addSubview:inputSc];
    [inputSc release];
}

- (void)rightAnswer
{
    UITextView *inputTV = (UITextView *)[self viewWithTag:QUESTION_BRIEFANSWER_TEXTVIEW_TAG];
    //    参考答案区
    UILabel * ansLabel = [[UILabel alloc]init];
    ansLabel.frame = CGRectMake(self.frame.size.width/2+QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, titleContent.FSH + titleNumber.FSH + 55, SFSW/2, 30);
    ansLabel.tag = QUESTION_BRIEFANSWER_ANSWER_TITLELABEL_TAG;
    ansLabel.text = @"参考答案：";
    ansLabel.font = QUESTION_ANSWER_FONT;
    [self addSubview:ansLabel];
    [ansLabel release];
    
    UIScrollView * answerSc = [[UIScrollView alloc]initWithFrame:CGRectMake(inputTV.frame.origin.x+inputTV.frame.size.width/2+QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, inputTV.FOY, inputTV.FSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, inputTV.FSH)];
    answerSc.layer.borderColor = [UIColor grayColor].CGColor;
    answerSc.layer.borderWidth = 1.0;
    answerSc.showsHorizontalScrollIndicator = NO;
    answerSc.showsVerticalScrollIndicator = NO;
    answerSc.tag = QUESTION_BRIEFANSWER_ANSWER_SCV_TAG;
    CGSize sizeAns = [self.qBrifeAnswer.strAnswer sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    answerSc.contentSize = CGSizeMake(SFSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, sizeAns.height);
    
    UILabel *answerLable = [[UILabel alloc]init];
    answerLable.frame = CGRectMake(0, 0, SFSW/2-QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT, sizeAns.height);
    answerLable.backgroundColor = [UIColor clearColor];
    answerLable.text = self.qBrifeAnswer.strAnswer;
    answerLable.font = QUESTION_ANSWER_FONT;
    answerLable.numberOfLines = 0;
    [answerSc addSubview:answerLable];
    [answerLable release];
    [self addSubview:answerSc];
    [answerSc release];
}

- (void)clearAnswerButton
{
    isVerifiedAnswer = NO;
    [inputAnswerString setString:@""];
    [UIView animateWithDuration:0.25 animations:^{
        UITextView *inputTV = (UITextView *)[self viewWithTag:QUESTION_BRIEFANSWER_TEXTVIEW_TAG];
        inputTV.hidden = NO;
        inputTV.text = @"";
        UIScrollView * inputSc = (UIScrollView *)[self viewWithTag:QUESTION_BRIEFANSWER_INPUT_ANSWER_SCV_TAG];
        UIScrollView * answerSc = (UIScrollView *)[self viewWithTag:QUESTION_BRIEFANSWER_ANSWER_SCV_TAG];
        UILabel *answerLabel = (UILabel *)[self viewWithTag:QUESTION_BRIEFANSWER_ANSWER_TITLELABEL_TAG];
        [inputSc removeFromSuperview];
        [answerSc removeFromSuperview];
        [answerLabel removeFromSuperview];
    }];
    [self.delegate isToVerifyAnswer];
}

- (void)theAnswerIsToVerifyWhether
{
    if (isVerifiedAnswer == YES)
    {
        [self.delegate isToEliminateAnswer];
    }else if (isVerifiedAnswer == NO){
        [self.delegate isToVerifyAnswer];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextView *inputTV = (UITextView *)[self viewWithTag:QUESTION_BRIEFANSWER_TEXTVIEW_TAG];
    if (![inputTV isExclusiveTouch])
    {
        [inputTV resignFirstResponder];
    }
}

- (void)isCloseTheInputTextView
{
    UITextView *inputTV = (UITextView *)[self viewWithTag:QUESTION_BRIEFANSWER_TEXTVIEW_TAG];
    [UIView animateWithDuration:aniDuration animations:^{
        inputTV.frame = CGRectMake(inputTVFrame.origin.x, inputTVFrame.origin.y, inputTVFrame.size.width, inputTVFrame.size.height);
        [inputTV resignFirstResponder];
    }];
}


@end
