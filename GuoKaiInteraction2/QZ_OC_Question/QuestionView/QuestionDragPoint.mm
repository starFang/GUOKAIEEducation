//
//  QuestionDragPoint.m
//  Question
//
//  Created by qanzone on 13-10-10.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionDragPoint.h"
#import <QuartzCore/QuartzCore.h>

@implementation QuestionDragPoint


@synthesize delegate;
@synthesize dragQuestion = _dragQuestion;
@synthesize questionTitleContent = _questionTitleContent;
@synthesize questionTitleNumber = _questionTitleNumber;

- (void)dealloc
{
    [backImageView release];
    [self.dragQuestion release];
    [titleNumber release];
    [titleContent release];
    [imageArrayRect release];
    [answerArray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        imageArrayRect = [[NSMutableArray alloc]init];
        answerArray = [[NSMutableArray alloc]init];
        isVerifiedAnswer = NO;
    }
    return self;
}

- (void)initQuestionChoiceData:(PageQuestionDrag *)dragQuset
{
    self.dragQuestion = [[PageQuestionDrag1 alloc]init];
    [self.dragQuestion setStrQuestion:[NSString stringWithCString:dragQuset->strQuestion.c_str() encoding:NSUTF8StringEncoding]];
    [self.dragQuestion setStrBackGroundImage:[NSString stringWithCString:dragQuset->strBackGroundImage.c_str() encoding:NSUTF8StringEncoding]];
    for (int i = 0; i < dragQuset->vStringSide.size(); i++)
    {
    [self.dragQuestion.vStringSide addObject:[NSString stringWithCString:dragQuset->vStringSide[i].c_str() encoding:NSUTF8StringEncoding]];
    }
    
    for (int i = 0; i < dragQuset->vImageSide.size(); i++)
    {
        PageQuestionDragPoint1 *questionDragPoint = [[PageQuestionDragPoint1 alloc]init];
        QZ_BOX1 *rect = [[QZ_BOX1 alloc]init];
        [rect setX0:dragQuset->vImageSide[i].rect.X0];
        [rect setX1:dragQuset->vImageSide[i].rect.X1];
        [rect setY0:dragQuset->vImageSide[i].rect.Y0];
        [rect setY1:dragQuset->vImageSide[i].rect.Y1];
        [questionDragPoint setRect:rect];
        [rect release];
        [questionDragPoint setNAnswer:dragQuset->vImageSide[i].nAnswer];
        [self.dragQuestion.vImageSide addObject:questionDragPoint];
        [questionDragPoint release];
    }
}
- (void)composition
{
    [self creatquestionTitleNumber];
    [self creatquestionTitleContent];
    [self creatLine];
    [self viewDisPlayWithBackImage ];
    [self answerDisplay];
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
    titleContent.textColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
    titleContent.text = self.dragQuestion.strQuestion;
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
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, 30));
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

- (void)viewDisPlayWithBackImage
{
    NSString *imagepath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:self.dragQuestion.strBackGroundImage];
    UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
    backImageView = [[UIImageView alloc]initWithImage:image];
    backImageView.frame = CGRectMake(0,titleContent.FSH + titleNumber.FSH + 55 , SFSW, SFSH - 120 -(titleContent.FSH + titleNumber.FSH + 55));
    backImageView.layer.borderColor = [UIColor grayColor].CGColor;
    backImageView.layer.borderWidth =1.0;
    [self addSubview:backImageView];
    for (int i = 0; i < [self.dragQuestion.vImageSide count]; i++)
    {
        
        UIButton * imageButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.tag = QUESTION_DRAGTOPOINT_ANSWER_IMAGE_VIEW_TAG + i;
        imageButton.selected = NO;
        UIImage *imagePoint = [UIImage imageNamed:@"ansp.png"];
        [imageButton setImage:imagePoint forState:UIControlStateNormal];
        PageQuestionDragPoint1 *dragPoint = [self.dragQuestion.vImageSide objectAtIndex:i];
        QZ_BOX1 *rect = dragPoint.rect;
        imageButton.frame = CGRectMake(rect.x0, rect.y0, rect.x1-rect.x0, rect.y1-dragPoint.rect.y0);
        [imageButton.layer setShadowOffset:CGSizeMake(1, 1)];
        [imageButton.layer setShadowRadius:5.0];
        [imageButton.layer setShadowColor:[UIColor blackColor].CGColor];
        [imageButton.layer setShadowOpacity:0.5];
        [backImageView addSubview:imageButton];
    }
}

