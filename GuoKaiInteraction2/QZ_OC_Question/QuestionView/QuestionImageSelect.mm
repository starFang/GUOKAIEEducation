//
//  QuestionImageSelect.m
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionImageSelect.h"
#import <QuartzCore/QuartzCore.h>

@implementation QuestionImageSelect

@synthesize delegate;
@synthesize qImageSelect;
@synthesize questionTitleNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isVerifiedAnswer = NO;
        answerNumber = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)initQuestionChoiceData:(PageQuestionImageSelect *)pQuestionImageSelect
{
    self.qImageSelect = [[PageQuestionImageSelect1 alloc]init];
    [self.qImageSelect setStrQuestion:[NSString stringWithCString:pQuestionImageSelect->strQuestion.c_str() encoding:NSUTF8StringEncoding]];
    for (int i = 0; i < pQuestionImageSelect->vStrImage.size(); i++)
    {
        [self.qImageSelect.vStrImage addObject:[NSString stringWithCString:pQuestionImageSelect->vStrImage[i].c_str() encoding:NSUTF8StringEncoding]];
    }
    
    for (int i = 0; i < pQuestionImageSelect->vAnswers.size(); i++)
    {
        [self.qImageSelect.vAnswers addObject:[NSString stringWithFormat:@"%d",pQuestionImageSelect->vAnswers[i]]];
    }

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
    UIFont *fontTt = QUESTION_NUMBER_OF_QUESTIONS_FONT;
    titleNumber.font = fontTt;
    titleNumber.text = self.questionTitleNumber;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:fontTt constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleNumber.frame = CGRectMake(0, 15, SFSW, sizeTt.height);
    [self addSubview:titleNumber];
}

