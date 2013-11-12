//
//  GalleryView.m
//  ImageGesture
//
//  Created by qanzone on 13-9-27.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "GalleryView.h"
#import "CTView.h"
#import "MarkupParser.h"
#import<QuartzCore/QuartzCore.h>

@implementation GalleryView

@synthesize imageArray = _imageArray;
@synthesize gallerySCV = _gallerySCV;
@synthesize pageImageList = _pageImageList;
@synthesize delegate;

- (void)dealloc
{
    [self.gallerySCV release];
    self.gallerySCV = nil;
    [self.imageArray release];
    self.imageArray = nil;
    [self.pageImageList release];
    [tit release];
    [super dealloc];
 }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tit = [[NSMutableString alloc]initWithString:@""];
        imageNum = 0;
    }
    return self;
}


- (void)initIncomingData:(PageImageList *)pageImageList
{
    pImageList = pageImageList;
    self.pageImageList = [[PageImageList1 alloc]init];
    [self.pageImageList setIsSmallImage:pImageList->isSmallImage];
    [self.pageImageList setIsComment:pImageList->isComment];
    self.imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < pImageList->vImages.size(); i++)
    {
        PageImageListSubImage1 *pageSubImage = [[PageImageListSubImage1 alloc]init];
        NSString *imageName = [NSString stringWithUTF8String:pImageList->vImages[i].strImgPath.c_str()];
        if ( pImageList->vImages[i].stImgComment.isRichText == NO)
        {
            [pageSubImage setStImgComment:[NSString stringWithUTF8String:pImageList->vImages[i].stImgComment.strText.c_str()]];
        }else{
            NSMutableString * commentStr = [NSMutableString string];
            [commentStr setString:@""];
            
            for (int j = 0 ; j < pImageList->vImages[i].stImgComment.vTextItemList.size(); j++)
            {
                if (pImageList->vImages[i].stImgComment.vTextItemList[j].pieceType == PAGE_RICH_TEXT_PIECE_TEXT)
                {
                    [commentStr appendString:[NSString stringWithUTF8String:pImageList->vImages[i].stImgComment.vTextItemList[j].strText.c_str()]];
                }
            }
            [pageSubImage setStImgComment:commentStr];
        }
        [pageSubImage setStrImgPath: imageName];
        [self.imageArray addObject:pageSubImage];
        [pageSubImage release];
    }
    [self.pageImageList.vImages setArray:self.imageArray];
 }

- (void)composition
{
    [self initWithSubView:self.frame];
}

- (void)initWithSubView:(CGRect)frame
{
    [self initTitle:frame];
    [self initPageControl:frame];
    [self initSmallImage:frame];
    [self initImageDetail:frame];
    [self initImageScrollView:frame];
} 
#pragma mark - 设置标题
- (void)initTitle:(CGRect)frame
{
    ctv = [[CTView alloc]init];
    if (pImageList->stTitle.isRichText == YES)
    {
        [self isYesRichText:frame];
    }else{
        [self isNoRichText:frame];
    }
    [self addSubview:ctv];
    titHeight = ctv.FSH;
}

- (void)isYesRichText:(CGRect)frame
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    for (int i = 0; i < pImageList->stTitle.vTextItemList.size(); i++)
    {
        switch (pImageList->stTitle.vTextItemList[i].pieceType)
        {
            
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pImageList->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pImageList->stTitle.vTextItemList[i].fontColor.rgbRed,pImageList->stTitle.vTextItemList[i].fontColor.rgbGreen,pImageList->stTitle.vTextItemList[i].fontColor.rgbBlue,pImageList->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pImageList->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pImageList->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pImageList->stTitle.vTextItemList[i].fontSize;
            }
                break;
            default:
                break;
        }
    }
    [p setFont:strFont];
    [p setSize:fontsize];
    [tit setString:string];
    CGSize size = [string sizeWithFont:[UIFont fontWithName:strFont size:fontsize] constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
    ctv.frame = CGRectMake(0, 0, size.width, size.height);
    ctv.backgroundColor = [UIColor clearColor];
    [ctv setAttString:attString];
}

