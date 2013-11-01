//
//  QuestionLine.m
//  Question
//
//  Created by qanzone on 13-10-9.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionLine.h"
#import <QuartzCore/QuartzCore.h>

@implementation QuestionLine

@synthesize delegate;
@synthesize questionTitleNumber = _questionTitleNumber;

@synthesize qConnection;
- (void)dealloc
{
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isVerifiedAnswer = NO;
        
        pointToPointArray = [[NSMutableArray alloc]init];
        theCorrectPointAnswerArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)initQuestionChoiceData:(PageQuestionConnection *)pQuestionC
{
    self.qConnection = [[PageQuestionConnection1 alloc]init];
    [self.qConnection setStrQuestion:[NSString stringWithCString:pQuestionC->strQuestion.c_str() encoding:NSUTF8StringEncoding]];
    for (int i = 0; i < pQuestionC->vLeftSide.size(); i++)
    {
        NSString *strLeft = [NSString stringWithCString:pQuestionC->vLeftSide[i].c_str() encoding:NSUTF8StringEncoding];
        [self.qConnection.vLeftSide addObject:strLeft];
    }
for (int i = 0; i < pQuestionC->vRightSide.size(); i++)
    {
        NSString *strRight = [NSString stringWithCString:pQuestionC->vRightSide[i].c_str() encoding:NSUTF8StringEncoding];
        [self.qConnection.vRightSide addObject:strRight];
    }
    for (int i = 0; i < pQuestionC->vAnswers.size(); i++)
    {
        [self.qConnection.vAnswers addObject:[NSString stringWithFormat:@"%d",pQuestionC->vAnswers[i]]];
    }
}

- (void)composition
{
    [self creatquestionTitleNumber];
    [self creatquestionTitleContent];
    [self creatLine];
    [self creatAnswer];
}