- (void)creatquestionTitleContent
{
    titleContent = [[UILabel alloc]init];
    titleContent.numberOfLines = 0;
    titleContent.backgroundColor = [UIColor clearColor];
    titleContent.text = self.qImageSelect.strQuestion;
    titleContent.textColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
    UIFont *fontTt = QUESTION_TOPIC_FONT;
    CGSize sizeTt = [self.qImageSelect.strQuestion sizeWithFont:fontTt constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleContent.frame = CGRectMake(0,titleNumber.FSH + 25, SFSW, sizeTt.height);
    titleContent.font = fontTt;
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
    //    设置图片中的背景颜色和透明度
    //    CGContextSetRGBFillColor(ctx, 0, 1.0, 1.0, 0.0);
    //    设置图片中线条的颜色和透明度
    CGContextSetRGBStrokeColor(ctx,52.0/255.0 , 52.0/255.0, 52.0/255.0, 1.0);
    //    设置线条的宽度
    CGContextSetLineWidth(ctx,5);
    CGContextMoveToPoint(ctx, 0, view.frame.size.height);
    CGContextAddLineToPoint(ctx,view.frame.size.width, view.frame.size.height );
    CGContextStrokePath(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, view.FSW, view.frame.size.height/2);
    [view addSubview:imageView];
    [imageView release];
    [self addSubview:view];
    [view release];
    
}

- (void)creatAnswerPressButton
{
    for (int i = 0; i < [self.qImageSelect.vStrImage count]; i++)
    {
        UIImage * image = [UIImage imageNamed:[self.qImageSelect.vStrImage objectAtIndex:i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.showsTouchWhenHighlighted = YES;
        button.frame = [self imageLayout:i];
        button.tag = QUESTION_ANSWER_IMAGE_BUTTON_TAG + i;
        button.selected = NO;
        [button addTarget:self action:@selector(pressOne:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(pressTwo:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(pressThree:) forControlEvents:UIControlEventTouchDragOutside];
        //将图层的边框设置为圆脚
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [button.layer setShadowOffset:CGSizeMake(1, 1)];
        [button.layer setShadowRadius:5.0];
        [button.layer setShadowColor:[UIColor blackColor].CGColor];
        [button.layer setShadowOpacity:1.0];
        [self addSubview:button];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ansp.png"]];
        imageView.frame = CGRectMake(0, button.FSH-QUESTION_SMALL_IMAGE_HEIGHT_AND_WIDTH, QUESTION_SMALL_IMAGE_HEIGHT_AND_WIDTH, QUESTION_SMALL_IMAGE_HEIGHT_AND_WIDTH);
        imageView.tag = QUESTION_SMALL_IMAGE_TAG + i;
        [button addSubview:imageView];
        [imageView release];
    }
}

- (void)pressOne:(UIButton *)button
{
    button.transform =  CGAffineTransformMakeScale(0.9,0.9);
}

- (void)pressTwo:(UIButton *)button
{
    for (int i = 0; i < [answerNumber count]; i++)
    {
        if (button.tag == [[answerNumber objectAtIndex:i] intValue])
        {
            [answerNumber removeObjectAtIndex:i];
            break;
        }
    }
    
    if ([self.qImageSelect.vAnswers count] == 1)
    {
        for (int i = 0 ; i < [self.qImageSelect.vStrImage count]; i++)
        {
            UIImageView *imageView = (UIImageView *)[self viewWithTag:i+QUESTION_SMALL_IMAGE_TAG];
            [imageView setImage:[UIImage imageNamed:@"ansp.png"]];
        }
        
    for (int i = 0; i < [self.qImageSelect.vStrImage count]; i++)
        {
            UIButton *but = (UIButton *)[self viewWithTag:QUESTION_ANSWER_IMAGE_BUTTON_TAG+i];
            
            if (but.tag != button.tag)
            {
                but.selected = NO;
            }
        }
        
        button.selected = !button.selected;
        [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]];
        if (button.selected == YES)
        {
            UIImageView *imageView = (UIImageView *)[self viewWithTag:button.tag-QUESTION_ANSWER_IMAGE_BUTTON_TAG+QUESTION_SMALL_IMAGE_TAG];
            [imageView setImage:[UIImage imageNamed:@"g_selected@2x.png"]];
        }
        
    }else if ([self.qImageSelect.vAnswers count] != 1)
    {
        button.selected = !button.selected;
        if (button.selected)
        {
            [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]];
        }
        
        if (button.selected == YES)
        {
            UIImageView *imageView = (UIImageView *)[button.subviews lastObject];
            [imageView setImage:[UIImage imageNamed:@"g_selected@2x.png"]];
        }else{
            UIImageView *imageView = (UIImageView *)[button.subviews lastObject];
            [imageView setImage:[UIImage imageNamed:@"ansp.png"]];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        button.transform =  CGAffineTransformMakeScale(1.0,1.0);
    }];
    
    if ([answerNumber count] != 0)
    {
        [self.delegate isToVerifyAnswer];
    }else{
        [self.delegate isReadyVerifiedAnswers];
    }
    
}

- (void)pressThree:(UIButton *)button
{
    for (int i = 0; i < [answerNumber count]; i++)
    {
        if (button.tag == [[answerNumber objectAtIndex:i] intValue])
        {
            [answerNumber removeObjectAtIndex:i];
            break;
        }
    }
    
    if ([self.qImageSelect.vAnswers count] == 1)
    {
        for (int i = 0 ; i < [self.qImageSelect.vStrImage count]; i++)
        {
            UIImageView *imageView = (UIImageView *)[self viewWithTag:i+QUESTION_SMALL_IMAGE_TAG];
            [imageView setImage:[UIImage imageNamed:@"ansp.png"]];
        }
        
        for (int i = 0; i < [self.qImageSelect.vStrImage count]; i++)
        {
            UIButton *but = (UIButton *)[self viewWithTag:QUESTION_ANSWER_IMAGE_BUTTON_TAG+i];
            
            if (but.tag != button.tag)
            {
                but.selected = NO;
            }
        }
        
        button.selected = !button.selected;
        [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]];
        if (button.selected == YES)
        {
            UIImageView *imageView = (UIImageView *)[self viewWithTag:button.tag-QUESTION_ANSWER_IMAGE_BUTTON_TAG+QUESTION_SMALL_IMAGE_TAG];
            [imageView setImage:[UIImage imageNamed:@"g_selected@2x.png"]];
        }
        
    }else if ([self.qImageSelect.vAnswers count] != 1)
    {
        button.selected = !button.selected;
        if (button.selected)
        {
            [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]];
        }
        
        if (button.selected == YES)
        {
            UIImageView *imageView = (UIImageView *)[button.subviews lastObject];
            [imageView setImage:[UIImage imageNamed:@"g_selected@2x.png"]];
        }else{
            UIImageView *imageView = (UIImageView *)[button.subviews lastObject];
            [imageView setImage:[UIImage imageNamed:@"ansp.png"]];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        button.transform =  CGAffineTransformMakeScale(1.0,1.0);
    }];
    
    if ([answerNumber count] != 0)
    {
        [self.delegate isToVerifyAnswer];
    }else{
        [self.delegate isReadyVerifiedAnswers];
    }
    
}

#pragma  mark - 专门用来计算图片布局的
- (CGRect)imageLayout:(int)i
{ 
    CGRect frame;
    if ([self.qImageSelect.vStrImage count] == 2) {
        
        frame = CGRectMake(
            ((SFSW-10)/2+10)*i,
            (titleContent.FSH + titleNumber.FSH + 55),
            (SFSW-10)/2,
            SFSH -(titleContent.FSH + titleNumber.FSH + 75)
                           );
        
    }else if ([self.qImageSelect.vStrImage count] == 3){
        
        if (i < 2) {
            frame = CGRectMake(
                               ((SFSW-10)/2+10)*i,
                               (titleContent.FSH + titleNumber.FSH + 55),
                               (SFSW-10)/2,
                               ((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2
                               );
        }else{
            frame = CGRectMake(
                               (SFSW-10)/4,
                               ((titleContent.FSH + titleNumber.FSH + 55) + (((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2 + 10)*i/2),
                               (SFSW-10)/2,
                               ((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2
                               );
        }
        
    
    }else if ([self.qImageSelect.vStrImage count] == 4){
        frame = CGRectMake(
                           ((SFSW-10)/2+10)*(i%2),
                           ((titleContent.FSH + titleNumber.FSH + 55) + ((SFSH -(titleContent.FSH + titleNumber.FSH + 65))/2)*(i/2)),
                           (SFSW-10)/2,
                           ((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2
                           );
    
    }else if ([self.qImageSelect.vStrImage count] == 5){
        
        if (i < 3) {
            frame = CGRectMake(
                               ((SFSW-20)/3+10)*(i%3),
                               ((titleContent.FSH + titleNumber.FSH + 55) + (((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2 + 10)*(i/3)),
                               (SFSW-20)/3,
                               ((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2
                               );
        }else{
            frame = CGRectMake(
                              (SFSW-20)/6 +((SFSW-20)/3+10)*(i%3),
                               ((titleContent.FSH + titleNumber.FSH + 55) + (((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2 + 10)*(i/3)),
                               (SFSW-20)/3,
                               ((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2
                               );
        }
    }else if ([self.qImageSelect.vStrImage count] == 6){
        
    frame = CGRectMake(
    ((SFSW-20)/3+10)*(i%3),
    ((titleContent.FSH + titleNumber.FSH + 55) + (((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2 + 10) * (i/3)),
    (SFSW-20)/3,
    ((SFSH -(titleContent.FSH + titleNumber.FSH + 75)) - 10)/2
                         );
     }
    
    return frame;
}

- (void)rightAnswerVerift
{
    isVerifiedAnswer = YES;
    if ([self.qImageSelect.vAnswers count] == 1)
    {
        if ([[self.qImageSelect.vAnswers lastObject] intValue] == [[answerNumber lastObject]intValue] - QUESTION_ANSWER_IMAGE_BUTTON_TAG)
        {
            UIImageView * imageView = (UIImageView *)[self viewWithTag:[[answerNumber lastObject]intValue] - QUESTION_ANSWER_IMAGE_BUTTON_TAG + QUESTION_SMALL_IMAGE_TAG ];
            [imageView setImage:[UIImage imageNamed:@"yes.png"]];
        }else{
            UIImageView * imageView = (UIImageView *)[self viewWithTag:[[answerNumber lastObject]intValue] - QUESTION_ANSWER_IMAGE_BUTTON_TAG + QUESTION_SMALL_IMAGE_TAG ];
            [imageView setImage:[UIImage imageNamed:@"no.png"]];
        }
     }else if ([self.qImageSelect.vAnswers count] != 1)
     {
         
    for (int i = 0; i < [answerNumber count]; i++)
        {
            UIButton *button = (UIButton *)[self viewWithTag:[[answerNumber objectAtIndex:i]intValue]];
            [(UIImageView *)[button.subviews lastObject]setImage:[UIImage imageNamed:@"no.png"]];
            for (int j = 0; j < [self.qImageSelect.vAnswers count]; j++)
            {
                NSInteger a1 = [[self.qImageSelect.vAnswers objectAtIndex:j]intValue];
                NSInteger a2 = [[answerNumber objectAtIndex:i]intValue] - QUESTION_ANSWER_IMAGE_BUTTON_TAG;
                
            if (a1 == a2 )
                {
                    [(UIImageView *)[button.subviews lastObject]setImage:[UIImage imageNamed:@"yes.png"]];
                    break;
                }
            }
        }
    }
    
    for (int i = 0; i < [self.qImageSelect.vStrImage count]; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:QUESTION_ANSWER_IMAGE_BUTTON_TAG + i];
        button.userInteractionEnabled = NO;
    }
 }

- (void)clearAnswerButton
{
    isVerifiedAnswer = NO;
    [answerNumber removeAllObjects];
    for (int i = 0; i < [self.qImageSelect.vStrImage count]; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:QUESTION_ANSWER_IMAGE_BUTTON_TAG + i];
        button.userInteractionEnabled = YES;
        button.selected = NO;
        UIImageView *imageView = (UIImageView *)[button.subviews lastObject];
        [imageView setImage:[UIImage imageNamed:@"ansp.png"]];
    }
    [self.delegate isReadyVerifiedAnswers];
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

- (void)isCloseTheInputTextView
{
    for (int i = 0; i < [self.qImageSelect.vStrImage count]; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:QUESTION_ANSWER_IMAGE_BUTTON_TAG+i];
        [UIView animateWithDuration:0.25 animations:^{
            button.transform =  CGAffineTransformMakeScale(1.0,1.0);
        }];
    }
}

- (void)dealloc
{
    [self.qImageSelect release];
    self.qImageSelect = nil;
    [titleContent release];
    [titleNumber release];
    [super dealloc];
}

@end
