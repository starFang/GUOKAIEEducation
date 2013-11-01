//
//  QuestionSort.m
//  Question
//
//  Created by qanzone on 13-10-13.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QuestionSort.h"

@implementation QuestionSort

@synthesize qSort;
@synthesize questionTitleNumber;
@synthesize answerTableView = _answerTableView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        titleNumber = [[UILabel alloc]init];
        titleContent = [[UILabel alloc]init];
        isVerifiedAnswer = NO;
    }
    return self;
}

- (void)initQuestionChoiceData:(PageQuestionSort *)pQuestionSort
{
 
    self.qSort = [[PageQuestionSort1 alloc]init];
    [self.qSort setStrQuestion:[NSString stringWithCString:pQuestionSort->strQuestion.c_str() encoding:NSUTF8StringEncoding]];

    for (int i = 0; i < pQuestionSort->vStrTexts.size(); i++)
    {
        [self.qSort.vStrTexts addObject:[NSString stringWithCString:pQuestionSort->vStrTexts[i].c_str() encoding:NSUTF8StringEncoding]];
    }
    for (int i = 0; i < pQuestionSort->vSortedList.size(); i++)
    {
        [self.qSort.vSortedList addObject:[NSString stringWithFormat:@"%d",pQuestionSort->vSortedList[i]]];
    }
}

- (void)composition
{
    [self creatquestionTitleNumber];
    [self creatquestionTitleContent];
    [self creatLine];
    [self compositedSortAnswerData];
}

- (void)creatquestionTitleNumber
{
    titleNumber.numberOfLines = 0;
    titleNumber.text = self.questionTitleNumber;
    UIFont *fontTt = QUESTION_NUMBER_OF_QUESTIONS_FONT;
    titleNumber.font = fontTt;
    CGSize sizeTt = [self.questionTitleNumber sizeWithFont:fontTt constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleNumber.frame = CGRectMake(0, 15, SFSW, sizeTt.height);
    titleNumber.backgroundColor = [UIColor clearColor];
    [self addSubview:titleNumber];
 }

- (void)creatquestionTitleContent
{
    titleContent.backgroundColor = [UIColor clearColor];
    titleContent.numberOfLines = 0;
    titleContent.text = self.qSort.strQuestion;
    UIFont *fontTt = QUESTION_TOPIC_FONT;
    CGSize sizeTt = [self.qSort.strQuestion sizeWithFont:fontTt constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    titleContent.frame = CGRectMake(0,titleNumber.FSH + 25, SFSW, sizeTt.height);
    titleContent.font = fontTt;
    [self addSubview:titleContent];
}

- (void)creatLine
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, titleContent.FSH + titleNumber.FSH +25, SFSW, 30);
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
    imageView.frame = CGRectMake(0, 0, view.FSW, view.FSH/2);
    [view addSubview:imageView];
    [self addSubview:view];
    [view release];    
}

- (void)compositedSortAnswerData
{
    CGFloat heightMax = 0.0;
    for (int i = 0; i < [self.qSort.vStrTexts count]; i++)
    {
        CGSize sizeTt = [[self.qSort.vStrTexts objectAtIndex:i] sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(SFSW-100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        if ( sizeTt.height > heightMax)
        {
            heightMax = sizeTt.height;
        }
    }
    
    CGFloat H = SFSH - (titleContent.FSH + titleNumber.FSH + 55 + 20) - heightMax * [self.qSort.vStrTexts count];
    CGRect frame ;
    if ((heightMax * [self.qSort.vStrTexts count]) < (SFSH - (titleContent.FSH + titleNumber.FSH + 55 + 20)))
    {
        frame = CGRectMake(15, titleContent.FSH + titleNumber.FSH + 55 + H/2, SFSW-30, heightMax * [self.qSort.vStrTexts count]);
    }else{
        frame = CGRectMake(15, titleContent.FSH + titleNumber.FSH + 55 , SFSW-30, SFSH - (titleContent.FSH + titleNumber.FSH + 55 + 20));
    }
    resultArray = [self.qSort.vSortedList mutableCopy];
    [resultArray setArray:self.qSort.vStrTexts];
    self.answerTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.answerTableView.delegate = self;
    self.answerTableView.dataSource = self;
    self.answerTableView.showsHorizontalScrollIndicator = NO;
    self.answerTableView.showsVerticalScrollIndicator = NO;
    self.answerTableView.backgroundColor = [UIColor clearColor];
    self.answerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:self.answerTableView];
    [self.answerTableView setEditing:YES animated:YES];
}

//打开编辑模式后       按右边的按钮会执行
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self.answerTableView setEditing:editing animated:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightMax = 0.0;
    for (int i = 0; i < [self.qSort.vStrTexts count]; i++)
    {
        CGSize sizeTt = [[self.qSort.vStrTexts objectAtIndex:i] sizeWithFont:QUESTION_ANSWER_FONT constrainedToSize:CGSizeMake(self.frame.size.width-100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        if ( sizeTt.height > heightMax)
        {
            heightMax = sizeTt.height;
        }
        
    }
    return heightMax;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    cell.textLabel.text = [resultArray objectAtIndex:indexPath.row];
    cell.textLabel.font = QUESTION_ANSWER_FONT;
    cell.textLabel.numberOfLines = 0;
   
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isVerifiedAnswer == YES)
    {
       
          if([[resultArray objectAtIndex:indexPath.row]
            isEqualToString:
            [self.qSort.vStrTexts objectAtIndex:
                 [[self.qSort.vSortedList objectAtIndex:indexPath.row] intValue]]])
          {
              cell.backgroundColor = [UIColor greenColor];
          }else{
              cell.backgroundColor = [UIColor redColor];
          }
    
    }else if (isVerifiedAnswer == NO)
    {
    
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark -移动-
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//锁定在一个section里面
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section == proposedDestinationIndexPath.section)
    {
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
}

//从哪一行移动到哪一行  松手完成之后执行
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{    
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:resultArray];
    [newArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [resultArray removeAllObjects];
    [resultArray setArray:newArray];
    [self.answerTableView reloadData];
    [self.delegate isToVerifyAnswer];
}

- (void)rightAnswerVerift
{
    isVerifiedAnswer = YES;
    self.answerTableView.userInteractionEnabled = NO;
    [self.answerTableView reloadData];
}

- (void)isCloseTheInputTextView
{

}

- (void)clearAnswerButton
{
    isVerifiedAnswer = NO;
    [resultArray removeAllObjects];
    resultArray = [self.qSort.vStrTexts mutableCopy];
    self.answerTableView.userInteractionEnabled = YES;
    [self.answerTableView reloadData];
    [self.delegate isToVerifyAnswer];
}

- (void)theAnswerIsToVerifyWhether
{
    if (isVerifiedAnswer == YES )
    {
        [self.delegate isToEliminateAnswer];
    }else if (isVerifiedAnswer == NO)
    {
        [self.delegate isToVerifyAnswer];
    }
}

- (void)dealloc
{
    [self.qSort release];
    [self.answerTableView release];
    [super dealloc];
}
@end
