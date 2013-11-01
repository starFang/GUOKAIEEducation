//
//  QuestionFillBlank.m
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionFillBlank.h"
#import "PageQuestionFillBlankItem1.h"
#import <QuartzCore/QuartzCore.h>

@implementation QuestionFillBlank

@synthesize delegate;
@synthesize qFillBlank;
@synthesize questionTitleNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isVerifiedAnswer = NO;
        
    }
    return self;
}
- (void)initQuestionChoiceData:(PageQuestionFillBlank *)pQuestionFillBlank
{
self.qFillBlank = [[PageQuestionFillBlank1 alloc]init];
for (int i = 0; i < pQuestionFillBlank->vDescription.size(); i++)
    {
        PageQuestionFillBlankItem1 *qFBI = [[PageQuestionFillBlankItem1 alloc]init];
        [qFBI setIsAnswer:pQuestionFillBlank->vDescription[i].isAnswer];
        [qFBI setStrText:[NSString stringWithCString:pQuestionFillBlank->vDescription[i].strText.c_str() encoding:NSUTF8StringEncoding]];
        [self.qFillBlank.vDescription addObject:qFBI];
        [qFBI release];
    }
    
}

- (void)creatquestionTitleNumber
{
    titleNumber = [[UILabel alloc]init];
    titleNumber.numberOfLines = 0;
    titleNumber.text = self.questionTitleNumber;
    UIFont *fontTt = QUESTION_NUMBER_OF_QUESTIONS_FONT;
    titleNumber.font = fontTt;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:fontTt constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleNumber.frame = CGRectMake(0, 15, SFSW, sizeTt.height);
    titleNumber.backgroundColor = [UIColor clearColor];
    [self addSubview:titleNumber];

}

- (void)composition
{
    [self creatquestionTitleNumber];
    [self creatquestionTitleContent];
    [self creatLine];
    [self creatContent];
}

- (void)creatquestionTitleContent
{
    titleContent = [[UILabel alloc]init];
    titleContent.numberOfLines = 0;
    NSMutableString *qContent = [[NSMutableString alloc]init];
    [qContent setString:@""];
    NSInteger index = 1;
    UIFont *font = QUESTION_TOPIC_FONT;
    CGSize sizeTt;
    for (int i = 0; i < [self.qFillBlank.vDescription count]; i++)
    {
        PageQuestionFillBlankItem1 * pqfbi = [self.qFillBlank.vDescription objectAtIndex:i];
        if (pqfbi.isAnswer == YES)
            {
             NSString * underLine = 
                [NSString stringWithFormat:@"_____(%d)_____",index++];
                [qContent appendString:underLine];
            }else{
            [qContent appendString:pqfbi.strText];
            }
    }
    sizeTt = [qContent sizeWithFont:font constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleContent.text = qContent;
    titleContent.font = font;
    titleContent.backgroundColor = [UIColor clearColor];
    titleContent.frame = CGRectMake(0, titleNumber.FSH + 25, sizeTt.width, sizeTt.height);
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

- (void)creatContent
{
    [self creatInputLabel];
    [self createRightAnswerArray];
    [self createInputSCFrame];
    [self creatinputSCV];
}
- (void)creatInputLabel
{
    UILabel * inputLabel = [[UILabel alloc]init];
    inputLabel.frame = CGRectMake(0, titleContent.FSH + titleNumber.FSH + 55, self.FSW/2, 30);
    inputLabel.tag = QUESTION_FILLBLANK_INPUT_LABEL_TAG;
    inputLabel.backgroundColor = [UIColor clearColor];
    UIFont *fontTt = QUESTION_ANSWER_FONT;
    inputLabel.font = fontTt;
    inputLabel.text = @"请输入答案：";
    [self addSubview:inputLabel];
    [inputLabel release];
}

- (void)createRightAnswerArray
{
    rightAnswerArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self.qFillBlank.vDescription count]; i++)
    {
        PageQuestionFillBlankItem1 * pqfbi = [self.qFillBlank.vDescription objectAtIndex:i];
        if (pqfbi.isAnswer == YES)
        {
            [rightAnswerArray addObject:[NSString stringWithFormat:@"正确答案：%@",pqfbi.strText]];
        }
    }
    countOfAnswer = [rightAnswerArray count];
}