#pragma mark - 没有解决的坐标计算
- (void)answerDisplay
{
    for (int i = 0; i < [self.dragQuestion.vStringSide count]; i++)
    {
        UIImage *image = [UIImage imageNamed:@"backlab.png"];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.tag = QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG + i;
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(((SFSW-20)/3+10)*(i%3), SFSH-55+(i/3-1)*45, (SFSW-20)/3, QUESTION_DRAGTOPOINT_ANSWER_IMAGE_HEIGHT);
        
//        保存图片坐标数组
        QZ_BOX1 * rect = [[QZ_BOX1 alloc]init];
        [rect setX0:((SFSW-20)/3+10)*(i%3)];
        [rect setY0:SFSH-55+(i/3-1)*45];
        [rect setX1:((SFSW-20)/3+10)*(i%3) + (SFSW-20)/3];
        [rect setY1:SFSH-55+(i/3-1)*45+QUESTION_DRAGTOPOINT_ANSWER_IMAGE_HEIGHT];
        [imageArrayRect addObject:rect];
        [rect release];
        
        [imageView.layer setShadowOffset:CGSizeMake(1, 1)];
        [imageView.layer setShadowRadius:2.0];
        [imageView.layer setShadowColor:[UIColor grayColor].CGColor];
        [imageView.layer setShadowOpacity:1.0];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureForImage:)];
        panGesture.maximumNumberOfTouches = 1;
        panGesture.minimumNumberOfTouches = 1;
        panGesture.delegate = self;
        [imageView addGestureRecognizer:panGesture];
        [panGesture release];
        
        UILabel * la = [[UILabel alloc]init];
        la.frame = imageView.bounds;
        la.backgroundColor = [UIColor clearColor];
        la.textAlignment = NSTextAlignmentCenter;
        la.font = QUESTION_ANSWER_FONT;
        la.font = [UIFont boldSystemFontOfSize:13];
        la.text = [self.dragQuestion.vStringSide objectAtIndex:i];
        [imageView addSubview:la];
        [self addSubview:imageView];
        [imageView release];
        [la release];
    }
}

- (void)panGestureForImage:(UIPanGestureRecognizer *)gestureRecognizer
{
        switch ([gestureRecognizer state])
        {
            case UIGestureRecognizerStateBegan:
                [self panBegan:gestureRecognizer];
                break;
            case UIGestureRecognizerStateChanged:
                [self panMoved:gestureRecognizer];
                break;
            case UIGestureRecognizerStateEnded:
                [self panEnded:gestureRecognizer];
                break;
            default:
                break;
        }
}