- (void)creatquestionTitleNumber
{
    titleNumber = [[UILabel alloc]init];
    titleNumber.numberOfLines = 0;
    titleNumber.text = self.questionTitleNumber;
    UIFont *fontTt = QUESTION_NUMBER_OF_QUESTIONS_FONT;
    titleNumber.font = fontTt;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:fontTt constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleNumber.frame = CGRectMake(0, 15, self.frame.size.width, sizeTt.height);
    titleNumber.backgroundColor = [UIColor clearColor];
    [self addSubview:titleNumber];
}
- (void)creatquestionTitleContent
{
    titleContent = [[UILabel alloc]init];
    titleContent.backgroundColor = [UIColor clearColor];
    titleContent.numberOfLines = 0;
    titleContent.text = self.qConnection.strQuestion;
    UIFont *fontTt = QUESTION_TOPIC_FONT;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:fontTt constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleContent.frame = CGRectMake(0,titleNumber.frame.size.height + 25, self.frame.size.width, sizeTt.height);
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

- (void)creatAnswer
{
    for (int i = 0; i < [self.qConnection.vLeftSide count]; i++)
    {
        UILabel * la = [[UILabel alloc]init];
        la.numberOfLines = 0;
        la.textAlignment = NSTextAlignmentCenter;
        NSString *answer = [NSString stringWithFormat:@"%c. %@",65+i,[self.qConnection.vLeftSide objectAtIndex:i]];
        UIFont *fontTt = QUESTION_ANSWER_FONT;
        CGSize sizeTt = [answer sizeWithFont:fontTt constrainedToSize:CGSizeMake(self.frame.size.width/3, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        
        la.frame = CGRectMake(0, (titleContent.frame.size.height + titleNumber.frame.size.height + 55 + self.frame.size.height)/2 - ((20+sizeTt.height)*[self.qConnection.vLeftSide count] - 20)/2 + (20+sizeTt.height)*i, self.frame.size.width/3, sizeTt.height);
        la.font = fontTt;
        la.text = answer;
        [self addSubview:la];
        [la release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = QUESTION_LINE_LEFT_BUTTON_TAG + i;
        button.frame = CGRectMake(SFSW/3, (titleContent.FSH + titleNumber.FSH + 55 + SFSH)/2 - ((20+sizeTt.height)*[self.qConnection.vLeftSide count] - 20)/2 + (20+sizeTt.height)*i, sizeTt.height*2, sizeTt.height);
        [button setImage:[UIImage imageNamed:@"ansp.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressLine1Point:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    for (int i = 0; i < [self.qConnection.vRightSide count]; i++)
    {
        UILabel * la = [[UILabel alloc]init];
        la.numberOfLines = 0;
        la.textAlignment = NSTextAlignmentCenter;
        NSString *answer = [NSString stringWithFormat:@"%c. %@",65+i,[self.qConnection.vRightSide objectAtIndex:i]];
        CGSize sizeTt = [answer sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW/3, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        la.font = QUESTION_ANSWER_FONT;
        la.frame = CGRectMake(SFSW*2/3, (titleContent.FSH + titleNumber.FSH + 55 + SFSH)/2 - ((20+sizeTt.height)*[self.qConnection.vLeftSide count] - 20)/2 + (20+sizeTt.height)*i, SFSW/3, sizeTt.height);
        la.text = answer;
        [self addSubview:la];
        [la release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = QUESTION_LINE_RIGHT_BUTTON_TAG + i;
        button.frame = CGRectMake(self.frame.size.width*2/3 - sizeTt.height, (titleContent.FSH + titleNumber.FSH + 55 + SFSH)/2 - ((20+sizeTt.height)*[self.qConnection.vLeftSide count] - 20)/2 + (20+sizeTt.height)*i, sizeTt.height*2, sizeTt.height);
        [button setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressLine2Point:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}


- (void)pressLine1Point:(UIButton *)button
{
    p1=button.center;
}

- (void)pressLine2Point:(UIButton *)button
{
    p2=button.center;
    if (p1.x != 0 && p2.x != 0)
    {
        [self closeTheButtonWithLeftAndRight];
        NSMutableArray * array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithFloat:p1.x]];
        [array addObject:[NSNumber numberWithFloat:p1.y]];
        [array addObject:[NSNumber numberWithFloat:p2.x]];
        [array addObject:[NSNumber numberWithFloat:p2.y]];
        [pointToPointArray addObject:array];
        [self theCorrectPointAnswer:p1];
        [self leftLineRightPoint];
        p1 = CGPointMake(0, 0);
        p2 = CGPointMake(0, 0);
     }

    if ([pointToPointArray count] == [self.qConnection.vLeftSide count])
    {
        [self.delegate isToVerifyAnswer];
        for (int i = 0; i < [pointToPointArray count]; i++)
        {
            UIButton *buttonLeft = (UIButton *)[self viewWithTag:QUESTION_LINE_LEFT_BUTTON_TAG + i];
            UIButton *buttonRight = (UIButton *)[self viewWithTag:QUESTION_LINE_RIGHT_BUTTON_TAG + i];
            buttonLeft.userInteractionEnabled = NO;
            buttonRight.userInteractionEnabled = NO;
        }
    }
}

- (void)theCorrectPointAnswer:(CGPoint)point
{
    int indexA = 0;
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < [self.qConnection.vRightSide count]; i++)
    {
        
        UIButton *buttonLeft = (UIButton *)[self viewWithTag:QUESTION_LINE_LEFT_BUTTON_TAG + i];
        if (buttonLeft.center.x == point.x && buttonLeft.center.y == point.y)
        {
            [array addObject:[NSNumber numberWithFloat:buttonLeft.center.x]];
            [array addObject:[NSNumber numberWithFloat:buttonLeft.center.y]];
            indexA = i;
        }
    }
    
    UIButton *buttonRight = (UIButton *)[self viewWithTag:QUESTION_LINE_RIGHT_BUTTON_TAG + [[self.qConnection.vAnswers objectAtIndex:indexA] intValue]];
    [array addObject:[NSNumber numberWithFloat:buttonRight.center.x]];
    [array addObject:[NSNumber numberWithFloat:buttonRight.center.y]];
    [theCorrectPointAnswerArray addObject:array];
}

//判断是否是同一条线上的点的按钮
- (void)closeTheButtonWithLeftAndRight
{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < [pointToPointArray count]; i++)
    {
        BOOL isSPTP;
        if ((([[[pointToPointArray objectAtIndex:i]objectAtIndex:0] intValue]== (NSInteger)p1.x) && ([[[pointToPointArray objectAtIndex:i]objectAtIndex:1] intValue] == (NSInteger)p1.y)
             &&
             (([[[pointToPointArray objectAtIndex:i]objectAtIndex:2] intValue]== (NSInteger)p2.x) && ([[[pointToPointArray objectAtIndex:i]objectAtIndex:3] intValue] == (NSInteger)p2.y))))
        {
            isSPTP = YES;
            [array addObject:[NSNumber numberWithInt:i]];
        }else{
            isSPTP = NO;
        }
        
        if (
            ([[[pointToPointArray objectAtIndex:i]objectAtIndex:0] intValue]== (NSInteger)p1.x)
            &&
            ([[[pointToPointArray objectAtIndex:i]objectAtIndex:1] intValue] == (NSInteger)p1.y)
            && isSPTP == NO
            )
        {
            [array addObject:[NSNumber numberWithInt:i]];
        }
        if (
            ([[[pointToPointArray objectAtIndex:i]objectAtIndex:2] intValue]== (NSInteger)p2.x)
            && ([[[pointToPointArray objectAtIndex:i]objectAtIndex:3] intValue] == (NSInteger)p2.y)
            && isSPTP == NO
            )
        {
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }

    for (int i = [array count] - 1; i >= 0 ; i--)
    {
        [pointToPointArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]];
        [theCorrectPointAnswerArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]];
    }
}

//画线方法
- (void)leftLineRightPoint
{
    
    for (int i =0 ; i < [self.subviews count]; i++)
    {
        if ([[self.subviews objectAtIndex:i]isKindOfClass:[UIImageView class]])
        {
            [[self.subviews objectAtIndex:i] removeFromSuperview];
        }
    }

    //    创建一个基于图片的上下文
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    //    取出“当前”上下文--也就是在上一句中刚刚创建的上下文
    //    返回值为CGContextRef类型
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    设置图片中线条的颜色和透明度
    CGContextSetRGBStrokeColor(ctx,0 , 0, 0, 1.0);
    //    设置线条的宽度
    CGContextSetLineWidth(ctx,QUESTION_LINE_WIDTH);
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx,p2.x, p2.y);
    for (int i = 0; i < [pointToPointArray count]; i++)
    {
        
        CGContextMoveToPoint(ctx, [[[pointToPointArray objectAtIndex:i] objectAtIndex:0] floatValue], [[[pointToPointArray objectAtIndex:i] objectAtIndex:1] floatValue]);
        
        CGContextAddLineToPoint(ctx,[[[pointToPointArray objectAtIndex:i] objectAtIndex:2] floatValue], [[[pointToPointArray objectAtIndex:i] objectAtIndex:3] floatValue]);
    }
    CGContextStrokePath(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    [self addSubview:imageView];
    [imageView release];
}

- (void)rightAnswerVerift
{
    isVerifiedAnswer = YES;
    for (int i =0 ; i < [self.subviews count]; i++)
    {
        if ([[self.subviews objectAtIndex:i]isKindOfClass:[UIImageView class]])
        {
            [[self.subviews objectAtIndex:i] removeFromSuperview];
        }
    }
    [self line];
}

- (void)line
{
    //    创建一个基于图片的上下文
    UIGraphicsBeginImageContext(CGSizeMake(SFSW, SFSH));
    //    返回值为CGContextRef类型
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    设置线条的宽度
    CGContextSetLineWidth(ctx,QUESTION_LINE_WIDTH);
    for (int i = 0; i < [theCorrectPointAnswerArray count]; i++)
    {
        if ([[[pointToPointArray objectAtIndex:i] objectAtIndex:2] intValue] == [[[theCorrectPointAnswerArray objectAtIndex:i] objectAtIndex:2] intValue] && [[[pointToPointArray objectAtIndex:i] objectAtIndex:3] intValue] == [[[theCorrectPointAnswerArray objectAtIndex:i] objectAtIndex:3] intValue])
        {
            CGContextSetRGBStrokeColor(ctx,0.0 , 1.0, 0, 1.0);
        }else{
            CGContextSetRGBStrokeColor(ctx,1.0 , 0, 0, 1.0);
        }
        
        CGContextMoveToPoint(ctx, [[[pointToPointArray objectAtIndex:i] objectAtIndex:0] floatValue], [[[pointToPointArray objectAtIndex:i] objectAtIndex:1] floatValue]);
        CGContextAddLineToPoint(ctx,[[[pointToPointArray objectAtIndex:i] objectAtIndex:2] floatValue], [[[pointToPointArray objectAtIndex:i] objectAtIndex:3] floatValue]);
        CGContextStrokePath(ctx);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0,0,SFSW,SFSH);
    [self addSubview:imageView];
    [imageView release];
}

- (void)clearAnswerButton
{
    for (int i =0 ; i < [self.subviews count]; i++)
    {
        if ([[self.subviews objectAtIndex:i]isKindOfClass:[UIImageView class]])
        {
        [[self.subviews objectAtIndex:i] removeFromSuperview];
        }
    }
     isVerifiedAnswer = NO;
    [pointToPointArray removeAllObjects];
    [theCorrectPointAnswerArray removeAllObjects];
    
    for (int i = 0; i < [self.qConnection.vRightSide count]; i++)
    {
        UIButton *buttonLeft = (UIButton *)[self viewWithTag:QUESTION_LINE_LEFT_BUTTON_TAG + i];
        UIButton *buttonRight = (UIButton *)[self viewWithTag:QUESTION_LINE_RIGHT_BUTTON_TAG + i];
        buttonLeft.userInteractionEnabled = YES;
        buttonRight.userInteractionEnabled = YES;
    }
    [self.delegate isReadyVerifiedAnswers];
}

- (void)isCloseTheInputTextView
{

}

- (void)theAnswerIsToVerifyWhether
{
    if (isVerifiedAnswer == YES && [pointToPointArray count] == [self.qConnection.vAnswers count])
    {
        [self.delegate isToEliminateAnswer];
    }else if (isVerifiedAnswer == NO && [pointToPointArray count] == [self.qConnection.vAnswers count])
    {
        [self.delegate isToVerifyAnswer];
        
    }else if (isVerifiedAnswer == NO && [pointToPointArray count] < [self.qConnection.vAnswers count])
    {
        [self.delegate isReadyVerifiedAnswers];
    }
}

@end