- (void) createInputSCFrame
{
    CGRect inputTVFrame ;
    if (45*(countOfAnswer-1)+25 > SFSH - 60 -(titleContent.FSH + titleNumber.FSH + 55))
    {
        inputTVFrame  = CGRectMake(0,titleContent.FSH + titleNumber.FSH + 55 + 30 +10 , SFSW, SFSH - 60 -(titleContent.FSH + titleNumber.FSH + 55));
    }else{
        inputTVFrame  = CGRectMake(0,titleContent.FSH + titleNumber.FSH + 55 + 30 +10+((SFSH - 60 -(titleContent.FSH + titleNumber.FSH + 55))-(45*(countOfAnswer-1)+25.0))/2 , SFSW, 45.0*(countOfAnswer-1)+25);
    }
    inputSCFrame = inputTVFrame;
}

- (void)creatNumberOfInput:(NSInteger)number
{
    UIScrollView *inputSC = (UIScrollView *)[self viewWithTag:QUESTION_FILLBLANK_INPUTSCV_TAG];
    NSString * indexStr = [NSString stringWithFormat:@"(%d).  ",number];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(15,45*(number-1) , 60, 25);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = QUESTION_ANSWER_FONT;
    label.text = indexStr;
    label.backgroundColor = [UIColor clearColor];
    [inputSC addSubview:label];
    [label release];
    
    CGRect inputTVFrame = CGRectMake(75,45*(number-1) , SFSW-90, 25);
    UITextView *inputTV = [[UITextView alloc]initWithFrame:inputTVFrame];
    inputTV.layer.borderColor = [UIColor grayColor].CGColor;
    inputTV.delegate = self;
    inputTV.layer.borderWidth =1.0;
    inputTV.tag = QUESTION_FILLBLANK_INPUT_ANSWER_SCV_TAG + number;
    inputTV.font = QUESTION_ANSWER_FONT;
    inputTV.pagingEnabled = YES;
    inputTV.showsHorizontalScrollIndicator = NO;
    inputTV.showsVerticalScrollIndicator = NO;
    [inputSC addSubview:inputTV];
    [inputTV release];
}

- (void)creatinputSCV
{
    UIScrollView *inputSC = [[UIScrollView alloc]init];
    inputSC.frame = inputSCFrame;
    inputSC.contentSize = CGSizeMake(SFSW, 45.0*(countOfAnswer-1)+25);
    inputSC.tag = QUESTION_FILLBLANK_INPUTSCV_TAG;
    inputSC.showsHorizontalScrollIndicator = NO;
    inputSC.showsVerticalScrollIndicator = NO;
    [self addSubview:inputSC];
    [inputSC release];
    
    NSInteger index = 1;
    for (int i = 0; i < [self.qFillBlank.vDescription count]; i++)
    {
        PageQuestionFillBlankItem1 * pqfbi = [self.qFillBlank.vDescription objectAtIndex:i];
        if (pqfbi.isAnswer == YES)
        {
            [self creatNumberOfInput:index];
            index++;
        }
    }
}




-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.width  withDuration:animationDuration];
}

- (void)moveInputBarWithKeyboardHeight:(CGFloat)keyHeight withDuration:(NSTimeInterval)animationDuration
{
    UIScrollView *scV = (UIScrollView *)[self viewWithTag:QUESTION_FILLBLANK_INPUTSCV_TAG];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGFloat supHeight = [self.delegate superviewHeight];
        CGFloat supOriginY = [self.delegate superviewOriginY];
        CGFloat distant = supHeight+supOriginY+inputSCFrame.origin.y + inputSCFrame.size.height;
        CGFloat intal = SFSH - 60 -(titleContent.FSH + titleNumber.FSH + 55);
        CGFloat hh = distant - (748-keyHeight);
        scV.frame = CGRectMake(0,titleContent.FSH + titleNumber.FSH + 95 , SFSW, intal - hh -75);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    aniDuration = animationDuration;
    [self moveOutputBarWithKeyboardDuration:aniDuration];
}

- (void)moveOutputBarWithKeyboardDuration:(NSTimeInterval)animationDuration
{
    UIScrollView *scV = (UIScrollView *)[self viewWithTag:QUESTION_FILLBLANK_INPUTSCV_TAG];
    [UIView animateWithDuration:animationDuration animations:^{
scV.frame = CGRectMake(inputSCFrame.origin.x, inputSCFrame.origin.y, inputSCFrame.size.width, inputSCFrame.size.height);
    }];
}

