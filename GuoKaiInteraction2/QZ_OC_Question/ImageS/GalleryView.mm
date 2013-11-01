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

@implementation GalleryView

@synthesize imageArray = _imageArray;
@synthesize gallerySCV = _gallerySCV;
@synthesize pageImageList = _pageImageList;

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
    isBigScreen = NO;
    [self initTitle:frame];
    [self initImageDetail:frame];
    [self initPageControl:frame];
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
    
    if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == YES)
    {
        
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH- titHeight-labelT.FSH-55);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-labelT.frame.size.height-55);
        
//       self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight -labelT.frame.size.height-110);
//        self.gallerySCV.contentSize = CGSizeMake(FSW*[self.pageImageList.vImages count], FSH - titHeight -labelT.FSH-110);
        
    }else if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == NO)
    {
        
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,FSW, FSH- titHeight-labelT.FSH-55);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-labelT.frame.size.height-55);
        
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == YES)
    {
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight-45);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-45);
        
//        self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight-10 -15 -labelT.frame.size.height-30);
//        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-10 -15 -labelT.frame.size.height-30);
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == NO)
    {
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight-45);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-45);
    }
    
    self.gallerySCV.backgroundColor = [UIColor clearColor];
    self.gallerySCV.delegate =self;
    [self addSubview:self.gallerySCV];
    self.gallerySCV.pagingEnabled = YES;
    self.gallerySCV.showsHorizontalScrollIndicator = NO;
    self.gallerySCV.showsVerticalScrollIndicator = NO;
    
    
    for (int i = 0 ; i < [self.pageImageList.vImages count]; i++)
    {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.gallerySCV.frame.size.width, 0, self.gallerySCV.frame.size.width, self.gallerySCV.frame.size.height) ];
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
        _mTitleText.frame = CGRectMake(0, FSH-30-sizeT.height, FSW, sizeT.height);
        [_mTitleText setTextAlignment:NSTextAlignmentLeft];
        _mTitleText.numberOfLines = 0;
        [_mTitleText setBackgroundColor:[UIColor clearColor]];
        [_mTitleText setTextColor:[UIColor blackColor]];
        [self addSubview:_mTitleText];
        [_mTitleText release];
     }else if (self.pageImageList.isComment == NO){
        NSLog(@"没有说明！！！！！");
    }
}

- (void)initPageControl:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SFSH-20, SFSW, 20)];
    pageControl.currentPage = 0;
    pageControl.tag = 398;
    pageControl.backgroundColor = [UIColor lightGrayColor];
    [pageControl addTarget:self action:@selector(pageControlWithSC:) forControlEvents:UIControlEventValueChanged];
    [pageControl setNumberOfPages:[self.pageImageList.vImages count]];
    pageControl.hidesForSinglePage = NO;
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    [pageControl release];
    
    UIButton *btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUp setImage:[UIImage imageNamed:@"a1.png"] forState:UIControlStateNormal];
    [btnDown setImage:[UIImage imageNamed:@"a2.png"] forState:UIControlStateNormal];
    btnUp.frame = CGRectMake(0, SFSH-20, 20,20);
    btnDown.frame = CGRectMake(SFSW-20, SFSH-20, 20, 20);
    [btnUp addTarget:self action:@selector(upImage:) forControlEvents:UIControlEventTouchUpInside];
    [btnDown addTarget:self action:@selector(downImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnUp];
    [self addSubview:btnDown];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    isBigScreen = YES;
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(ZERO,ZERO, DW , DH-20)];
    bigView.tag = 999;
    bigView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapOneGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageBig:)];
    [bigView addGestureRecognizer:tapOneGesture];
    
    UIScrollView *sCV = [[UIScrollView alloc]initWithFrame:CGRectMake(ZERO, ZERO , DW, DH-20)];
    sCV.backgroundColor = [UIColor clearColor];
    sCV.contentSize = CGSizeMake(DW*[self.pageImageList.vImages count], DH-20);
    sCV.delegate =self;
    [bigView addSubview:sCV];
    sCV.pagingEnabled = YES;
    sCV.showsHorizontalScrollIndicator = NO;
    sCV.showsVerticalScrollIndicator = NO;
    [sCV setContentOffset:CGPointMake(DW * (gestureRecognizer.view.tag-300), 0)];
    
    for (int i = 0 ; i < [self.pageImageList.vImages count]; i++)
    {
        PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*sCV.frame.size.width, 0, sCV.frame.size.width, sCV.frame.size.height) ];
        imageView.userInteractionEnabled = YES;
        NSString *imagepath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:pageFirst.strImgPath];
        UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
        [imageView setImage:image];
        [sCV addSubview:imageView];
        [imageView release];
    }
    
    UIView *titleHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DW, 44)];
    titleHead.backgroundColor = [UIColor blackColor];
    titleHead.tag = 110;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"关闭@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressCloseBigImage:) forControlEvents:UIControlEventTouchUpInside];
    [titleHead addSubview:button];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(74, 0, DW, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:tit];
    label.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:30];
    CGSize size = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(DW-74, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    label.font = font;
    if (size.width <= DW-74)
    {
        label.textAlignment = NSTextAlignmentCenter;
    }else{
        label.textAlignment = NSTextAlignmentLeft;
    }
    [titleHead addSubview:label];
    [label release];
    [bigView addSubview:titleHead];
    [self.superview addSubview:bigView];
    [titleHead release];
  
    UIView *footView = [[UIView alloc]init];;
    footView.backgroundColor = [UIColor blackColor];
    UILabel *footLabel = [[UILabel alloc]init];
    footLabel.tag = HUALANG_FOOTLABEL_TAG;
    footLabel.backgroundColor = [UIColor clearColor];
    
 if (self.pageImageList.isComment == YES )
    {
        PageImageListSubImage1 *pageSubimage = [self.pageImageList.vImages objectAtIndex:gestureRecognizer.view.tag-300];
        UIFont *fontt = [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:20];
        CGSize sizet = [pageSubimage.stImgComment sizeWithFont:fontt constrainedToSize:CGSizeMake(DW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        footLabel.text = pageSubimage.stImgComment;
        footLabel.textColor = [UIColor whiteColor];
        footLabel.font = fontt;
        footLabel.numberOfLines = 0;
        footLabel.frame = CGRectMake(0,0, DW, sizet.height);
        [footView addSubview:footLabel];
    }
    
    footView.frame = CGRectMake(0, DH-footLabel.FSH-20, DW, footLabel.FSH+20);;
    [bigView addSubview:footView];
    [footLabel release];
    [footView release];
    [bigView release];
    [sCV release];
}

- (void)pressCloseBigImage:(id)sender
{
    isBigScreen = NO;
    UIView *view = (UIView *)[self.superview viewWithTag:999];
    [view removeFromSuperview];
}

static int indexNum;
- (void)tapImageBig:(UITapGestureRecognizer *)gestureRecognizer
{

    if (indexNum%2 == 1)
    {
        UIView *titleHead = (UIView *)[self viewWithTag:110];
        titleHead.alpha = 0.0;
    }
    indexNum++;
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
    if (isBigScreen == NO)
    {
        _mTitleText.text = pageFirst.stImgComment;
        UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:398];
        pageControl.currentPage = imageNum;
    }else{
        UILabel * footLabel = (UILabel *)[self.superview viewWithTag:HUALANG_FOOTLABEL_TAG];
        [footLabel setText:pageFirst.stImgComment];
    }
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
