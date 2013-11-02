
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
    }else{
        bookMark.hidden = YES;
        [headTopView bookMarkNO];
    }
}

- (void)createScrollView
{
    upAndDown = [[UIScrollView alloc]init];
    upAndDown.tag = UPANDDOWN_ADD_BOOKMARK_SC_TAG;
    upAndDown.frame = CGRectMake(0, 0, DW, DH-20);
    upAndDown.delegate = self;
    upAndDown.contentSize = CGSizeMake(DW,DH-19);
    [self.view addSubview:upAndDown];
    [upAndDown release];
    
    gScrollView = [[UIScrollView alloc]init];
    gScrollView.frame = CGRectMake(0.5, 0, DW, DH-20);
    gScrollView.tag = LEFTANDRIGHT_PAGE_CONTROL_SC_TAG;
    gScrollView.delegate = self;
    gScrollView.contentSize = CGSizeMake(DW+0.5,DH-20);
    [upAndDown addSubview:gScrollView];
}

- (void)createDBN
{
    QZDirectAndBMarkAndNotesView * gDBNView = [[QZDirectAndBMarkAndNotesView alloc]init];
    gDBNView.tag = QZDIRECTANDBMARKANDNOTESVIEW_TAG;
    gDBNView.delegate =self;
    [gDBNView composition];
    gDBNView.frame = CGRectMake(-DW/2, 0, DW/2, DH-20);
    [self.view addSubview:gDBNView];
    [gDBNView release];
}
- (void)openTheSelectedPage:(NSInteger)pageNum
{
    indexImage = pageNum;
    [self pageNum:indexImage];
    [self hideTheLeftView];
}

- (void)pageNum:(NSInteger)pNumber
{
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
    
    CATransition * si = [[CATransition alloc]init];
    si.type = @"pageCurl";
    si.subtype = kCATransitionFromRight;
    si.duration = 0.5;
    [self.view.layer addAnimation:si forKey:nil];
    [si release];
    
    [self isHaveTheBookMark];
    [self closeTheView];
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
    if (indexImage <= 0)
    {
        indexImage = 0;
    }else{
        indexImage--;
    }
    [self pageNum:indexImage];
}

- (void)down:(id)sender
{
    if (indexImage >= [arrayImage count]-1)
    {
        indexImage =[arrayImage count]-1;
    }else{
        indexImage++;
    }
    [self pageNum:indexImage];
}

- (void)skipPage:(QZ_INT)pageNum
{
    indexImage = pageNum;
    [self pageNum:pageNum];
}

- (void)showMenuWithDBN
{
    QZDirectAndBMarkAndNotesView * gDBNView = (QZDirectAndBMarkAndNotesView *) [self.view viewWithTag:QZDIRECTANDBMARKANDNOTESVIEW_TAG];
    QZPageListView *pageListV = (QZPageListView *)[gScrollView viewWithTag:PAGELISTVIEW_ON_QZROOT_TAG];
    [UIView animateWithDuration:0.8 animations:^{
        if (pageListV)
        {
            upAndDown.frame = CGRectMake(DW/2, 0, DW, DH-20);
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
        upAndDown.frame = CGRectMake(0, 0.5, DW, DH-20);
        }
        QZDirectAndBMarkAndNotesView * gDBNView = (QZDirectAndBMarkAndNotesView *) [self.view viewWithTag:QZDIRECTANDBMARKANDNOTESVIEW_TAG];
        if (gDBNView)
        {
        gDBNView.frame = CGRectMake(-DW/2, 0, DW/2, DH-20);
        }
    }];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    switch (scrollView.tag)
    {
        case LEFTANDRIGHT_PAGE_CONTROL_SC_TAG:
        {
            
        }
            break;
        case UPANDDOWN_ADD_BOOKMARK_SC_TAG:
        {
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

 @end