- (void)dealloc
{
    [self.qFillBlank release];
    self.qFillBlank = nil;
    [inputAnswerArray release];
    [rightAnswerArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)rightAnswerVerift
{
    isVerifiedAnswer = YES;
    inputAnswerArray = [[NSMutableArray alloc]init];
    UIScrollView *scV = (UIScrollView *)[self viewWithTag:QUESTION_FILLBLANK_INPUTSCV_TAG];
     scV.hidden = YES;
        for (int i = 1; i <= countOfAnswer; i++)
        {
            UITextView *inputTV = (UITextView *)[scV viewWithTag:QUESTION_FILLBLANK_INPUT_ANSWER_SCV_TAG+i];
            [inputAnswerArray addObject:[NSString stringWithFormat:@"%d. %@",i,inputTV.text]];
         }
   
    UILabel * inputLabel = (UILabel *)[self viewWithTag:QUESTION_FILLBLANK_INPUT_LABEL_TAG];
    inputLabel.text = @"验证结果: ";
    UIScrollView *answerSC = [[UIScrollView alloc]init];
    answerSC.tag = QUESTION_FILLBLANK_ANSWER_SCV_TAG;
    for (int i = 0; i < countOfAnswer; i++)
    {
        UILabel * label1 = [[UILabel alloc]init];
        UILabel * label2 = [[UILabel alloc]init];
        label1.text = [inputAnswerArray objectAtIndex:i];
        label2.text = [rightAnswerArray objectAtIndex:i];
        label1.frame = CGRectMake(30,70*i , SFSW-60, 25);
        label2.frame = CGRectMake(30,25+ 70*i ,SFSW-60, 25);
        label1.font = QUESTION_ANSWER_FONT;
        label2.font = QUESTION_ANSWER_FONT;
        label2.backgroundColor = [UIColor clearColor];
        label1.backgroundColor = [UIColor clearColor];
        [answerSC addSubview:label1];
        [answerSC addSubview:label2];
        [label1 release];
        [label2 release];
    }
    
    answerSC.frame = CGRectMake(0,titleContent.FSH + titleNumber.FSH + 55 + 30 +10 , SFSW, SFSH - 60 -(titleContent.FSH + titleNumber.FSH + 55));
    answerSC.contentSize = CGSizeMake(SFSW,80*(countOfAnswer-1)+60);
    answerSC.tag = QUESTION_FILLBLANK_ANSWER_SCV_TAG;
    answerSC.showsHorizontalScrollIndicator = NO;
    answerSC.showsVerticalScrollIndicator = NO;
    [self addSubview:answerSC];
    [answerSC release];
    
}

- (void)clearAnswerButton
{
    isVerifiedAnswer = NO;
    
    UILabel * inputLabel = (UILabel *)[self viewWithTag:QUESTION_FILLBLANK_INPUT_LABEL_TAG];
    inputLabel.text = @"请输入答案：";
    UIScrollView *answerSCV = (UIScrollView *)[self viewWithTag:QUESTION_FILLBLANK_ANSWER_SCV_TAG];
    [answerSCV removeFromSuperview];
    [inputAnswerArray removeAllObjects];
   UIScrollView *scV = (UIScrollView *)[self viewWithTag:QUESTION_FILLBLANK_INPUTSCV_TAG];
    scV.hidden = NO;
    for (int i = 1; i <= countOfAnswer; i++)
    {
        UITextView *inputTV = (UITextView *)[scV viewWithTag:QUESTION_FILLBLANK_INPUT_ANSWER_SCV_TAG+i];
        inputTV.text = @"";
    }
    [self.delegate isToVerifyAnswer];
}

- (void)isCloseTheInputTextView
{
    UIScrollView *scV = (UIScrollView *)[self viewWithTag:QUESTION_FILLBLANK_INPUTSCV_TAG];
    [UIView animateWithDuration:aniDuration animations:^{
        scV.frame = CGRectMake(inputSCFrame.origin.x, inputSCFrame.origin.y, inputSCFrame.size.width, inputSCFrame.size.height);
        for (int i = 0; i <= countOfAnswer; i++)
        {
            UITextView *inputTV = (UITextView *)[scV viewWithTag:QUESTION_FILLBLANK_INPUT_ANSWER_SCV_TAG+i];
            [inputTV resignFirstResponder];
         }
    }];
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
    
    
    
   
}

@end
