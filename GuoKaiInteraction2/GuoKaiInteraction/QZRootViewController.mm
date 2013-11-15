
//
//  QZRootViewController.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZRootViewController.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>

#import "QZAppDelegate.h"

@interface QZRootViewController ()

@end
static QZRootViewController *shareQZRootVC = nil;
@implementation QZRootViewController

@synthesize bookMarkArray = _bookMarkArray;

+(QZRootViewController *)shareQZRoot
{
    @synchronized(self)
    {
        if (!shareQZRootVC)
            shareQZRootVC = [[QZRootViewController alloc] init];
        return shareQZRootVC;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initSomeData];
    }
        return self;
}

- (void)initSomeData
{
    indexImage = 0;
    isHaveTheMark = NO;
    isHaveTheDownBtn = NO;
    isTheDBNAtTheLeft = NO;
    self.bookMarkArray = [[NSMutableArray alloc]init];
    arrayImage = [[NSMutableArray alloc]init];
}

- (void)loadData
{
    [arrayImage setArray:[DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/imageArray.plist",BOOKNAME]]];
    [self.bookMarkArray setArray:[DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/BookMark.plist",BOOKNAME]]];
}

- (NSArray *)markArrayOfTheBook
{
    return [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/BookMark.plist",BOOKNAME]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self backImage];
    [self createScrollView];
    [self createDBN];
    [self headTopView];
}
- (void)backImage
{
    UIImage *image = [UIImage imageNamed:@"BookBack.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ZERO, ZERO, DW, DH-20)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    [imageView release];
}

- (void)headTopView
{  
    bookMark = [[UIImageView alloc]init];
    bookMark.tag = BOOKMARK_IMAGE_TAG;
    bookMark.hidden = YES;
    bookMark.frame = CGRectMake(DW-30, 0, 20, 44);
    [bookMark setImage:[UIImage imageNamed:@"g_DBN_BookMark.png"]];
    [self.view addSubview:bookMark];
    
    headTopView = [[QZHeadTopView alloc]init];
    headTopView.frame = CGRectMake(0, -100, DW, 44);
    [headTopView composition];
    headTopView.delegate = self;
    [self.view addSubview:headTopView];
}

- (void)showDBN
{
    [UIView animateWithDuration:0.5 animations:^{
        headTopView.frame = CGRectMake(0, 0, DW, 44);
    }];
}

- (void)showDirectory
{
    [self saveAllDataAtTheDBNAppear];
    [self showMenuWithDBN];
}

- (void)addBookMark
{
 [self addBookMarkWithPlist];
}

- (void)addBookMarkWithPlist
{
    bookMark.hidden = NO;
    NSMutableArray *arrayBmark = [[NSMutableArray alloc]init];
    NSArray * array = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/contentDict.plist",BOOKNAME]];
    for (int i = 0; i < [array count]-1; i++)
    {
        if ([[[array objectAtIndex:i] objectAtIndex:1] intValue] == indexImage)
        {
            [arrayBmark addObject:[NSArray arrayWithObjects:[NSString stringWithString:[[array objectAtIndex:i] objectAtIndex:0]],[NSString stringWithFormat:@"%d",indexImage],[self date], nil]];
            break;
        }
        else if ([[[array objectAtIndex:i+1] objectAtIndex:1] intValue] == indexImage && i+1 < [array count]-1)
        {
            [arrayBmark addObject:[NSArray arrayWithObjects:[NSString stringWithString:[[array objectAtIndex:i] objectAtIndex:0]],[NSString stringWithFormat:@"%d",indexImage],[self date], nil]];
            break;
        
        }
        else if([[[array objectAtIndex:i] objectAtIndex:1] intValue] < indexImage && [[[array objectAtIndex:i+1] objectAtIndex:1] intValue] > indexImage && i+1 < [array count]-1)
        {
            [arrayBmark addObject:[NSArray arrayWithObjects:
                                   [NSString stringWithString:[[array objectAtIndex:i] objectAtIndex:0]],[NSString stringWithFormat:@"%d",indexImage],[self date], nil]];
            break;
        }
    }
    if ([arrayBmark count] == 1)
    {
        [self.bookMarkArray addObject:[arrayBmark objectAtIndex:0]];
    }
    [arrayBmark release];
//    书签排序
    [self.bookMarkArray setArray:[self sortWithData:self.bookMarkArray]];
    DataManager *datamanager = [[DataManager alloc]init];
    [self.bookMarkArray writeToFile:[datamanager FileBookMarkPath:BOOKNAME] atomically:YES];
    [datamanager release];
}

- (NSMutableArray *)sortWithData:(NSMutableArray *)array
{
    if ([array count] <= 1)
    {
        return array;
    }
    
    for (int i = 0; i < [array count] - 1; i++)
    {
        for (int j = i; j < [array count]; j++)
        {
            if ([[[array objectAtIndex:i] objectAtIndex:1] integerValue] > [[[array objectAtIndex:j] objectAtIndex:1] integerValue])
            {
                
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}

- (void)deleteBookMark
{
    bookMark.hidden = YES;
    if (self.bookMarkArray)
    {
        for (int i = 0; i < [self.bookMarkArray count]; i++)
        {
            if ([[[self.bookMarkArray objectAtIndex:i] objectAtIndex:1]intValue] == indexImage)
            {
                [self.bookMarkArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    DataManager *datamanager = [[DataManager alloc]init];
    [self.bookMarkArray writeToFile:[datamanager FileBookMarkPath:BOOKNAME] atomically:YES];
    [datamanager release];
}

- (void)isHaveTheBookMark
{
    BOOL isHaveBookMark;
    isHaveBookMark = NO;    
    if (_bookMarkArray)
    {
        for (int i = 0; i < [_bookMarkArray count]; i++)
        {
            if ([[[_bookMarkArray objectAtIndex:i] objectAtIndex:1] intValue] == indexImage)
            {
                isHaveBookMark = YES;
                break;
            }
        }
    }
    
    if (isHaveBookMark)
    {
        bookMark.hidden = NO;
        [headTopView bookMarkYES];
//        isHaveBookMark = YES;
    }else{
        bookMark.hidden = YES;
        [headTopView bookMarkNO];
//        isHaveBookMark = NO;
    }
}

- (void)createScrollView
{
    upAndDown = [[UIScrollView alloc]init];
    upAndDown.tag = UPANDDOWN_ADD_BOOKMARK_SC_TAG;
    upAndDown.panGestureRecognizer.maximumNumberOfTouches = 1;
    upAndDown.panGestureRecognizer.minimumNumberOfTouches = 1;
    upAndDown.frame = CGRectMake(0, 0, DW, DH - 21);
    upAndDown.showsHorizontalScrollIndicator = NO;
    upAndDown.showsVerticalScrollIndicator = NO;
    upAndDown.delegate = self;
    upAndDown.contentSize = CGSizeMake(DW,DH - 20);
    [self.view addSubview:upAndDown];
    [upAndDown release];

    [self upAndDownOnShelfAndDirectory];
    
    gScrollView = [[UIScrollView alloc]init];
    gScrollView.frame = CGRectMake(0, 0, DW, DH-20);
    gScrollView.contentSize = CGSizeMake(DW * 3,DH-20);
    gScrollView.directionalLockEnabled = YES;
    [gScrollView removeGestureRecognizer:gScrollView.pinchGestureRecognizer];
    gScrollView.showsHorizontalScrollIndicator = NO;
    gScrollView.showsVerticalScrollIndicator = NO;
    gScrollView.panGestureRecognizer.maximumNumberOfTouches = 1;
    if ([arrayImage count] > 0 && [arrayImage count] < 3)
    {
        gScrollView.contentSize = CGSizeMake(DW * [arrayImage count],DH-20);
    }
    gScrollView.tag = LEFTANDRIGHT_PAGE_CONTROL_SC_TAG;
    gScrollView.delegate = self;
    gScrollView.pagingEnabled = YES;
    [upAndDown addSubview:gScrollView];
    [self refreshScrollView];
}

- (void)refreshScrollView
{
    [self pageNum:indexImage];
    if (indexImage == 0)
    {
        [gScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else if (indexImage == ([arrayImage count] - 1))
    {
        [gScrollView setContentOffset:CGPointMake(2 * DW, 0)];
    }else{
        [gScrollView setContentOffset:CGPointMake(DW, 0)];
    }
}

- (int)validPageValue:(NSInteger)value
{
    if(value <= 0) value = 0;// value＝1为第一张，value = 0为前面一张
    if(value >= [arrayImage count]-1) value = [arrayImage count]-1;
    
    return value;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    switch (aScrollView.tag)
    {
        case LEFTANDRIGHT_PAGE_CONTROL_SC_TAG:
        {
            int x = aScrollView.contentOffset.x;
            if (x >= DW && indexImage == 0)
            {
                indexImage++;
            }
            if(x >= (2*DW) && indexImage != [arrayImage count]-1)
            {
                indexImage = [self validPageValue:indexImage+1];
                [self refreshScrollView];
            }
            
            
            
            if(x <= 0 && indexImage != 0)
            {
                if (indexImage == [arrayImage count] - 1 && x >= DW)
                {
                    indexImage--;
                }
                indexImage = [self validPageValue:indexImage-1];
                [self refreshScrollView];
            }
            
        }
            break;
            
        default:
            break;
    }
}
- (void)createDBN
{
    QZDirectAndBMarkAndNotesView * gDBNView = [[QZDirectAndBMarkAndNotesView alloc]init];
    gDBNView.alpha = 0.0;
    gDBNView.frame = CGRectMake(-DW/2, 0, DW/2, DH-20);
    gDBNView.tag = QZDIRECTANDBMARKANDNOTESVIEW_TAG;
    gDBNView.delegate =self;
    [gDBNView composition];
    [self.view addSubview:gDBNView];
    [gDBNView release];
}
- (void)openTheSelectedPage:(NSInteger)pageNum
{
    [self hideTheLeftView];
    indexImage = pageNum;
    [self isTheNumberOfPage:indexImage];
    [self refreshScrollView];
}

- (void)pageNum:(NSInteger)pNumber
{
    [self isHaveTheBookMark];
    [self closeTheHeadTopView];
    [self hideTheLeftView];
    [self saveSomeData];
    [self isTheFirstPageORLastPage:pNumber];
}

- (void)saveSomeData
{
    [self saveAllDataAtTheDBNAppear];
    NSArray *subViews = [gScrollView subviews];
    if([subViews count] != 0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)saveAllDataAtTheDBNAppear
{
    QZPageListView *pageListV0 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG-1];
    if (pageListV0)
    {
        [pageListV0 save];
    }
    
    QZPageListView *pageListV1 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV1)
    {
        [pageListV1 save];
    }
    
    QZPageListView *pageListV2 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG+1];
    if (pageListV2)
    {
        [pageListV2 save];
    }
}

//判断是否是第一页还是最后一页
- (void)isTheFirstPageORLastPage:(NSInteger)pNumber
{
    if (pNumber < 2)
    {
        QZPageListView *pageListView1 = [[QZPageListView alloc]init];
        pageListView1.frame = CGRectMake(ZERO , ZERO , DW , DH-20);
        pageListView1.tag = PAGELISTVIEW_ON_QZROOT_TAG+1;
        pageListView1.delegate = self;
        [pageListView1 setPageNumber:0];
        [pageListView1 initIncomingData:[arrayImage objectAtIndex:0]];
        [pageListView1 composition];
        [gScrollView addSubview:pageListView1];
        [pageListView1 release];
        
        QZPageListView *pageListView = [[QZPageListView alloc]init];
        pageListView.frame = CGRectMake(DW , ZERO , DW , DH-20);
        pageListView.tag = PAGELISTVIEW_ON_QZROOT_TAG;
        pageListView.delegate = self;
        [pageListView setPageNumber:1];
        [pageListView initIncomingData:[arrayImage objectAtIndex:1]];
        [pageListView composition];
        [gScrollView addSubview:pageListView];
        [pageListView release];
        
        QZPageListView *pageListView2 = [[QZPageListView alloc]init];
        pageListView2.frame = CGRectMake(DW*2 , ZERO , DW , DH-20);
        pageListView2.tag = PAGELISTVIEW_ON_QZROOT_TAG+1;
        pageListView2.delegate = self;
        [pageListView2 setPageNumber:2];
        [pageListView2 initIncomingData:[arrayImage objectAtIndex:2]];
        [pageListView2 composition];
        [gScrollView addSubview:pageListView2];
        [pageListView2 release];
        
    }else if(pNumber >= [arrayImage count]-2){
        QZPageListView *pageListView1 = [[QZPageListView alloc]init];
        pageListView1.frame = CGRectMake(ZERO , ZERO , DW , DH-20);
        pageListView1.tag = PAGELISTVIEW_ON_QZROOT_TAG+1;
        pageListView1.delegate = self;
        [pageListView1 setPageNumber:[arrayImage count] - 3];
        [pageListView1 initIncomingData:[arrayImage objectAtIndex:[arrayImage count]-3]];
        [pageListView1 composition];
        [gScrollView addSubview:pageListView1];
        [pageListView1 release];
        
        QZPageListView *pageListView = [[QZPageListView alloc]init];
        pageListView.frame = CGRectMake(DW , ZERO , DW , DH-20);
        pageListView.tag = PAGELISTVIEW_ON_QZROOT_TAG;
        pageListView.delegate = self;
        [pageListView setPageNumber:[arrayImage count] - 2];
        [pageListView initIncomingData:[arrayImage objectAtIndex:[arrayImage count]-2]];
        [pageListView composition];
        [gScrollView addSubview:pageListView];
        [pageListView release];
        
        QZPageListView *pageListView2 = [[QZPageListView alloc]init];
        pageListView2.frame = CGRectMake(DW*2 , ZERO , DW , DH-20);
        pageListView2.tag = PAGELISTVIEW_ON_QZROOT_TAG+1;
        pageListView2.delegate = self;
        [pageListView2 setPageNumber:[arrayImage count] - 1];
        [pageListView2 initIncomingData:[arrayImage objectAtIndex:[arrayImage count]-1]];
        [pageListView2 composition];
        [gScrollView addSubview:pageListView2];
        [pageListView2 release];
    }else{
        QZPageListView *pageListView1 = [[QZPageListView alloc]init];
        pageListView1.frame = CGRectMake(ZERO , ZERO , DW , DH-20);
        pageListView1.tag = PAGELISTVIEW_ON_QZROOT_TAG+1;
        pageListView1.delegate = self;
        [pageListView1 setPageNumber:pNumber-1];
        [pageListView1 initIncomingData:[arrayImage objectAtIndex:pNumber-1]];
        [pageListView1 composition];
        [gScrollView addSubview:pageListView1];
        [pageListView1 release];
        
        QZPageListView *pageListView = [[QZPageListView alloc]init];
        pageListView.frame = CGRectMake(DW , ZERO , DW , DH-20);
        pageListView.tag = PAGELISTVIEW_ON_QZROOT_TAG;
        pageListView.delegate = self;
        [pageListView setPageNumber:pNumber];
        [pageListView initIncomingData:[arrayImage objectAtIndex:pNumber]];
        [pageListView composition];
        [gScrollView addSubview:pageListView];
        [pageListView release];
        
        QZPageListView *pageListView2 = [[QZPageListView alloc]init];
        pageListView2.frame = CGRectMake(DW*2 , ZERO , DW , DH-20);
        pageListView2.tag = PAGELISTVIEW_ON_QZROOT_TAG+1;
        pageListView2.delegate = self;
        [pageListView2 setPageNumber:pNumber+1];
        [pageListView2 initIncomingData:[arrayImage objectAtIndex:pNumber+1]];
        [pageListView2 composition];
        [gScrollView addSubview:pageListView2];
        [pageListView2 release];
    }
}

- (void)saveDate
{
    
    QZPageListView *pageListV0 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG-1];
    if (pageListV0)
    {
        [pageListV0 save];
    }
    
    QZPageListView *pageListV1 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV1)
    {
        [pageListV1 save];
    }
    
    QZPageListView *pageListV2 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG+1];
    if (pageListV2)
    {
        [pageListV2 save];
    }
}

- (void)up:(id)sender
{
    if (indexImage > 0)
    {
        indexImage--;
        [self pageNum:indexImage];
        [self refreshScrollView];
        [self pageAnimationLeft];
    }
}

- (void)pageAnimationLeft
{
    CATransition * si = [[CATransition alloc]init];
    si.type = kCATransitionPush;
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        si.subtype = kCATransitionFromTop;
    }else if (self.interfaceOrientation ==  UIInterfaceOrientationLandscapeRight){
        si.subtype = kCATransitionFromBottom;
    }
    si.duration = 0.5;
    [self.view.layer addAnimation:si forKey:nil];
    [si release];
}

- (void)down:(id)sender
{
    if (indexImage < [arrayImage count]-1)
    {
        indexImage++;
        [self refreshScrollView];
        [self pageAnimationRight];
    }
}

- (void)pageAnimationRight
{
    CATransition * si = [[CATransition alloc]init];
    si.type = kCATransitionPush;
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        si.subtype = kCATransitionFromBottom;
    }else if (self.interfaceOrientation ==  UIInterfaceOrientationLandscapeRight){
        si.subtype = kCATransitionFromTop;
    }
    si.duration = 0.5;
    [self.view.layer addAnimation:si forKey:nil];
    [si release];
}

- (void)skipPage:(QZ_INT)pageNum
{
    indexImage = pageNum;
    [self isTheNumberOfPage:indexImage];
    [self refreshScrollView];
    CATransition * si = [[CATransition alloc]init];
    si.type = @"rippleEffect";
    si.subtype = kCATransitionFromTop;
    si.duration = 0.5;
    [self.view.layer addAnimation:si forKey:nil];
    [si release];
}

//判断点击的页码，当前显示
- (void)isTheNumberOfPage:(NSInteger)pageNum
{
    NSInteger pageCount = [arrayImage count];
    NSInteger lastPageNum = pageCount - 1;
    if (pageNum == 0)
    {
        [gScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else if (pageNum == 1 || pageNum == lastPageNum - 1)
    {
        [gScrollView setContentOffset:CGPointMake(gScrollView.FSW, 0)];
    }
    else if (pageNum == lastPageNum)
    {
        [gScrollView setContentOffset:CGPointMake(gScrollView.FSW*2, 0)];
    }
}

- (void)showMenuWithDBN
{
    QZDirectAndBMarkAndNotesView * gDBNView = (QZDirectAndBMarkAndNotesView *) [self.view viewWithTag:QZDIRECTANDBMARKANDNOTESVIEW_TAG];
    QZPageListView *pageListV = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    QZPageListView *pageListV2 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG-1];
    QZPageListView *pageListV3 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG+1];
    
    [UIView animateWithDuration:0.2 animations:^{
        if (pageListV)
        {
            [pageListV closeAllView];
            [pageListV isNowOpenDBN];
        }
        if (pageListV2)
        {
            [pageListV2 closeAllView];
            [pageListV2 isNowOpenDBN];
        }
        if (pageListV3)
        {
            [pageListV3 closeAllView];
            [pageListV3 isNowOpenDBN];
        }
        
        if (gDBNView)
        {
            upAndDown.frame = CGRectMake(DW/2, 0, DW, DH-21);
            gDBNView.frame = CGRectMake(0, 0, DW/2, DH-20);
            gDBNView.alpha = 1.0;
            isTheDBNAtTheLeft = YES;
        }
    }];    
}

- (void)closeTheHeadTopView
{
    if (headTopView)
    {
        headTopView.frame = CGRectMake(0, -100, DW, 44);
    }
}

- (void)hideTheLeftView
{
    [UIView animateWithDuration:0.5 animations:^{
        if (upAndDown)
        {
            upAndDown.frame = CGRectMake(0, 0, DW, DH-21);
            isTheDBNAtTheLeft = NO;
        }
        QZDirectAndBMarkAndNotesView * gDBNView = (QZDirectAndBMarkAndNotesView *) [self.view viewWithTag:QZDIRECTANDBMARKANDNOTESVIEW_TAG];
        if (gDBNView)
        {
             gDBNView.frame = CGRectMake(-DW/2, 0, DW/2, DH-20);
             gDBNView.alpha = 0.0;
        }
    }];

}
#pragma mark - 题目在拖动时，禁止滚动视图滚动
- (void)pageListViewOfSupSCStartDrag
{
    gScrollView.scrollEnabled = YES;
}

- (void)pageListViewOfSupSCStopDrag
{
   gScrollView.scrollEnabled = NO;
}


#pragma mark - 画廊显示
- (void)initImageData:(PageImageList1 *)pageImageList
{
    pImageList = [[PageImageList1 alloc]init];
    [pImageList setIsComment:pageImageList.isComment];
    [pImageList setIsSmallImage:pageImageList.isSmallImage];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [pageImageList.vImages count]; i++)
    {
        PageImageListSubImage1 *pImageListSub = (PageImageListSubImage1 *)[pageImageList.vImages objectAtIndex:i];
        
        PageImageListSubImage1 *pImageListNewSub = [[PageImageListSubImage1 alloc]init];
        [pImageListNewSub setStImgComment:pImageListSub.stImgComment];
        [array addObject:pImageListNewSub];
        [pImageListNewSub release];
    }
    
    [pImageList setVImages:array];
    [array release];
}

- (void)makeImageList:(PageImageList1 *)pageImageList withTagOfTap:(NSInteger)tapTag withTitle:(NSString *)titleName
{
    [self initImageData:pageImageList];
    
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(ZERO,ZERO, DW , DH-20)];
    bigView.tag = HUALANG_BCAKVIEW_TAG;
    bigView.backgroundColor = [UIColor blackColor];
    
    UIScrollView *sCV = [[UIScrollView alloc]initWithFrame:CGRectMake(ZERO, ZERO , DW, DH-20)];
    sCV.backgroundColor = [UIColor clearColor];
    sCV.contentSize = CGSizeMake(DW*[pageImageList.vImages count], DH-20);
    sCV.delegate =self;
    sCV.tag = HUALANG_SC_TAG;
    [bigView addSubview:sCV];
    sCV.pagingEnabled = YES;
    sCV.showsHorizontalScrollIndicator = NO;
    sCV.showsVerticalScrollIndicator = NO;
    [sCV setContentOffset:CGPointMake(DW * (tapTag-300), 0)];
    
    imageListCount = [pageImageList.vImages count];
    for (int i = 0 ; i < imageListCount; i++)
    {
        PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[pageImageList.vImages objectAtIndex:i];
        NSString *imagepath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:pageFirst.strImgPath];
        UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*sCV.FSW + (DW-image.size.width)/2, (DH - 20 - image.size.height)/2 , image.size.width, image.size.height)];
        imageView.userInteractionEnabled = YES;
        [imageView setImage:image];
        [sCV addSubview:imageView];
        [imageView release];
    }
    
    UIView *titleHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DW, 44)];
    titleHead.backgroundColor = [UIColor blackColor];
    titleHead.tag = 110;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 24, 24);
    [button setBackgroundImage:[UIImage imageNamed:@"g_close_image@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressCloseBigImage:) forControlEvents:UIControlEventTouchUpInside];
    [titleHead addSubview:button];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DW, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:titleName];
    label.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:18];
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
    [self.view addSubview:bigView];
    [titleHead release];
    
    UIView *footView = [[UIView alloc]init];;
    footView.backgroundColor = [UIColor blackColor];
    UILabel *footLabel = [[UILabel alloc]init];
    footLabel.tag = HUALANG_FOOTLABEL_TAG;
    footLabel.backgroundColor = [UIColor clearColor];
    
    if (pageImageList.isComment == YES )
    {
        PageImageListSubImage1 *pageSubimage = [pageImageList.vImages objectAtIndex:tapTag-300];
        UIFont *fontt = [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:16];
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
    UIView *view = (UIView *)[self.view viewWithTag:HUALANG_BCAKVIEW_TAG];
    if (view)
    {
        [view removeFromSuperview];
    }
}

#pragma mark - 单张图片
- (void)makeOneImageOfTap:(NSString *)imagePath withImageName:(NSString *)imageName
{
    [UIView animateWithDuration:0.5 animations:^{
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(ZERO, ZERO, DW, DH-20)];
        backView.tag = IMAGEOFONE;
        backView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:backView];
        
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake((DW-image.size.width)/2, (DH-20-image.size.height)/2, image.size.width, image.size.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 20, 24, 24);
    [button setBackgroundImage:[UIImage imageNamed:@"g_close_image@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressCloseImage:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
        [backView addSubview:imageView];
    [imageView release];
        
        UILabel *imageNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DW, 44)];
        imageNameL.font = [UIFont fontWithName:@"Helvetica" size:15];
        imageNameL.textColor = [UIColor whiteColor];
        imageNameL.backgroundColor = [UIColor clearColor];
        imageNameL.textAlignment = NSTextAlignmentCenter;
        imageNameL.text = imageName;
        [backView addSubview:imageNameL];
        [imageNameL release];
        [backView release];
        }];
 }