- (void)isNoRichText:(CGRect)frame
{
    UIFont *fontTt = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize sizeTt = [[NSString stringWithUTF8String:pImageList->stTitle.strText.c_str()] sizeWithFont:fontTt constrainedToSize:CGSizeMake(FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    ctv.frame = CGRectMake(0, 0, FSW, sizeTt.height);
    ctv.backgroundColor = [UIColor clearColor];
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    [p setFont:@"Helvetica"];
    [p setSize:15];
    NSAttributedString *attString = [p attrStringFromMarkup:[NSString stringWithFormat:@"<font color=\"0,0,0,255\">%@",[NSString stringWithUTF8String:pImageList->stTitle.strText.c_str()]]];
    [(CTView *)ctv setAttString:attString];
 }

- (void)initImageScrollView:(CGRect)frame
{
    UILabel *labelT = (UILabel *)[self viewWithTag:202];
    self.gallerySCV = [[UIScrollView alloc]init];
    self.gallerySCV.bounces = NO;
    if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == YES)
    {
//        self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH- titHeight-labelT.FSH-55);
//        self.gallerySCV.contentSize = CGSizeMake(FSW*[self.pageImageList.vImages count], FSH- titHeight-labelT.FSH-55);
        
       self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH - titHeight -labelT.FSH -110);
        self.gallerySCV.contentSize = CGSizeMake(FSW*[self.pageImageList.vImages count], FSH - titHeight -labelT.FSH-110);
        
    }else if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == NO)
    {
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH- titHeight-labelT.FSH-55);
        self.gallerySCV.contentSize = CGSizeMake(FSW*[self.pageImageList.vImages count], FSH- titHeight-labelT.FSH-55);
        
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == YES)
    {
//        self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH- titHeight-45);
//        self.gallerySCV.contentSize = CGSizeMake(FSW*[self.pageImageList.vImages count], FSH- titHeight-45);
        
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH - titHeight-10 -15 -labelT.FSH - 80);
        
        self.gallerySCV.contentSize = CGSizeMake(FSW*[self.pageImageList.vImages count], FSH - titHeight - 10 - 15 -labelT.FSH - 80);
        
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == NO)
    {
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH- titHeight-45);
        self.gallerySCV.contentSize = CGSizeMake(FSW*[self.pageImageList.vImages count], FSH- titHeight-45);
    }
    
    self.gallerySCV.backgroundColor = [UIColor clearColor];
    self.gallerySCV.delegate =self;
    [self addSubview:self.gallerySCV];
    self.gallerySCV.pagingEnabled = YES;
    self.gallerySCV.bounces = YES;
    self.gallerySCV.showsHorizontalScrollIndicator = NO;
    self.gallerySCV.showsVerticalScrollIndicator = NO;
    
    for (int i = 0 ; i < [self.pageImageList.vImages count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.gallerySCV.FSW, 0, self.gallerySCV.FSW, self.gallerySCV.FSH) ];
        imageView.tag = 300 + i;
        imageView.userInteractionEnabled = YES;
        PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:i];
        NSString *imagepath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:pageFirst.strImgPath];
        UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
        [imageView setImage:image];
        UITapGestureRecognizer *tapOneGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageView addGestureRecognizer:tapOneGesture];
        [self.gallerySCV addSubview:imageView];
        [imageView release];
    }
}

- (void)initImageDetail:(CGRect)frame
{
    if (self.pageImageList.isComment == YES)
    {
        //图片说明
       UILabel * _mTitleText = [[UILabel alloc]init];
        _mTitleText.tag = 202;
        [_mTitleText setFont:QUESTION_TITLE_FONT];
        NSInteger longStringIndex=0;
        for (int i = 0; i  < [self.pageImageList.vImages count]; i++)
        {
            PageImageListSubImage1 *pageSubImage = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:i];
            if ([pageSubImage.stImgComment length] >= [pageSubImage.stImgComment length])
            {
                longStringIndex = i;
            }else{
                longStringIndex = i+1;
            }
        }
        
        PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:0];
        _mTitleText.text = pageFirst.stImgComment;
        PageImageListSubImage1 *pageSubImage = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:longStringIndex];
        CGSize sizeT = [pageSubImage.stImgComment sizeWithFont:QUESTION_TITLE_FONT constrainedToSize:CGSizeMake(frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        _mTitleText.frame = CGRectMake(0, FSH-30-50-10-sizeT.height, FSW, sizeT.height);
        [_mTitleText setTextAlignment:NSTextAlignmentLeft];
        _mTitleText.numberOfLines = 0;
        [_mTitleText setBackgroundColor:[UIColor clearColor]];
        [_mTitleText setTextColor:[UIColor blackColor]];
        [self addSubview:_mTitleText];
        [_mTitleText release];
     }
}

