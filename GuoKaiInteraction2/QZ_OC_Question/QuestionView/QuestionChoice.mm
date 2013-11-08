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
    titleContent.textColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
    NSMutableString *stringContent = [NSMutableString stringWithString:self.qChoice.strQuestion];
    
    BOOL isLeftBrackets = NO;
    NSInteger indexLeftBrackets = 0;
    BOOL isRightBrackets = NO;
    NSInteger indexRightBrackets = 0;
    
    for (int i = 0; i < [stringContent length]-1; i++)
    {
        if ([[stringContent substringWithRange:NSMakeRange(i,1)] isEqualToString:@"（"] || [[stringContent substringWithRange:NSMakeRange(i,1)] isEqualToString:@"("])
        {
            isLeftBrackets = YES;
            indexLeftBrackets = i;
        }
        if ([[stringContent substringWithRange:NSMakeRange(i,1)] isEqualToString:@"）"] || [[stringContent substringWithRange:NSMakeRange(i,1)] isEqualToString:@")"])
        {
            isRightBrackets = YES;
            indexRightBrackets = i;
        }
        if (isLeftBrackets && isRightBrackets)
        {
            CGSize sizeL = [[stringContent substringToIndex:indexLeftBrackets+1] sizeWithFont:QUESTION_TOPIC_FONT constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            CGSize sizeR = [[stringContent substringToIndex:indexRightBrackets+1] sizeWithFont:QUESTION_TOPIC_FONT constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            if (sizeL.height != sizeR.height)
            {
            [stringContent insertString:@"\n" atIndex:indexLeftBrackets-1];
            }
            isLeftBrackets = NO;
            isRightBrackets = NO;
        }
    }
    
    CGSize sizeTt = [stringContent sizeWithFont:QUESTION_TOPIC_FONT constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleContent.frame = CGRectMake(0,titleNumber.FSH + 25, SFSW, sizeTt.height);
    titleContent.text = stringContent;
    titleContent.font = QUESTION_TOPIC_FONT;
    [self addSubview:titleContent];
}

- (void)creatLine
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, titleContent.FSH + titleNumber.FSH +25, SFSW, 30);
    UIGraphicsBeginImageContext(CGSizeMake(SFSW, 30));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx,52.0/255.0 , 52.0/255.0, 52.0/255.0, 1.0);
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

- (BOOL)isAquelLenght
{
    int maxLength = 0;
    int indexNum = 0;
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        if ([[self.qChoice.vChoices objectAtIndex:i] length] > maxLength)
        {
            maxLength = [[self.qChoice.vChoices objectAtIndex:i] length];
            indexNum = i;
        }
    }
    int numberOfCount = 0;
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        if ([[self.qChoice.vChoices objectAtIndex:i] length] == maxLength)
        {
            numberOfCount++;
        }
    }
    
    if (numberOfCount == [self.qChoice.vChoices count])
    {
        return YES;
    }
    return NO;
}

- (NSInteger)maxLengthOfAnswer
{
    int maxLength = 0;
    int indexNum = 0;
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        if ([[self.qChoice.vChoices objectAtIndex:i] length] > maxLength)
        {
            maxLength = [[self.qChoice.vChoices objectAtIndex:i] length];
            indexNum = i;
        }
    }
    return indexNum;
}

- (void)creatAnswerPressButton
{
    if ([self isAquelLenght])
    {
        [self sameAnswer];
    }else{
        [self anyAnswer:[self maxLengthOfAnswer]];
    }
}

- (void)sameAnswer
{
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"ansp.png"] forState:UIControlStateNormal];
        button.tag = QUESTION_ANSWER_BUTTON_CHOICE_TAG + i;
        button.showsTouchWhenHighlighted = YES;
        NSString *title = [NSString stringWithFormat:@" %c. %@",65+i,[self.qChoice.vChoices objectAtIndex:i]];
        button.titleLabel.font = QUESTION_ANSWER_FONT;
        button.titleLabel.numberOfLines = 0;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGSize sizeTt = [title sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        button.frame = CGRectMake(0, (titleContent.FSH + titleNumber.FSH + 55 + SFSH)/2 - ((20+sizeTt.height)*[self.qChoice.vChoices count] - 20)/2 + (20+sizeTt.height)*i, SFSW, sizeTt.height);
        [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(pressOne:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(pressThree:) forControlEvents:UIControlEventTouchDragOutside];
        [button setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateSelected];
        [self addSubview:button];
       }
}


