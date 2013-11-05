//
//  QuestionRootView.m
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionRootView.h"
#import "MarkupParser.h"
#import <QuartzCore/QuartzCore.h>
@implementation QuestionRootView


- (void)dealloc
{
    [ctv release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}

- (void)initIncomingData:(PageQuestionList*)questionList
{
    pQuestionList = questionList;
}

- (void)composition
{
    [self initTitleView];
    [self initQuestion:self.frame];
    [self initPressEventComposition:self.frame];
}

-(void)initTitleView
{
    if (pQuestionList->stTitle.isRichText == YES)
    {
        [self isYesRichText];
    }else{
        [self isNoRichText];
    }
}

- (void)isYesRichText
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    for (int i = 0; i < pQuestionList->stTitle.vTextItemList.size(); i++)
    {
        switch (pQuestionList->stTitle.vTextItemList[i].pieceType)
        {
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                UIFont *font = [UIFont fontWithName:[NSString stringWithUTF8String:pQuestionList->stTitle.vTextItemList[i].fontFamily.c_str()] size:pQuestionList->stTitle.vTextItemList[i].fontSize];
                CGSize sizek = [@" " sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                NSInteger countK = (int)ceilf(pQuestionList->stTitle.vTextItemList[i].nLength/sizek.width);
                for (int j =0 ; j < countK; j++)
                {
                    [strBegin appendString:@" "];
                    [string appendString:@" "];
                }
             
            }
                break;
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pQuestionList->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pQuestionList->stTitle.vTextItemList[i].fontColor.rgbRed,pQuestionList->stTitle.vTextItemList[i].fontColor.rgbGreen,pQuestionList->stTitle.vTextItemList[i].fontColor.rgbBlue,pQuestionList->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pQuestionList->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pQuestionList->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pQuestionList->stTitle.vTextItemList[i].fontSize;
            }
                break;
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_END:
            {
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_DOT:
            {
            
            }
                break;
            default:
                break;
        }
    }
    [p setFont:strFont];
    [p setSize:fontsize];
    CGSize size = [string sizeWithFont:[UIFont fontWithName:strFont size:fontsize] constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
    ctv = [[CTView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    ctv.backgroundColor = [UIColor clearColor];
    [ctv setAttString:attString];
    [self addSubview:ctv];
    
    titHeight = size.height;
}

- (void)isNoRichText
{
    NSString *titleStr = [NSString stringWithCString:pQuestionList->stTitle.strText.c_str() encoding:NSUTF8StringEncoding];
    UILabel * label = [[UILabel alloc]init];
    [label setText:titleStr];
    label.tag = QUESTION_TITLELABEL_TAG;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    CGSize sizeLabel = [titleStr sizeWithFont:QUESTION_TITLE_FONT constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    label.font = QUESTION_TITLE_FONT;
    label.frame = CGRectMake(0, 0, SFSW, sizeLabel.height);
    [self addSubview:label];
    [label release];
    titHeight = label.FSH;
}

- (void)initPressEventComposition:(CGRect)frame
{
//    <--
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upButton.frame = CGRectMake(0, FSH-QUESTION_UPANDNEXT_HEIGHT, QUESTION_UPANDNEXT_WIDTH, QUESTION_UPANDNEXT_HEIGHT);
    upButton.hidden = YES;
    upButton.tag = QUESTION_UPBUTTON_TAG;
    [upButton addTarget:self action:@selector(upPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [upButton setImage:[UIImage imageNamed:@"g_up_question@2x.png"] forState:UIControlStateNormal];
    if (pQuestionList->vQuestions.size() > 1)
    {
        [self addSubview:upButton];
    }
//    ==
    UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [answerButton setBackgroundImage:[UIImage imageNamed:@"核对答案@2x.png"] forState:UIControlStateNormal];
    answerButton.tag = QUESTION_ANSWERBUTTON_TAG;
    answerButton.frame = CGRectMake(FSW/2-QUESTION_ANSWERBUTTON_WIDTH/2, FSH - QUESTION_UPANDNEXT_HEIGHT, QUESTION_ANSWERBUTTON_WIDTH, QUESTION_UPANDNEXT_HEIGHT);
     answerButton.userInteractionEnabled = NO;
    [answerButton addTarget:self action:@selector(answerPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:answerButton];
    
//    -->
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"g_down_question@2x.png"] forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(FSW-QUESTION_UPANDNEXT_WIDTH,FSH-QUESTION_UPANDNEXT_HEIGHT, QUESTION_UPANDNEXT_WIDTH, QUESTION_UPANDNEXT_HEIGHT);
    nextButton.tag = QUESTION_NEXTBUTTON_TAG;
    [nextButton addTarget:self action:@selector(nextPressButton:) forControlEvents:UIControlEventTouchUpInside];
    if (pQuestionList->vQuestions.size() > 1)
    {
        [self addSubview:nextButton];
    }
}

- (void)upPressButton:(UIButton *)button
{
    UIScrollView * scrollView = (UIScrollView *)[self viewWithTag:QUESTION_SCV_TAG];
    CGFloat aWidth = scrollView.frame.size.width;
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    int page = curPageView - 1;
    if (page < 0)
    {
        page = 0;
    }
    
    if (page == 0 )
    {
        button.hidden = YES;
        if (pQuestionList->vQuestions.size() > 1)
        {
            UIButton *nextButton = (UIButton *)[self viewWithTag:QUESTION_NEXTBUTTON_TAG];
            nextButton.hidden = NO;
        }
    }else{
        
        UIButton *nextButton = (UIButton *)[self viewWithTag:QUESTION_NEXTBUTTON_TAG];
        nextButton.userInteractionEnabled = YES;
        [nextButton setHidden:NO];
        button.hidden = NO;
    }
    //  切换到指定的页面
    [scrollView setContentOffset:CGPointMake(SFSW * page, 0)];
    [[scrollView.subviews objectAtIndex:page]theAnswerIsToVerifyWhether];
}

- (void)nextPressButton:(UIButton *)button
{
    UIScrollView * scrollView = (UIScrollView *)[self viewWithTag:QUESTION_SCV_TAG];
    CGFloat aWidth = scrollView.frame.size.width;
    //    得到当前页数
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    //  获取当前pagecontroll的值
    int page = curPageView + 1;
    if (page > (scrollView.contentSize.width/scrollView.FSW-1))
    {
        page = scrollView.contentSize.width/scrollView.FSW - 1;
    }
    
    if (page == scrollView.contentSize.width/scrollView.FSW - 1)
    {
        button.hidden = YES;
        if (pQuestionList->vQuestions.size() > 1)
        {
            UIButton *upButton = (UIButton *)[self viewWithTag:QUESTION_UPBUTTON_TAG];
            [upButton setHidden:NO];
        }
    }else{
        UIButton *upButton = (UIButton *)[self viewWithTag:QUESTION_UPBUTTON_TAG];
        upButton.userInteractionEnabled = YES;
        [upButton setHidden:NO];
        button.hidden = NO;
    }
    
    [scrollView setContentOffset:CGPointMake(SFSW * page, 0)];
    [[scrollView.subviews objectAtIndex:page]theAnswerIsToVerifyWhether];
}

#pragma mark - 验证答案和消除答案
- (void)answerPressButton:(UIButton *)button
{
    UIScrollView * scrollView = (UIScrollView *)[self viewWithTag:QUESTION_SCV_TAG];
    CGFloat aWidth = scrollView.FSW;
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    [[scrollView.subviews objectAtIndex:curPageView] rightAnswerVerift];
    [button setUserInteractionEnabled:NO];
    [button setHidden:YES];
    UIButton * but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    but.tag = QUESTION_AGAIN_ONCE_TAG;
    but.frame =button.frame;
    [but setBackgroundImage:[UIImage imageNamed:@"清除答案@2x.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clearButtonInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:but];
}

- (void)clearButtonInfo:(UIButton *)button
{
    UIScrollView * scrollView = (UIScrollView *)[self viewWithTag:QUESTION_SCV_TAG];
    CGFloat aWidth = scrollView.frame.size.width;
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    [[scrollView.subviews objectAtIndex:curPageView] clearAnswerButton];
}

#pragma mark - 代理按钮事件
- (void)isToVerifyAnswer
{
    UIButton *answerButton = (UIButton *)[self viewWithTag:QUESTION_ANSWERBUTTON_TAG];
    answerButton.userInteractionEnabled = YES;
    [answerButton setHidden:NO];
    UIButton *againButton = (UIButton *)[self viewWithTag:QUESTION_AGAIN_ONCE_TAG];
    [againButton removeFromSuperview];
}

- (void)isToEliminateAnswer
{
    UIButton *answerButton = (UIButton *)[self viewWithTag:QUESTION_ANSWERBUTTON_TAG];
    answerButton.userInteractionEnabled = NO;
    [answerButton setHidden:YES];
    UIButton *againButton = (UIButton *)[self viewWithTag:QUESTION_AGAIN_ONCE_TAG];
    [againButton removeFromSuperview];
    UIButton * but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    but.tag = QUESTION_AGAIN_ONCE_TAG;
    but.frame =answerButton.frame;
    [but setBackgroundImage:[UIImage imageNamed:@"清除答案@2x.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clearButtonInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:but];
}

- (void)isReadyVerifiedAnswers
{
    UIButton *answerButton = (UIButton *)[self viewWithTag:QUESTION_ANSWERBUTTON_TAG];
    answerButton.userInteractionEnabled = NO;
    [answerButton setHidden:NO];
    UIButton *againButton = (UIButton *)[self viewWithTag:QUESTION_AGAIN_ONCE_TAG];
    [againButton removeFromSuperview];
}

- (void)initQuestion:(CGRect)frame
{
    qSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, titHeight + QUESTION_DISTANT, FSW, FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
    qSc.layer.borderColor = [UIColor grayColor].CGColor;
    qSc.layer.borderWidth = 1.0;
    qSc.contentSize = CGSizeMake(FSW * pQuestionList->vQuestions.size(), FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT);
    qSc.delegate = self;
    qSc.tag = QUESTION_SCV_TAG;
    qSc.pagingEnabled = YES;
    qSc.showsHorizontalScrollIndicator = NO;
    qSc.showsVerticalScrollIndicator = NO;
    qSc.backgroundColor = [UIColor whiteColor];
    [self questionData];
    [self addSubview:qSc];
    [qSc release];
}

- (void)questionData
{
    for (int i = 0 ; i < pQuestionList->vQuestions.size(); i++)
    {
        PageQuestionBase *pQuestionBase = pQuestionList->vQuestions[i];
        switch (pQuestionBase->eType)
        {
            case PAGE_QUESTION_CHOICE://选择题
            {
                PageQuestionChoice *pQuestionChoice = (PageQuestionChoice *)pQuestionBase;
                [self creatQuestionChoiceData:self.frame withIndex:i withQuestionData:pQuestionChoice];
            }
                break;
            case PAGE_QUESTION_BRIEF_ANSWER://简答题
            {
                PageQuestionBriefAnswer *pQBA = (PageQuestionBriefAnswer *)pQuestionBase;
               [self createQuestionBriefAnswer:self.frame withIndex:i withQuestionData:pQBA];
            }
                break;
            case PAGE_QUESTION_CONNECTION://连线题
            {
                
                PageQuestionConnection *pQuestionC = (PageQuestionConnection *)pQuestionBase;
               [self creatQuestionLineData:self.frame withIndex:i withQuestionData:pQuestionC];
            }
                break;
            case PAGE_QUESTION_DRUG://拖动题
            {
                PageQuestionDrag *dragQuset = (PageQuestionDrag *)pQuestionBase;
                [self creatQuestionDragPointData:self.frame withIndex:i withQuestionData:dragQuset];
            }
                break;
            case PAGE_QUESTION_FILE_BLANK://填空题
            {
                PageQuestionFillBlank *pQuestionFillBlank  = (PageQuestionFillBlank *)pQuestionBase;
               [self creatQuestionFillBlank:self.frame withIndex:i withQuestionData:pQuestionFillBlank];
            }
                break;
            case PAGE_QUESTION_IMAGE_CHOICE://图像选择题
            {
                PageQuestionImageSelect *pQuestionImageSelect = (PageQuestionImageSelect *)pQuestionBase;
                [self creatQuestionImageSelected:self.frame withIndex:i withQuestionData:pQuestionImageSelect];
            }
                break;
            case PAGE_QUESTION_SORT://排序题
            {
                PageQuestionSort *pQuestionSort = (PageQuestionSort *)pQuestionBase;
               [self creatQuestionSort:self.frame withIndex:i withQuestionData:pQuestionSort];
            }
            default:
                break;
        }
    }
}

- (void)creatQuestionChoiceData:(CGRect)frame withIndex:(NSInteger)i withQuestionData:(PageQuestionChoice *)qChoiceData
{
    QuestionChoice *qChoice = [[QuestionChoice alloc]initWithFrame:CGRectMake(15 +FSW *i, 0, FSW-30, FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
            qChoice.tag = QUESTION_CONTENT_VIEW_TAG + i;
            qChoice.delegate = self;
    [qChoice initQuestionChoiceData:qChoiceData];
    [qChoice setQuestionTitleNumber:[NSString stringWithFormat:@"第%d题 (共%ld题)",i+1,pQuestionList->vQuestions.size()]];
    [qChoice composition];
    [qSc addSubview:qChoice];
    [qChoice release];
}

- (void)creatQuestionLineData:(CGRect)frame withIndex:(NSInteger)i withQuestionData:(PageQuestionConnection *)pQuestionC
{
    QuestionLine *qChoice = [[QuestionLine alloc]initWithFrame:CGRectMake(15 +FSW *i, 0, FSW-30, FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
    qChoice.delegate = self;
    qChoice.tag = QUESTION_LINE_VIEW_TAG + i;
    qChoice.backgroundColor = [UIColor clearColor];
    [qChoice setQuestionTitleNumber:[NSString stringWithFormat:@"第%d题 (共%ld题)",i+1,pQuestionList->vQuestions.size()]];
    [qChoice initQuestionChoiceData:pQuestionC];
    [qChoice composition];
    [qSc addSubview:qChoice];
    [qChoice release];
 }

- (void)creatQuestionSort:(CGRect)frame withIndex:(NSInteger)i withQuestionData:(PageQuestionSort *)pQuestionSort
{
    
        QuestionSort *qSort = [[QuestionSort alloc]initWithFrame:CGRectMake(15 +FSW *i, 0, FSW-30, FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
    qSort.tag = QUESTION_SORT_VIEW_TAG + i;
    qSort.delegate = self;
    [qSort initQuestionChoiceData:pQuestionSort];
    [qSort setQuestionTitleNumber:[NSString stringWithFormat:@"第%d题 (共%ld题)",i+1,pQuestionList->vQuestions.size()]];
    [qSort composition];
    [self isToVerifyAnswer];
    [qSc addSubview:qSort];
    [qSort release];
}

- (void)creatQuestionFillBlank:(CGRect)frame withIndex:(NSInteger)i withQuestionData:(PageQuestionFillBlank *)pQuestionFillBlank
{
        QuestionFillBlank * qFB = [[QuestionFillBlank alloc]initWithFrame:CGRectMake(15 + FSW *i, 0, FSW-30,FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
    qFB.delegate = self;
    [qFB initQuestionChoiceData:pQuestionFillBlank];
    [qFB setQuestionTitleNumber:[NSString stringWithFormat:@"第%d题 共%ld题",i+1,pQuestionList->vQuestions.size()]];
    [qFB composition];
    [self isToVerifyAnswer];
    [qSc addSubview:qFB];
    [qFB release];
}

- (void)creatQuestionImageSelected:(CGRect)frame withIndex:(NSInteger)i withQuestionData:(PageQuestionImageSelect *)pQuestionImageSelect
{
        QuestionImageSelect *qIS = [[QuestionImageSelect alloc]initWithFrame:CGRectMake(15 +FSW *i, 0, FSW-30, FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
    [qIS initQuestionChoiceData:pQuestionImageSelect];
    [qIS setQuestionTitleNumber:[NSString stringWithFormat:@"第%d题 (共%ld题)",i+1,pQuestionList->vQuestions.size()]];
        qIS.tag = QUESTION_IMAGE_SELECTED_VIEW_TAG + i;
        qIS.delegate = self;
        [qIS composition];
        [qSc addSubview:qIS];
        [qIS release];
    
}

- (void)createQuestionBriefAnswer:(CGRect)frame withIndex:(NSInteger)i withQuestionData:(PageQuestionBriefAnswer *)qBriefAnswer
{
    QuestionBriefAnswer *questionBriefAnswer = [[QuestionBriefAnswer alloc]initWithFrame:CGRectMake(15 +FSW *i, 0, FSW-30, FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
    questionBriefAnswer.tag = QUESTION_BRIEFANSWER_VIEW_TAG + i;
    questionBriefAnswer.delegate = self;
    [questionBriefAnswer setQuestionTitleNumber:[NSString stringWithFormat:@"第%d题 (共%ld题)",i+1,pQuestionList->vQuestions.size()]];
    [questionBriefAnswer initQuestionChoiceData:qBriefAnswer];
    [questionBriefAnswer composition];
    [self isToVerifyAnswer];
    [qSc addSubview:questionBriefAnswer];
    [questionBriefAnswer release];
}

- (void)creatQuestionDragPointData:(CGRect)frame withIndex:(NSInteger)i withQuestionData:(PageQuestionDrag *)dragQuset
{
    QuestionDragPoint *qChoice = [[QuestionDragPoint alloc]initWithFrame:CGRectMake(15 + FSW * i, 0, FSW-30, FSH-QUESTION_DISTANT*2-titHeight-QUESTION_UPANDNEXT_HEIGHT)];
    qChoice.tag = QUESTION_DRAGTOPONT_VIEW_TAG + i;
    qChoice.delegate = self;
    [qChoice setQuestionTitleNumber:[NSString stringWithFormat:@"第%d题 (共%ld题)",i+1,pQuestionList->vQuestions.size()]];
    [qChoice initQuestionChoiceData:dragQuset];
    [qChoice composition];
    [qSc addSubview:qChoice];
    [qChoice release];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat aWidth = scrollView.frame.size.width;
    //    得到当前页数
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    if (curPageView < 0)
    {
        curPageView = 0;
    }
    else if (curPageView > pQuestionList->vQuestions.size()-1)
    {
        curPageView =  pQuestionList->vQuestions.size()-1;
    }
#pragma mark - 修改用于记录题目的总个数
    if (curPageView == 0)
    {
        UIButton *upButton = (UIButton *)[self viewWithTag:QUESTION_UPBUTTON_TAG];
        upButton.hidden = YES;
        if (pQuestionList->vQuestions.size() > 1)
        {
            UIButton *nextButton = (UIButton *)[self viewWithTag:QUESTION_NEXTBUTTON_TAG];
            nextButton.hidden = NO;
        }
    }else if (curPageView ==  pQuestionList->vQuestions.size()-1){
        
        UIButton *nextButton = (UIButton *)[self viewWithTag:QUESTION_NEXTBUTTON_TAG];
        nextButton.hidden = YES;
        if (pQuestionList->vQuestions.size() > 1)
        {
            UIButton *upButton = (UIButton *)[self viewWithTag:QUESTION_UPBUTTON_TAG];
            upButton.hidden = NO;
        }
    }else{
        
        UIButton *upButton = (UIButton *)[self viewWithTag:QUESTION_UPBUTTON_TAG];
        upButton.hidden = NO;
        UIButton *nextButton = (UIButton *)[self viewWithTag:QUESTION_NEXTBUTTON_TAG];
        nextButton.hidden = NO;
    }
    [[scrollView.subviews objectAtIndex:curPageView]theAnswerIsToVerifyWhether];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat aWidth = scrollView.frame.size.width;
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    
    if (curPageView < 0)
    {
        curPageView = 0;
    }else if(curPageView > pQuestionList->vQuestions.size()-1){
        curPageView =  pQuestionList->vQuestions.size()-1;
    }
    
    [[scrollView.subviews objectAtIndex:curPageView]isCloseTheInputTextView];
}

#pragma mark - 简答题需要的数据
- (CGFloat)superviewHeight
{
    return titHeight + QUESTION_DISTANT;
}
- (CGFloat)superviewOriginY
{
    return SFOY;
}

@end