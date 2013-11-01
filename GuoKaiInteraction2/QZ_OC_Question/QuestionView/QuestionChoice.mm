//
//  QuestionChoice.m
//  Question
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionChoice.h"

@implementation QuestionChoice

@synthesize qChoice;
@synthesize questionTitleNumber = _questionTitleNumber;
@synthesize delegate;

- (void)dealloc
{
    [self.questionTitleNumber release];
    [self.questionTitleNumber release];
    [titleNumber release];
    [titleContent release];
    [qChoice release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        answerNumber = [[NSMutableArray alloc]init];
        isVerifiedAnswer = NO;
    }
    return self;
}

- (void)initQuestionChoiceData:(PageQuestionChoice *)qChoiceData
{
    qChoice = [[PageQuestionChoice1 alloc]init];
    [qChoice setStrQuestion:[NSString stringWithCString:qChoiceData->strQuestion.c_str() encoding:NSUTF8StringEncoding]];
    NSMutableArray *array = [NSMutableArray array];
    for (int j = 0 ; j < qChoiceData->vChoices.size(); j++)
    {
        [array addObject:[NSString stringWithCString:qChoiceData->vChoices[j].c_str() encoding:NSUTF8StringEncoding]];
    }
    [qChoice setVChoices:array];
    NSMutableArray * arrayAnswer =[NSMutableArray array];
    for (int j = 0; j < qChoiceData->vAnswer.size(); j++)
    {
        NSString *strAns = [NSString stringWithFormat:@"%d",qChoiceData->vAnswer[j]];
        [arrayAnswer addObject:strAns];
    }
    [qChoice setVAnswer:arrayAnswer];

}
- (void)composition
{
    [self creatquestionTitleNumber];
    [self creatquestionTitleContent];
    [self creatLine];
    [self creatAnswerPressButton];
}

- (void)creatquestionTitleNumber
{
    titleNumber = [[UILabel alloc]init];
    titleNumber.backgroundColor = [UIColor clearColor];
    titleNumber.numberOfLines = 0;
    titleNumber.font = QUESTION_NUMBER_OF_QUESTIONS_FONT;
    titleNumber.text = self.questionTitleNumber;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:QUESTION_NUMBER_OF_QUESTIONS_FONT constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleNumber.frame = CGRectMake(0, 15, SFSW, sizeTt.height);
    [self addSubview:titleNumber];
}

- (void)creatquestionTitleContent
{
    titleContent = [[UILabel alloc]init];
    titleContent.numberOfLines = 0;
    titleContent.backgroundColor = [UIColor clearColor];
    titleContent.text = self.qChoice.strQuestion;
    CGSize sizeTt = [self.qChoice.strQuestion sizeWithFont:QUESTION_TOPIC_FONT constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleContent.frame = CGRectMake(0,titleNumber.FSH + 25, SFSW, sizeTt.height);
    titleContent.font = QUESTION_TOPIC_FONT;
    [self addSubview:titleContent];
}

- (void)creatLine
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, titleContent.FSH + titleNumber.FSH +25, SFSW, 30);
    //    创建一个基于图片的上下文
    UIGraphicsBeginImageContext(CGSizeMake(SFSW, 30));
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

- (void)creatAnswerPressButton
{
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"ansp.png"] forState:UIControlStateNormal];
        button.tag = QUESTION_ANSWER_BUTTON_CHOICE_TAG + i;
        button.showsTouchWhenHighlighted = YES;
        NSString *title = [NSString stringWithFormat:@"%c. %@",65+i,[self.qChoice.vChoices objectAtIndex:i]];
        button.titleLabel.font = QUESTION_ANSWER_FONT;
        button.titleLabel.numberOfLines = 0;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGSize sizeTt = [title sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        button.frame = CGRectMake(0, (titleContent.FSH + titleNumber.FSH + 55 + SFSH)/2 - ((20+sizeTt.height)*[self.qChoice.vChoices count] - 20)/2 + (20+sizeTt.height)*i, SFSW, sizeTt.height);
        
        [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateSelected];
        
        [self addSubview:button];
    }
}

- (void)pressButton:(UIButton *)button
{
    for (int i = 0; i < [answerNumber count]; i++)
    {
        if (button.tag == [[answerNumber objectAtIndex:i] intValue])
        {
            [answerNumber removeObjectAtIndex:i];
            break;
        }
    }
    
    if ([self.qChoice.vAnswer count] == 1)
    {
        for (int i = 0; i < [self.qChoice.vChoices count]; i++)
        {
            UIButton *but = (UIButton *)[self viewWithTag:QUESTION_ANSWER_BUTTON_CHOICE_TAG+i];
            if (but.tag != button.tag)
            {
              but.selected = NO;  
            }
        }
         button.selected = !button.selected;
        [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]];
    }else if ([self.qChoice.vAnswer count] != 1)
    {
        button.selected = !button.selected;
        
        [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]];
    }
    [self.delegate isToVerifyAnswer];
}

- (void)rightAnswerVerift
{
    isVerifiedAnswer = YES;
    if ([self.qChoice.vAnswer count] == 1)
    {
        for (int i = 0; i < [self.qChoice.vChoices count]; i++)
        {
            UIButton *but = (UIButton *)[self viewWithTag:QUESTION_ANSWER_BUTTON_CHOICE_TAG+i];
            but.userInteractionEnabled = NO;
            
            if ([[self.qChoice.vAnswer lastObject]intValue] == i && but.selected == YES)
            {
                [but setBackgroundImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
            }else if (but.selected == YES && [[self.qChoice.vAnswer lastObject]intValue] != i )
            {
                [but setBackgroundImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
            }
        }
        
    }else if ([self.qChoice.vAnswer count] != 1){

        for (int i = 0; i < [self.qChoice.vChoices count]; i++)
        {
            UIButton *but = (UIButton *)[self viewWithTag:QUESTION_ANSWER_BUTTON_CHOICE_TAG+i];
            but.userInteractionEnabled = NO;
            
        for (int j = 0; j < [self.qChoice.vAnswer count]; j++)
            {
                if (but.selected == YES)
                {
            if(i != [[self.qChoice.vAnswer objectAtIndex:j]intValue])
                   {
            [but setBackgroundImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
                   }else{
            [but setBackgroundImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
                    break;
                }}}}}
}

- (void)clearAnswerButton
{
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        UIButton *but = (UIButton *)[self viewWithTag:QUESTION_ANSWER_BUTTON_CHOICE_TAG+i];
        but.userInteractionEnabled = YES;
        but.selected = NO;
        [but setBackgroundImage:[UIImage imageNamed:@"backlab.png"] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"ansp.png"] forState:UIControlStateNormal];
    }
    isVerifiedAnswer = NO;
    [answerNumber removeAllObjects];
    [self.delegate isReadyVerifiedAnswers];
}

- (void)isCloseTheInputTextView
{

}

- (void)theAnswerIsToVerifyWhether
{
    if (isVerifiedAnswer == YES && [answerNumber count] > 0)
    {
        [self.delegate isToEliminateAnswer];
    }else if (isVerifiedAnswer == NO && [answerNumber count] > 0)
    {
        [self.delegate isToVerifyAnswer];
        
    }else if (isVerifiedAnswer == NO && [answerNumber count] == 0)
    {
        [self.delegate isReadyVerifiedAnswers];
    }
}


@end