- (void)anyAnswer:(NSInteger)indexNum
{       
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"ansp.png"] forState:UIControlStateNormal];
        button.tag = QUESTION_ANSWER_BUTTON_CHOICE_TAG + i;
        button.showsTouchWhenHighlighted = YES;
        button.titleLabel.font = QUESTION_ANSWER_FONT;
        button.titleLabel.numberOfLines = 0;
        NSMutableString *title = [[NSMutableString alloc]initWithFormat:@" %c. ",65+i];
        if (i == indexNum)
        {
            [title appendFormat:@"%@",[self.qChoice.vChoices objectAtIndex:i]];
            
          }else{
             [title appendFormat:@"%@",[self.qChoice.vChoices objectAtIndex:i]];
            while (1)
            {
                CGSize sizeTt = [title sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW-23, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                if (sizeTt.width >= [[NSString stringWithFormat:@" %c. %@",65+indexNum,[self.qChoice.vChoices objectAtIndex:indexNum]]  sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW-23, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].width)
                {
                    break;
                }
                [title appendString:@" "];
             }
         }
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGSize sizeTt = [title sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW-23, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        button.frame = CGRectMake(0, (titleContent.FSH + titleNumber.FSH + 55 + SFSH)/2 - ((20+sizeTt.height)*[self.qChoice.vChoices count] - 20)/2 + (20+sizeTt.height)*i, SFSW, sizeTt.height);
        [button addTarget:self action:@selector(pressOne:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(pressThree:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateSelected];
        [self addSubview:button];
     }
 }

- (void)pressOne:(UIButton *)button
{
    [UIView animateWithDuration:0.1 animations:^{
        button.transform =  CGAffineTransformMakeScale(1.2,1.2);
    }];
}

- (void)pressButton:(UIButton *)button
{
    [UIView animateWithDuration:0.1 animations:^{
    button.transform =  CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
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
        if (button.selected)
        {
            [answerNumber removeAllObjects];
           [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]]; 
        }
      }else if ([self.qChoice.vAnswer count] != 1){
          
        button.selected = !button.selected;
        if (button.selected)
        {
            [answerNumber addObject:[NSString stringWithFormat:@"%d",button.tag]];
        }
    }
    
    if ([answerNumber count] > 0)
    {
        [self.delegate isToVerifyAnswer];
    }else{
        
        [self.delegate isReadyVerifiedAnswers];
    }
}

- (void)pressThree:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^{
        button.transform =  CGAffineTransformMakeScale(1.0, 1.0);
    }];
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
    
    if ([answerNumber count] > 1)
    {
        [self.delegate isToVerifyAnswer];
    }else{
    
        [self.delegate isReadyVerifiedAnswers];
    }
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
                [but setImage:[UIImage imageNamed:@"g_Quest_no@2x.png"] forState:UIControlStateNormal];
            }else if (but.selected == YES && [[self.qChoice.vAnswer lastObject]intValue] != i )
            {
                [but setImage:[UIImage imageNamed:@"g_Quest_yes@2x.png"] forState:UIControlStateNormal];
            }
            but.selected = NO;
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
            [but setImage:[UIImage imageNamed:@"g_Quest_no@2x.png"] forState:UIControlStateNormal];
                   }else{
            [but setImage:[UIImage imageNamed:@"g_Quest_yes@2x.png"] forState:UIControlStateNormal];
                    break;
                }}
            }
            but.selected = NO;
        }
    }
}

- (void)clearAnswerButton
{
    for (int i = 0; i < [self.qChoice.vChoices count]; i++)
    {
        UIButton *but = (UIButton *)[self viewWithTag:QUESTION_ANSWER_BUTTON_CHOICE_TAG+i];
        but.userInteractionEnabled = YES;
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