- (void)pressCloseImage:(UIButton *)button
{
    UIView *imageView = (UIView *)[self.view viewWithTag:IMAGEOFONE];
    if (imageView)
    {
        [imageView removeFromSuperview];
        imageView = nil;
    }
}

#pragma mark - 滚动操作

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeTheHeadTopView];//关闭头上的标题栏
    if (isTheDBNAtTheLeft)
    {
        [self hideTheLeftView];//关闭左边的目录等视图
        return;
    }
    switch (scrollView.tag)
    {
        case LEFTANDRIGHT_PAGE_CONTROL_SC_TAG:
        {
            isSCHaveBookMark = bookMark.hidden;
            
            
            bookMark.hidden = YES;
        }
            break;
            
            case UPANDDOWN_ADD_BOOKMARK_SC_TAG:
        {
            [self makeTheBookMark];
        }
            break;
        default:
            break;
    }
}

//书签处理
- (void)makeTheBookMark
{
    QZPageListView *pageListV = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV)
    {
        [pageListV isHaveTheBookMarkOnPage:bookMark.hidden];
    }
    
    QZPageListView *pageListV0 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV0)
    {
        [pageListV0 isHaveTheBookMarkOnPage:bookMark.hidden];
    }
    QZPageListView *pageListV2 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV2)
    {
        [pageListV2 isHaveTheBookMarkOnPage:bookMark.hidden];
    }

}