- (void)panBegan:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    for (int i = 0; i < [answerArray count]; i++)
    {
        QZ_BOX1 *rectAns = [answerArray objectAtIndex:i];
        if (((gestureRecognizer.view.frame.origin.x >= rectAns.x0-1.0)
            && (gestureRecognizer.view.frame.origin.x <= rectAns.x0+1.0))
            && ((gestureRecognizer.view.frame.origin.y >= rectAns.y0-1.0)
            && (gestureRecognizer.view.frame.origin.y <= rectAns.y0+1.0)))
            {
                [answerArray removeObjectAtIndex:i];
            }
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    [UIView animateWithDuration:0.2 animations:^{
            gestureRecognizer.view.transform = CGAffineTransformMakeScale(0.8,0.8);
            [(UIImageView *)gestureRecognizer.view setImage:[UIImage imageNamed:@"qipao1.png"]];
        UILabel *label = (UILabel *)[gestureRecognizer.view.subviews lastObject];
        label.frame = CGRectMake(0, 10,[UIImage imageNamed:@"qipao1.png"].size.width, [UIImage imageNamed:@"qipao1.png"].size.height/2);
        gestureRecognizer.view.frame = CGRectMake(location.x, location.y, [UIImage imageNamed:@"qipao1.png"].size.width, [UIImage imageNamed:@"qipao1.png"].size.height);
        gestureRecognizer.view.center = location;
    }];
    
    [self  bringSubviewToFront:gestureRecognizer.view];
    
    startPoint = location;
    distancePoint = CGPointMake(gestureRecognizer.view.center.x-location.x, gestureRecognizer.view.center.y-location.y);
    CGPoint locationLabel = [gestureRecognizer locationInView:gestureRecognizer.view];
    firstPoint = CGPointMake(locationLabel.x + distancePoint.x,  locationLabel.y + distancePoint.y);
}

