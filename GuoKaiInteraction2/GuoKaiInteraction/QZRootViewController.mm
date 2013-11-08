
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

@interface QZRootViewController ()

@end

@implementation QZRootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        indexImage = 0;
        isHaveTheMark = NO;
        arrayImage = [[NSMutableArray alloc]init];
        self.view.backgroundColor = [UIColor underPageBackgroundColor];
    }
        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createScrollView];
    [arrayImage setArray:[DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/imageArray.plist",BOOKNAME]]];
    indexImage = 7;
    [self pageNum:indexImage];
    [self createDBN];
    [self headTopView];
}

- (void)headTopView
{
    headTopView = [[QZHeadTopView alloc]init];
    headTopView.frame = CGRectMake(0, -100, DW, 44);
    [headTopView composition];
    headTopView.delegate = self;
    [self.view addSubview:headTopView];
    
    bookMark = [[UIImageView alloc]init];
    bookMark.tag = BOOKMARK_IMAGE_TAG;
    bookMark.hidden = YES;
    bookMark.frame = CGRectMake(DW-30, 0, 20, 44);
    [bookMark setImage:[UIImage imageNamed:@"g_DBN_BookMark_selected@2x.png"]];
    [self.view addSubview:bookMark];
    [self.view bringSubviewToFront:headTopView];
}

- (void)showDBN
{
    [UIView animateWithDuration:0.5 animations:^{
        headTopView.frame = CGRectMake(0, 0, DW, 44);
    }];
}

- (void)showDirectory
{
    bookMark.hidden = NO;
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
            [arrayBmark addObject:[NSArray arrayWithObjects:[NSString stringWithString:[[array objectAtIndex:i] objectAtIndex:0]],[[array objectAtIndex:i] objectAtIndex:1],[self date], nil]];
            break;
        }else if([[[array objectAtIndex:i] objectAtIndex:1] intValue] < indexImage && [[[array objectAtIndex:i+1] objectAtIndex:1] intValue] > indexImage)
        {
            [arrayBmark addObject:[NSArray arrayWithObjects:
              [NSString stringWithString:[[array objectAtIndex:i] objectAtIndex:0]],[NSString stringWithFormat:@"%d",indexImage],[self date], nil]];
            break;
        }
    }
    
    BOOL isHaveBookMark;
    isHaveBookMark = NO;
    NSArray *arrayBook = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/BookMark.plist",BOOKNAME]];
    if (arrayBook)
    {
        for (int i = 0; i < [arrayBook count]; i++)
        {
            if ([[[arrayBook objectAtIndex:i] objectAtIndex:1] intValue] == indexImage)
            {
                isHaveBookMark = YES;
                break;
            }else{
                [arrayBmark addObject:[arrayBook objectAtIndex:i]];
            }
        }
    }
  [arrayBmark setArray:[self sortWithData:arrayBmark]];
    if (!isHaveBookMark)
    {
        DataManager *dataManager = [[DataManager alloc]init];
        [arrayBmark writeToFile:[dataManager FileBookMarkPath:BOOKNAME] atomically:YES];
        [dataManager release];
    }
}

- (NSMutableArray *)sortWithData:(NSMutableArray *)array
{
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
    NSArray *array = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/BookMark.plist",BOOKNAME]];
    NSMutableArray *arrayBM = [NSMutableArray array];
    [arrayBM setArray:array];
    for (int i = 0; i < [array count]; i++)
    {
        if ([[[array objectAtIndex:i] objectAtIndex:1]intValue] == indexImage)
        {
            [arrayBM removeObjectAtIndex:i];
            break;
        }
    }
    DataManager *dataManager = [[DataManager alloc]init];
    [arrayBM writeToFile:[dataManager FileBookMarkPath:BOOKNAME] atomically:YES];
    [dataManager release];
}