- (BOOL)closeTheBtnOfTheDown
{
    if (isHaveTheDownBtn)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [upAndDown setContentInset:UIEdgeInsetsMake(0,0,0,0)];
            gScrollView.scrollEnabled = YES;
            isHaveTheDownBtn = NO;
        }];
        return YES;
    }
    return NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    switch (scrollView.tag)
    {
        case LEFTANDRIGHT_PAGE_CONTROL_SC_TAG:
        {
            if ([self isBookMark])
            {
                bookMark.hidden = NO;
                for (int i = 0; i < [gScrollView.subviews count]; i++)
                {
                    QZPageListView *pListView = [gScrollView.subviews objectAtIndex:i];
                    if (pListView.pageNumber == indexImage)
                    {
                        [pListView isNoHaveBookMark];
                    }
                }
            }
            
        }
            break;
        case UPANDDOWN_ADD_BOOKMARK_SC_TAG:
        { 
            if (scrollView.contentOffset.y > 100)
            {
                [scrollView setContentInset:UIEdgeInsetsMake(0,0,100,0)];
                gScrollView.scrollEnabled = NO;
                isHaveTheDownBtn = YES;
            }
            else if (scrollView.contentOffset.y < -100)
            {
                if ([self isBookMark])
                {
                    [self deleteBookMark];
                    [headTopView bookMarkNO];
                }else{
                    [self addBookMark];
                    [headTopView  bookMarkYES];
                }
            }
            else
            {
                [self closeTheDownBtnOfDirectoryAndBookShelf];
            }
            
        }
            break;
            case HUALANG_SC_TAG:
        {
            CGFloat aWidth = scrollView.frame.size.width;
            NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
            if (curPageView < 0)
            {
                curPageView = 0;
            }else if (curPageView > imageListCount-1){
                curPageView = imageListCount-1;
            }
            PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[pImageList.vImages objectAtIndex:curPageView];
            UIView *bigView = (UIView *)[self.view viewWithTag:HUALANG_BCAKVIEW_TAG];
            UILabel * footLabel = (UILabel *)[bigView viewWithTag:HUALANG_FOOTLABEL_TAG];
            if (footLabel)
            {
                [footLabel setText:pageFirst.stImgComment];
            }
         }
            break;
        default:
            break;
    }
}