- (void)panMoved:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    gestureRecognizer.view.center = CGPointMake(location.x +distancePoint.x,  location.y +distancePoint.y);
    CGPoint locationBack = [gestureRecognizer locationInView:backImageView];
    for (int i = 0; i < [self.dragQuestion.vImageSide count]; i++)
    {
        PageQuestionDragPoint1 *dragPoint = [self.dragQuestion.vImageSide objectAtIndex:i];
        QZ_BOX1 *rect = dragPoint.rect;
       UIButton * imageButton = (UIButton *)[backImageView viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_IMAGE_VIEW_TAG+i];
        if ((locationBack.x >= rect.x0 - QUESTION_DRAGTOPOINT_ANSWER_W_AND_H && locationBack.y>=rect.y0 - QUESTION_DRAGTOPOINT_ANSWER_W_AND_H) &&(locationBack.x <=rect.x1 + QUESTION_DRAGTOPOINT_ANSWER_W_AND_H && locationBack.y <= rect.y1 + QUESTION_DRAGTOPOINT_ANSWER_W_AND_H))
        {
            [imageButton setImage:[UIImage imageNamed:@"g_selected@2x.png"] forState:UIControlStateNormal];
        }else if(!imageButton.selected){
            [imageButton setImage:[UIImage imageNamed:@"ansp.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)panEnded:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint locationBack = [gestureRecognizer locationInView:backImageView];
    BOOL isAnswer = NO;
    QZ_BOX1 *rectAnswer;
    for (int i = 0; i < [self.dragQuestion.vImageSide count]; i++)
    {
        PageQuestionDragPoint1 *dragPoint = [self.dragQuestion.vImageSide objectAtIndex:i];
        QZ_BOX1 *rect = dragPoint.rect;
        if ((locationBack.x >= rect.x0 - QUESTION_DRAGTOPOINT_ANSWER_W_AND_H && locationBack.y>=rect.y0 - QUESTION_DRAGTOPOINT_ANSWER_W_AND_H) &&(locationBack.x <=rect.x1 + QUESTION_DRAGTOPOINT_ANSWER_W_AND_H && locationBack.y <= rect.y1 + QUESTION_DRAGTOPOINT_ANSWER_W_AND_H))
        {
            isAnswer = YES;
            rectAnswer = rect;
            UIImage *imagePoint = [UIImage imageNamed:@"g_selected@2x.png"];
            UIButton * imageButton = (UIButton *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_IMAGE_VIEW_TAG + i];
            [imageButton setImage:imagePoint forState:UIControlStateNormal];
            imageButton.selected = YES;
        }
    }
    if (isAnswer == YES)
    {
        [self statePanTwo:gestureRecognizer withAnswerPoint:rectAnswer];
    }else if(isAnswer == NO){
        [self statePanOne:gestureRecognizer];
        
    }
}

- (void)statePanOne:(UIPanGestureRecognizer *)gestureRecognizer
{
    QZ_BOX1 *rect = [imageArrayRect objectAtIndex:gestureRecognizer.view.tag-QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG];
    [UIView animateWithDuration:0.5f animations:^{
        
        [(UIImageView *)gestureRecognizer.view setImage:[UIImage imageNamed:@"backlab.png"]];
        gestureRecognizer.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        gestureRecognizer.view.frame = CGRectMake(rect.x0, rect.y0, rect.x1 - rect.x0 , rect.y1 - rect.y0);
        [(UILabel *)[gestureRecognizer.view.subviews lastObject] setFrame:CGRectMake(0,0, gestureRecognizer.view.frame.size.width, gestureRecognizer.view.frame.size.height)];
        distancePoint = CGPointMake(0, 0);
    }];
}

- (void)changeFirst:(QZ_BOX1 *)rectAns
{
    for (int i = 0; i < [self.dragQuestion.vStringSide count]; i++)
    {
        UIImageView * imageView = (UIImageView *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG + i];
        if (((imageView.FOX >= rectAns.x0-1.0) && imageView.FOX <= rectAns.x0+1.0)
            &&
            ((imageView.FOY >= rectAns.y0-1.0)&&(imageView.FOY <= rectAns.y0+1.0)))
        {
            QZ_BOX1 *rect = [imageArrayRect objectAtIndex:imageView.tag-QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG];
            
            [UIView animateWithDuration:0.5 animations:^{
                [imageView setImage:[UIImage imageNamed:@"backlab.png"]];
                imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                imageView.frame = CGRectMake(rect.x0, rect.y0, rect.x1 - rect.x0 , rect.y1 - rect.y0);
                [(UILabel *)[imageView.subviews lastObject] setFrame:CGRectMake(0,0, imageView.FSW, imageView.FSH)];
            }];
        }
    }
}

- (void)statePanTwo:(UIPanGestureRecognizer *)gestureRecognizer withAnswerPoint:(QZ_BOX1 *)rect
{
    for (int i = 0; i < [answerArray count]; i++)
    {
        QZ_BOX1 * rectA = [answerArray objectAtIndex:i];
        if (rect.x0 <= SFSW/2)
        {
            if (rectA.x0 == rect.x1 && rectA.y0 == rect.y0+ 97)
            {
                [answerArray removeObjectAtIndex:i];
            }
        }else{
            
            if (rectA.x0 == rect.x0-gestureRecognizer.view.FSW && rectA.y0 == rect.y0+ 97)
            {
                [answerArray removeObjectAtIndex:i];
            }
        }
     }
    
    [UIView animateWithDuration:0.5f animations:^{
        gestureRecognizer.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        QZ_BOX1 * rectAnswer = [[QZ_BOX1 alloc]init];
        if (rect.x0 <= SFSW/2)
        {
            [rectAnswer setX0:rect.x0-30];
            [rectAnswer setY0:rect.y0+ 50];
            [rectAnswer setX1:rect.x1+30];
            [rectAnswer setY1:rect.y0+ 50+gestureRecognizer.view.FSH-10];
            [answerArray addObject:rectAnswer];
        }else{
            [rectAnswer setX0:rect.x0-110];
            [rectAnswer setY0:rect.y0+ 97];
            [rectAnswer setX1:rect.x0];
            [rectAnswer setY1:rect.y0+ 97+gestureRecognizer.view.FSH-20];
            [answerArray addObject:rectAnswer];
            [(UIImageView *)gestureRecognizer.view setImage:[UIImage imageNamed:@"g_Drag_q_L.png"]];
        }
        [self changeFirst:rectAnswer];
        gestureRecognizer.view.frame = CGRectMake(rectAnswer.x0,rectAnswer.y0,rectAnswer.x1-rectAnswer.x0,rectAnswer.y1-rectAnswer.y0);
        [rectAnswer release];
        [(UILabel *)[gestureRecognizer.view.subviews lastObject] setFrame:CGRectMake(0,0, gestureRecognizer.view.FSW, 30)];
        distancePoint = CGPointMake(0, 0);
    }];
    
    if ([answerArray count] == [self.dragQuestion.vStringSide count])
    {
        [self.delegate isToVerifyAnswer];
        for (int i = 0; i < [self.dragQuestion.vStringSide count]; i++)
        {
            UIImageView * imageView = (UIImageView *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG + i];
            imageView.userInteractionEnabled = NO;
        }
    }
}

- (void)rightAnswerVerift
{
    isVerifiedAnswer = YES;
    for (int i = 0; i < [self.dragQuestion.vImageSide count]; i++)
    {
        PageQuestionDragPoint1 *pdp = [self.dragQuestion.vImageSide objectAtIndex:i];
        UIButton * imageButton = (UIButton *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_IMAGE_VIEW_TAG+i];
        UIImageView *imageView = (UIImageView *)[self viewWithTag:pdp.nAnswer+QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG];
        if (imageButton.FOX < SFSW/2)
        {
            if (((imageView.FOX >= imageButton.FOX-imageView.FSW-1.0)&&(imageView.FOX <= imageButton.FOX+imageView.FSW+1.0)) &&
                (((imageView.FOY-97 >= imageButton.FOY-1.0)&&(imageView.FOY-97 <= imageButton.FOY+1.0))))
            {
                [imageButton setImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
            }else{
                [imageButton setImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
            }
        }else{
            if (((imageView.FOX >= imageButton.FOX-imageView.FSW-1.0)&&(imageView.FOX <= imageButton.FOX-imageView.FSW+1.0)) &&
                (((imageView.FOY-97 >= imageButton.FOY-1.0)&&(imageView.FOY-97 <= imageButton.FOY+1.0))))
            {
                [imageButton setImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
            }else{
                [imageButton setImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    for (int i = 0 ; i < [self.dragQuestion.vStringSide count]; i++)
    {
        UIImageView * imageViewSide = (UIImageView *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG+i];
        imageViewSide.userInteractionEnabled = NO;
    }
}
- (void)clearAnswerButton
{
    isVerifiedAnswer = NO;
    [answerArray removeAllObjects];
    for (int i = 0; i < [self.dragQuestion.vStringSide count]; i++)
    {
        UIImageView * imageView = (UIImageView *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG + i];
        QZ_BOX1 *rect = [imageArrayRect objectAtIndex:i];
        [UIView animateWithDuration:0.5 animations:^{
                [imageView setImage:[UIImage imageNamed:@"backlab.png"]];
                imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                imageView.frame = CGRectMake(rect.x0, rect.y0, rect.x1 - rect.x0 , rect.y1 - rect.y0);
                [(UILabel *)[imageView.subviews lastObject] setFrame:CGRectMake(0,0, imageView.FSW, imageView.FSH)];
            }];
        UIButton * imageButton = (UIButton *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_IMAGE_VIEW_TAG + i];
        [imageButton setImage:[UIImage imageNamed:@"ansp.png"] forState:UIControlStateNormal];
        imageButton.selected = NO;
    }
    for (int i = 0 ; i < [self.dragQuestion.vStringSide count]; i++)
    {
        UIImageView * imageViewSide = (UIImageView *)[self viewWithTag:QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG+i];
        imageViewSide.userInteractionEnabled = YES;
    }
    [self.delegate isReadyVerifiedAnswers];
}

- (void)isCloseTheInputTextView
{

}

- (void)theAnswerIsToVerifyWhether
{
    if (isVerifiedAnswer == YES && [answerArray count] == [self.dragQuestion.vImageSide count])
    {
        [self.delegate isToEliminateAnswer];
    }else if (isVerifiedAnswer == NO && [answerArray count] == [self.dragQuestion.vImageSide count])
    {
        [self.delegate isToVerifyAnswer];
        
    }else if (isVerifiedAnswer == NO && [answerArray count] != [self.dragQuestion.vImageSide count])
    {
        [self.delegate isReadyVerifiedAnswers];
    }
}


@end