- (void)isHaveTheBookMark
{
    BOOL isHaveBookMark;
    isHaveBookMark = NO;
    NSArray *arrayBook = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/BookMark.plist",BOOKNAME]];
    if (arrayBook)
    {
        for (int i = 0; i < [arrayBook count]; i++)
        {
            if ([[[arrayBook objectAtIndex:i] objectAtIndex:1] intValue] == indexImage)
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
        isHaveBookMark = YES;
    }else{
        bookMark.hidden = YES;
        [headTopView bookMarkNO];
        isHaveBookMark = NO;
    }
}

- (void)createScrollView
{
    upAndDown = [[UIScrollView alloc]init];
    upAndDown.tag = UPANDDOWN_ADD_BOOKMARK_SC_TAG;
    upAndDown.frame = CGRectMake(0, 0, DW, DH - 21);
    upAndDown.delegate = self;
    upAndDown.contentSize = CGSizeMake(DW,DH - 20);
    [self.view addSubview:upAndDown];
    [upAndDown release];
    
    gScrollView = [[UIScrollView alloc]init];
    gScrollView.frame = CGRectMake(0, 0, DW-1, DH-20);
    gScrollView.tag = LEFTANDRIGHT_PAGE_CONTROL_SC_TAG;
    gScrollView.delegate = self;
    gScrollView.contentSize = CGSizeMake(DW,DH - 20);
    [upAndDown addSubview:gScrollView];
}

- (void)createDBN
{
    QZDirectAndBMarkAndNotesView * gDBNView = [[QZDirectAndBMarkAndNotesView alloc]init];
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
    [self pageNum:indexImage];
}

- (void)pageNum:(NSInteger)pNumber
{
    [self isHaveTheBookMark];
    [self closeTheView];
    [self hideTheLeftView];
    QZPageListView *pageListV = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV)
    {
        [pageListV save];
        [pageListV removeFromSuperview];
        pageListV = nil;
    }
    
    QZPageListView *pageListView = [[QZPageListView alloc]init];
    pageListView.frame = CGRectMake(ZERO , ZERO , DW , DH-20);
    pageListView.tag = PAGELISTVIEW_ON_QZROOT_TAG;
    pageListView.delegate = self;
    [pageListView setPageNumber:indexImage];
    [pageListView initIncomingData:[arrayImage objectAtIndex:pNumber]];
    [pageListView composition];
    [gScrollView addSubview:pageListView];
    [pageListView release];
}

- (void)saveDate
{
    QZPageListView *pageListV = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    if (pageListV)
    {
        [pageListV save];
    }
}

- (void)up:(id)sender
{
    if (indexImage > 0)
    {
        indexImage--;
        [self pageNum:indexImage];
        CATransition * si = [[CATransition alloc]init];
        si.type = @"pageCurl";
        si.subtype = kCATransitionFromRight;
        si.duration = 0.5;
        [self.view.layer addAnimation:si forKey:nil];
        [si release];
    }
    
}

- (void)down:(id)sender
{
    if (indexImage < [arrayImage count]-1)
    {
        indexImage++;
        [self pageNum:indexImage];
        CATransition * si = [[CATransition alloc]init];
        si.type = @"pageUnCurl";
        si.subtype = kCATransitionFromRight;
        si.duration = 0.5;
        [self.view.layer addAnimation:si forKey:nil];
        [si release];
    }
}

- (void)skipPage:(QZ_INT)pageNum
{
    indexImage = pageNum;
    [self pageNum:pageNum];
    CATransition * si = [[CATransition alloc]init];
    si.type = @"rippleEffect";
    si.subtype = kCATransitionFromRight;
    si.duration = 0.5;
    [self.view.layer addAnimation:si forKey:nil];
    [si release];
}

- (void)showMenuWithDBN
{
    QZDirectAndBMarkAndNotesView * gDBNView = (QZDirectAndBMarkAndNotesView *) [self.view viewWithTag:QZDIRECTANDBMARKANDNOTESVIEW_TAG];
    QZPageListView *pageListV = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    [UIView animateWithDuration:0.8 animations:^{
        if (pageListV)
        {
            upAndDown.frame = CGRectMake(DW/2, 0, DW, DH-21);
            [pageListV closeAllView];
            [pageListV isNowOpenDBN];
        }
        
        if (gDBNView)
        {
            gDBNView.frame = CGRectMake(0, 0, DW/2, DH-20);
        }
    }];    
}

- (void)closeTheView
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
        }
        QZDirectAndBMarkAndNotesView * gDBNView = (QZDirectAndBMarkAndNotesView *) [self.view viewWithTag:QZDIRECTANDBMARKANDNOTESVIEW_TAG];
        if (gDBNView)
        {
        gDBNView.frame = CGRectMake(-DW/2, 0, DW/2, DH-20);
        }
    }];

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
- (void)makeOneImageOfTap:(NSString *)imagePath
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
        }];
 }

- (void)pressCloseImage:(UIButton *)button
{
    UIView *imageView = (UIView *)[self.view viewWithTag:IMAGEOFONE];
    if (imageView)
    {
        [imageView removeFromSuperview];
    }
 }

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    switch (scrollView.tag)
    {
        case LEFTANDRIGHT_PAGE_CONTROL_SC_TAG:
        {
            
            if (scrollView.contentOffset.x > 100)
            {
                if (indexImage < [arrayImage count] - 1)
                {
                  indexImage++;
                    [self pageNum:indexImage];
                }
                
            }else if(scrollView.contentOffset.x < -100){
                if (indexImage > 0)
                {
                   indexImage--;
                    [self pageNum:indexImage];
                }
            }
        }
            break;
        case UPANDDOWN_ADD_BOOKMARK_SC_TAG:
        {

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

- (void)BookMark
{

}

- (void)PageControl
{

}

- (NSString *)date
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"G:yyyy-MM-dd(EEE) k:mm:ss"];
    NSString *strDate = [formatter stringFromDate:date];
    [formatter release];
    return strDate;
}

- (void)dealloc
{
    [arrayImage release];
    [upAndDown release];
    [gScrollView release];
    [headTopView release];
    [bookMark release];
    [super dealloc];
}
 @end