- (void)initSmallImage:(CGRect)frame
{
    if (self.pageImageList.isSmallImage)
    {
        smallSVC = [[UIScrollView alloc]init];
        if ((60 * [self.pageImageList.vImages count]-10) < FSW)
        {
            smallSVC.frame = CGRectMake((FSW - (60 * [self.pageImageList.vImages count]-10))/2.0, SFSH-80, (60 * [self.pageImageList.vImages count]-10), 50);
        }else{
            smallSVC.frame = CGRectMake(0, SFSH-80, FSW, 50);
        }
        smallSVC.contentSize = CGSizeMake(60 * [self.pageImageList.vImages count]-10, 50);
        smallSVC.pagingEnabled = YES;
        smallSVC.showsHorizontalScrollIndicator = NO;
        smallSVC.showsVerticalScrollIndicator = NO;
        for (int i = 0 ; i < [self.pageImageList.vImages count]; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*60, 0, 50, 50);
            [button addTarget:self action:@selector(smallImage:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0)
            {
                button.selected = YES;
            }else{
            button.selected = NO;
            }
            button.tag = 400+i;
            PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:i];
            NSString *imagepath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:pageFirst.strImgPath];
            UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
            [button setBackgroundImage:image forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:@"g_galleryV_small.png"] forState:UIControlStateNormal];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [[UIColor grayColor] CGColor];
            [button setImage:[UIImage imageNamed:@"g_small_Image_selected.png"] forState:UIControlStateSelected];
            [smallSVC addSubview:button];
        }
        [self addSubview:smallSVC];
    }
}

- (void)smallImage:(UIButton *)button
{
    button.selected = YES;
    imageNum = button.tag - 400;
    [self.gallerySCV setContentOffset:CGPointMake(SFSW * imageNum, 0)];
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:398];
    if (pageControl)
    {
        pageControl.currentPage = imageNum;
    }
    for (int i = 0; i < [self.pageImageList.vImages count]; i++)
    {
        UIButton *but = (UIButton *)[smallSVC viewWithTag:400+i];
        if (button.tag != but.tag)
        {
        but.selected = NO;
        }
    }
}

- (void)initPageControl:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SFSH-20, SFSW, 20)];
    pageControl.currentPage = 0;
    pageControl.tag = 398;
    [pageControl setNumberOfPages:[self.pageImageList.vImages count]];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    pageControl.hidesForSinglePage = NO;
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    [pageControl release];
    
    UIButton *btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUp setImage:[UIImage imageNamed:@"m3.png"] forState:UIControlStateNormal];
    [btnDown setImage:[UIImage imageNamed:@"m2.png"] forState:UIControlStateNormal];
    btnUp.frame = CGRectMake(0, SFSH-20, 20,20);
    btnDown.frame = CGRectMake(SFSW-20, SFSH-20, 20, 20);
    [btnUp addTarget:self action:@selector(upImage:) forControlEvents:UIControlEventTouchUpInside];
    [btnDown addTarget:self action:@selector(downImage:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btnUp];
//    [self addSubview:btnDown];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.delegate makeImageWithContent:self.pageImageList withTagOfTap:gestureRecognizer.view.tag withTitle:tit];
}

//滚动视图停止时候回调函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat aWidth = scrollView.frame.size.width;
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    if (curPageView < 0)
    {
        curPageView = 0;
    }
    imageNum = curPageView;
    PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:curPageView];
    UILabel * _mTitleText = (UILabel *)[self viewWithTag:202];
    if (_mTitleText)
    {
      _mTitleText.text = pageFirst.stImgComment;  
    }
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:398];
    if (pageControl)
    {
      pageControl.currentPage = imageNum;  
    }
    [UIView animateWithDuration:0.3 animations:^{
    [smallSVC setContentOffset:CGPointMake(60 * imageNum, 0)];
    
    for (int i = 0; i < [self.pageImageList.vImages count]; i++)
    {
        UIButton *button = (UIButton *)[smallSVC viewWithTag:400+i];
        if (imageNum != i)
        {
            button.selected = NO;
        }else{
            button.selected = YES;
        }
    }
        }];
}

- (void)upImage:(id)sender
{
    if (imageNum > 0)
    {
        imageNum--;
    }else{
        imageNum = 0;
    }
    [self.gallerySCV setContentOffset:CGPointMake(SFSW * imageNum, 0)];
    PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:imageNum];
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:398];
    pageControl.currentPage = imageNum;
    UILabel * _mTitleText = (UILabel *)[self viewWithTag:202];
    _mTitleText.text  = pageFirst.stImgComment;
    
}

- (void)downImage:(id)sender
{
    if (imageNum >= [self.pageImageList.vImages count] - 1)
    {
        imageNum = [self.pageImageList.vImages count] - 1;
    }else{
        imageNum++;
    }
    
    [self.gallerySCV setContentOffset:CGPointMake(SFSW * imageNum, 0)]; 
    PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:imageNum];
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:398];
    pageControl.currentPage = imageNum;
    UILabel * _mTitleText = (UILabel *)[self viewWithTag:202];
    _mTitleText.text  = pageFirst.stImgComment;
}

@end