- (void)theBookMarkisHaveOnThePage
{
    QZPageListView *pageListV0 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV0)
    {
        [pageListV0 isNoHaveBookMark];
    }
    QZPageListView *pageListV1 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV1)
    {
        [pageListV1 isNoHaveBookMark];
    }
    QZPageListView *pageListV2 = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV2)
    {
        [pageListV2 isNoHaveBookMark];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        bookMark.hidden = isSCHaveBookMark;
    }];
}

- (void)closeTheDownBtnOfDirectoryAndBookShelf
{
    [UIView animateWithDuration:0.5 animations:^{
        [upAndDown setContentInset:UIEdgeInsetsMake(0,0,0,0)];
        gScrollView.scrollEnabled = YES;
        isHaveTheDownBtn = NO;
    }];
}

- (BOOL)isBookMark
{
    BOOL isHaveBookMark;
    isHaveBookMark = NO;
    
    if ([_bookMarkArray count] > 0)
    {
        for (int i = 0; i < [_bookMarkArray count]; i++)
        {
            if ([[[_bookMarkArray objectAtIndex:i] objectAtIndex:1] intValue] == indexImage)
            {
                isHaveBookMark = YES;
                break;
            }
        }
    }
        
    return isHaveBookMark;
}

- (void)PageControl
{
    

}

- (NSString *)date
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd(EEE) k:mm:ss"];
    NSString *strDate = [formatter stringFromDate:date];
    [formatter release];
    return strDate;
}

- (void)dealloc
{
    [self.bookMarkArray release];
    [arrayImage release];
    [upAndDown release];
    [gScrollView release];
    [headTopView release];
    [bookMark release];
    [super dealloc];
}

#pragma mark - 主要显示了上拉的书架和目录按钮
- (void)upAndDownOnShelfAndDirectory
{
    UIButton * buttonOfShelf = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonOfShelf setImage:[UIImage imageNamed:@"g_BookShelf.png"] forState:UIControlStateNormal];
    buttonOfShelf.tag = BACKTHEBOOKSHELF;
    buttonOfShelf.frame = CGRectMake(432, 768, 60, 60);
    [upAndDown addSubview:buttonOfShelf];
    [buttonOfShelf addTarget:self action:@selector(pressBtnOfShelf:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonOfDirectory = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonOfDirectory setImage:[UIImage imageNamed:@"g_BookDirectory.png"] forState:UIControlStateNormal];
    buttonOfDirectory.tag = BACKTHEDIRECTORY;
    buttonOfDirectory.frame = CGRectMake(532, 768, 60, 60);
    [upAndDown addSubview:buttonOfDirectory];
    [buttonOfDirectory addTarget:self action:@selector(pressBtnOfShelf:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressBtnOfShelf:(UIButton *)button
{
    switch (button.tag)
    {
        case BACKTHEDIRECTORY:
        {
            [self saveAllDataAtTheDBNAppear];
            
            [UIView animateWithDuration:0.1 animations:^{
                [upAndDown setContentInset:UIEdgeInsetsMake(0,0,0,0)];
                gScrollView.scrollEnabled = YES;
                isHaveTheDownBtn = NO;
            } completion:^(BOOL finished) {
                [self showMenuWithDBN];
            }];
            
            
         }
            break;
        case BACKTHEBOOKSHELF:
        {
            
        }
            break;
        default:
            break;
    }
}
 @end
