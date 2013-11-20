//
//  QZPageListView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//


#import "QZPageListView.h"
#import <QuartzCore/QuartzCore.h>
#import "XMLParserBookData.h"
#import "DrawLine.h"

#import "QZPageTextRollWebView.h"
#import "QZPageWebLinkView.h"
#import "QZPageToolTipView.h"
#import "MusicToolView.h"
#import "MovieView.h"
#import "MovieView.h"
#import "DataManager.h"
#import "QZRootViewController.h"

#import "ACMagnifyingGlass.h"
#import "ACLoupe.h"

#import "QZBookMarkDataModel.h"
@interface QZPageListView ()

@property (nonatomic, retain) NSTimer *touchTimer;

- (void)addMagnifyingGlassAtPoint:(CGPoint)point;
- (void)removeMagnifyingGlass;
- (void)updateMagnifyingGlassAtPoint:(CGPoint)point;

@end
@implementation QZPageListView
@synthesize magnifyingGlass;
@synthesize touchTimer;

@synthesize pageName;
@synthesize delegate;
@synthesize pageNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self index];
    }
    return self;
}

- (void)index
{
    indexToolTip = 0;
    indexToolImageTip = 0;
    indexNavRect  = 0;
    indexNavButton = 0;
    indexVideo = 0;
    indexQuestion = 0;
    indexImage = 0;
    indeximageList = 0;
    indexVoice = 0;
    indexTextRoll = 0;
    indexWebLink = 0;
    isPlay = NO;
    isOpenDBN  = NO;
}

- (void)initIncomingData:(NSArray *)imageName
{
    array = [[NSMutableArray alloc]initWithObjects:[imageName objectAtIndex:0],[imageName objectAtIndex:1], nil];
    NSString *bookPath = [[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:[[array objectAtIndex:1] objectForKey:@"1"]];
    pageObj.LoadData([bookPath UTF8String]);
    [self initBackImage:imageName];
}

- (void)initBackImage:(NSArray *)imageName
{
    
    NSString *path = [[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:[[[imageName objectAtIndex:0] objectForKey:@"0"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ZERO, ZERO, DW, DH-20)];
    [imageView setImage:image];
    [self addSubview:imageView];
    [imageView release];
    
}

- (void)composition
{
    [self drawLineView];
    [self updateWithPress];
    [self inputPageData];
    [self theBookMarkOfPage];
    [self glassOfPage];
}
#pragma mark - 主要用于划线文字的划线操作的放大效果
- (void)glassOfPage
{
    ACLoupe *loupe = [[ACLoupe alloc] init];
	self.magnifyingGlass = loupe;
	loupe.scaleAtTouchPoint = NO;
}

- (void)pressLongBegin:(CGPoint)point
{
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.0
                                                       target:self
                                                     selector:@selector(addMagnifyingGlassTimer:)
                                                     userInfo:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y+64)]
                                                      repeats:NO];
}
// private functions
- (void)addMagnifyingGlassTimer:(NSTimer*)timer
{
	NSValue *v = timer.userInfo;
	CGPoint point = [v CGPointValue];
	[self addMagnifyingGlassAtPoint:point];
}
// magnifier functions
- (void)addMagnifyingGlassAtPoint:(CGPoint)point
{
	if (!magnifyingGlass)
    {
		magnifyingGlass = [[ACMagnifyingGlass alloc] init];
	}
    
	if (!magnifyingGlass.viewToMagnify)
    {
		magnifyingGlass.viewToMagnify = self;
	}
    magnifyingGlass.touchPoint = point;
	[self addSubview:magnifyingGlass];
	[magnifyingGlass setNeedsDisplay];
}
- (void)updateMagnifyingGlassAtPoint:(CGPoint)point
{
	magnifyingGlass.touchPoint = point;
	[magnifyingGlass setNeedsDisplay];
}
- (void)pressLongChange:(CGPoint)point
{
    [self updateMagnifyingGlassAtPoint:CGPointMake(point.x, point.y+69)];
}

- (void)pressLongEnd:(CGPoint)point
{
    [self.touchTimer invalidate];
	self.touchTimer = nil;
	[self removeMagnifyingGlass];
}
- (void)removeMagnifyingGlass
{
    [magnifyingGlass removeFromSuperview];
}

//单页的书签
- (void)theBookMarkOfPage
{
    bookMark = [[UIImageView alloc]init];
    bookMark.tag = BOOKMARK_IMAGE_TAG;
    bookMark.frame = CGRectMake(DW-30, 0, 20, 44);
    [bookMark setImage:[UIImage imageNamed:@"g_DBN_BookMark.png"]];
    [self addSubview:bookMark];
    bookMark.hidden = YES;
    if ([self bookMarkIsHave])
    {
        bookMark.hidden = NO;
    }
}

- (void)isHaveTheBookMarkForPage
{
    if ([self bookMarkIsHave])
    {
        bookMark.hidden = NO;
    }else{
        bookMark.hidden = YES;
    }
}

- (BOOL)bookMarkIsHave
{
    NSArray *bookMarkArray = [DataManager shareDataManager].bookMarkDataArray;
    for (int i = 0; i < [bookMarkArray count]; i++)
    {
        QZBookMarkDataModel *bookMarkData  = (QZBookMarkDataModel *)[bookMarkArray objectAtIndex:i];
        if (bookMarkData.bmPageNumber == self.pageNumber)
        {
            return YES;
        }
    }
    return NO;
}

- (void)isHaveTheBookMarkOnPage:(BOOL)isBMark
{
  bookMark.hidden = isBMark;
}

//左边弹出视图，上面弹出视图的操作
- (void)isNowOpenDBN
{
    [self closeTheDBN];
}

- (void)closeAllView
{
    [self closeView];
}

- (void)popView
{
    [self.delegate showDBN];//弹出上面的头视图
}

- (BOOL)closeTheDownBtn
{
    if ([self.delegate closeTheBtnOfTheDown])
    {
        return YES;
    }
    return NO;
}

- (void)closeView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.delegate closeTheHeadTopView];
        [self closeOtherViewOfTip];
        if (isOpenDBN)
        {
            leftButton.userInteractionEnabled = YES;
            [self.delegate hideTheLeftView];
            isOpenDBN = NO;
        }
    }];
}

- (void)closeTheDBN
{
    isOpenDBN = YES;
}

#pragma  mark - 划线操作
- (void)drawLineView
{
    DrawLine * draw = [[DrawLine alloc]initWithFrame:CGRectMake(ZERO, ZERO, DW, DH-20)];
    draw.tag = DRAWVIEWTAG;
    draw.delegate = (DrawLine *)self;
    draw.backgroundColor = [UIColor clearColor];
    [draw setPageNumber:self.pageNumber];
    [draw incomingData:&pageObj];
    [draw composition];
    [self addSubview:draw];
    [draw release];
}
- (void)bringFromTheFirst
{
    DrawLine * draw = (DrawLine *)[self viewWithTag:DRAWVIEWTAG];
    if (![[self.subviews lastObject] isKindOfClass:[DrawLine class]])
    {
        [self bringSubviewToFront:draw];
    }
}
- (void)comeBackTheIndex
{
    if ([self.subviews count] > 2)
    {
        if (![[self.subviews objectAtIndex:1] isKindOfClass:[DrawLine class]])
        {
    [self exchangeSubviewAtIndex:1 withSubviewAtIndex:[self.subviews count]-1];   
        }
    }
}

- (void)save
{
    DrawLine * draw = (DrawLine *)[self viewWithTag:DRAWVIEWTAG];
    if (draw)
    {
        [draw saveData];
    }
    leftButton.userInteractionEnabled = NO;
}

#pragma mark - 点击左侧和右侧跳转视图
- (void)updateWithPress
{
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(upPage:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(downPage:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(ZERO, ZERO  , 50, SFSH);
    rightButton.frame = CGRectMake(SFSW-50, ZERO, 50, SFSH);
    [self addSubview:leftButton];
    [self addSubview:rightButton];
}

- (void)upPage:(id)sender
{
    [self closePopTipView];
    [self closeTheVoiceView];
    [self closeTheVideoView];
    isOpenDBN = YES;
    [self.delegate up:sender];
}

- (void)downPage:(id)sender
{
    [self closePopTipView];
    [self closeTheVoiceView];
    [self closeTheVideoView];
    isOpenDBN = YES;
    [self.delegate down:sender];
}

#pragma mark - 点击跳转到某页的视图
- (void)pressSkip:(UIButton *)button
{
    UIView *view = (UIView *)[self viewWithTag:POPBTNVIEW];
    if (view)
    {
        [view removeFromSuperview];
    }
    
    [self.delegate skipPage: button.tag - NVACHILDBUTTON];
}

-(void)skip:(QZ_INT)pageNum
{
    [self closePopTipView];
    [self closeTheVideoView];
    [self closeTheVoiceView];
    [self.delegate skipPage:pageNum];
}


#pragma mark - 初始化每页有的交互操作
- (void)inputPageData
{
    vector<const PageBaseElements*> vObjs = pageObj.GetDrawableObjList();
    for (int i = 0; i < vObjs.size(); i++)
    {
    const PageBaseElements* pObj = vObjs[i];
    switch (pObj->m_elementType)
        {
            case PAGE_OBJECT_QUESTION_LIST:// 题目列表
            {
            PageQuestionList* pQuestionList = (PageQuestionList*)pObj;
            [self selfDetect:pQuestionList];
            }
            break;
                case PAGE_OBJECT_TOOL_TIP:
            {
            PageToolTip *pToolTip = (PageToolTip *)pObj;
                [self ToolTip:pToolTip];
            }
                break;
                case PAGE_OBJECT_TOOL_IMAGE_TIP:
            {
            PageToolImageTip *pToolImageTip = (PageToolImageTip *)pObj;
                [self ToolImageTip:pToolImageTip];
            }
                break;
                case PAGE_OBJECT_NAV_RECT:
            {
                PageNavRect *pNavRect = (PageNavRect *)pObj;
                [self navRect:pNavRect];
            }
                break;
                case PAGE_OBJECT_NAV_BUTTON:
            {
                PageNavButton *pNavButton = (PageNavButton *)pObj;
                [self navButton:pNavButton];
             }
                break;
                case PAGE_OBJECT_VIDEO:
            {
                PageVideo *pVideo = (PageVideo *)pObj;
                [self video:pVideo];
            }
                break;
                case PAGE_OBJECT_IMAGE:
            {
                PageImage * pImage = (PageImage *)pObj;
                [self image:pImage];
            }
                break;
                case PAGE_OBJECT_IMAGE_LIST:
            {
                PageImageList *pImageList = (PageImageList *)pObj;
                [self imageList:pImageList];
            }
                break;
                
            case PAGE_OBJECT_VOICE:
            {
                PageVoice *pVoice = (PageVoice *)pObj;
                [self voice:pVoice];
            }
                break;
                
            case PAGE_OBJECT_TEXT_ROLL:
            {
                PageTextRoll *pTextRoll = (PageTextRoll *)pObj;
                [self TextRoll:pTextRoll];
            }
                break;
            case PAGE_OBJECT_WEB_LINK:
            {
            PageWebLink *pageWebLink = (PageWebLink *)pObj;
                NSLog(@"浏览器跳转");
                [self webLink:pageWebLink];
             }
                break;
        default:
            break;
        }
    }
}

//文字提示
- (void)ToolTip:(PageToolTip *)pToolTip
{
    QZPageToolTipView *pageToolTip = [[QZPageToolTipView alloc]initWithFrame:CGRectMake(
           pToolTip->rect.X0,
           pToolTip->rect.Y0,
           pToolTip->rect.X1 - pToolTip->rect.X0,
           pToolTip->rect.Y1 - pToolTip->rect.Y0)
                                      ];
    pageToolTip.tag = TOOLTIP + indexToolTip;
    pageToolTip.delegate = self;
    [pageToolTip initIncomingData:pToolTip];
    [pageToolTip composition];
    [self addSubview:pageToolTip];
    [pageToolTip release];
    indexToolTip++;
}

//文字图片提示
- (void)ToolImageTip:(PageToolImageTip *)pToolImageTip
{
//    坐标
    CGFloat x0 = pToolImageTip->rect.X0;
    CGFloat x1 = pToolImageTip->rect.X1;
    CGFloat y0 = pToolImageTip->rect.Y0;
    CGFloat y1 = pToolImageTip->rect.Y1;
    CGPoint center = CGPointMake((x0+x1)/2,(y0+y1)/2);
//    弹出视图的宽高
    CGFloat toolX;
    CGFloat toolY;
    CGFloat toolW;
    CGFloat toolH;
    toolH = y1 - y0 + 20 + pToolImageTip->nHeight;
    if ((x1 - x0) >= pToolImageTip->nWidth)
    {
        toolW = pToolImageTip->rect.X1-pToolImageTip->rect.X0;
     }else{
         toolW = pToolImageTip->nWidth;
     }
    int a = 0;
    int b = 0;
    if (center.x <= DW/2)
    {
            toolX = center.x - toolW/2;
        a=1;
    
    }else{
            toolX = DW - 20 - toolW;
        a = 0;
     }
    if (center.y <= DH/2)
    {
        toolY = y0;
        b =1;
    }else{
        toolY = y1-toolH;
        b = 0;
     }
    
    QZToolTipImageview *pToolTipImageview = [[QZToolTipImageview alloc]init];
    pToolTipImageview.delegate = self;
    pToolTipImageview.frame = CGRectMake(toolX , toolY , toolW  ,toolH);
    pToolTipImageview.backgroundColor = [UIColor grayColor];
    if (a == 0 && b == 0)
    {
        [pToolTipImageview setFist:1];
    }else if (a == 1 && b == 0)
    {
        [pToolTipImageview setFist:2];
    }else if(a == 0 && b == 1 )
    {
        [pToolTipImageview setFist:3];
    }else if (a == 1 && b == 1)
    {
        [pToolTipImageview setFist:4];
    }
    pToolTipImageview.tag = TOOLIMAGETIP + indexToolImageTip;
    [pToolTipImageview initIncomingData:pToolImageTip];
    [pToolTipImageview composition];
    [self addSubview:pToolTipImageview];
    [pToolTipImageview release];
    indexToolImageTip++;
}

//导航点击区域
- (void)navRect:(PageNavRect *)pNavRect
{
   QZPageNavRectView *pNavRectView = [[QZPageNavRectView alloc]init];
    pNavRectView.frame = CGRectMake(pNavRect->rect.X0, pNavRect->rect.Y0, pNavRect->rect.X1 - pNavRect->rect.X0, pNavRect->rect.Y1 - pNavRect->rect.Y0);
    [pNavRectView initIncomingData:pNavRect];
    pNavRectView.delegate = self;
    pNavRectView.tag = NAVRECT + indexNavRect;
    [pNavRectView composition];
    [self addSubview:pNavRectView];
    indexNavRect++;
}

//点击区域按钮的
- (void)navButton:(PageNavButton *)pNavButton
{
   QZPageNavButtonView *pNavButtonView = [[QZPageNavButtonView alloc]init];
    pNavButtonView.tag = NAVBUTTON + indexNavButton;
    pNavButtonView.delegate = self;
    //    坐标
    CGFloat x0 = pNavButton->rect.X0;
    CGFloat x1 = pNavButton->rect.X1;
    CGFloat y0 = pNavButton->rect.Y0;
    CGFloat y1 = pNavButton->rect.Y1;
    pNavButtonView.frame =CGRectMake(x0, y0, x1-x0, y1-y0);
    [pNavButtonView initIncomingData:pNavButton];
    [pNavButtonView composition];
    [self addSubview:pNavButtonView];
    [pNavButtonView release];
    indexNavButton++;
}

//题
- (void)selfDetect:(PageQuestionList *)pQuestionList
{
    UIImage *backImage = [UIImage imageNamed:@"g_question_back.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(                pQuestionList->rect.X0-1 -50,pQuestionList->rect.Y0-1-25,pQuestionList->rect.X1 - pQuestionList->rect.X0+2 +100,pQuestionList->rect.Y1 - pQuestionList->rect.Y0+2+100)];
    [imageView setImage:backImage];
    [self addSubview:imageView];
    [imageView release];

    QuestionRootView *qView = [[QuestionRootView alloc]init];
    qView.frame = CGRectMake(
        pQuestionList->rect.X0,
        pQuestionList->rect.Y0,
        pQuestionList->rect.X1 - pQuestionList->rect.X0,
        pQuestionList->rect.Y1 - pQuestionList->rect.Y0
                            );
    qView.delegate = self;
    qView.tag = QUESTION + indexQuestion;
    [qView initIncomingData:pQuestionList];
    [qView composition];
    [self addSubview:qView];
    indexQuestion++;
}

- (void)scrollSCStart
{
    [self.delegate pageListViewOfSupSCStartDrag];
}

- (void)scrollStart
{
 [self.delegate pageListViewOfSupSCStartDrag];
}
- (void)scrollStop
{
    [self.delegate pageListViewOfSupSCStopDrag];
}

//视频
- (void)video:(PageVideo *)pVideo
{
    MovieView *movieView = [[MovieView alloc]init];
    movieView.frame = CGRectMake(pVideo->rect.X0, pVideo->rect.Y0, pVideo->rect.X1 - pVideo->rect.X0, pVideo->rect.Y1 - pVideo->rect.Y0);
    movieView.tag = VIDEO + indexVideo;
    [movieView setVideoViewTag:movieView.tag];
    [movieView initIncomingData:pVideo];
    [movieView composition];
    [self addSubview:movieView];
    [movieView release];
    indexVideo++;
}

- (void)closeTheVideoView
{
    for (int i = 0; i < indexVideo; i++)
    {
        MovieView *movieView = (MovieView *)[self viewWithTag:VIDEO + i];
        if (movieView.isPlaying)
        {
            [movieView next];
        }
    }
}

//单张图片
- (void)image:(PageImage *)pImage
{
    ImageGV1 *image = [[ImageGV1 alloc]init];
    image.frame = CGRectMake(pImage->rect.X0, pImage->rect.Y0, pImage->rect.X1 - pImage->rect.X0, pImage->rect.Y1 - pImage->rect.Y0);
    image.tag  = IMAGE + indexImage;
    image.delegate = self;
    [image initIncomingData:pImage];
    [image composition];
    [self addSubview:image];
    [image release];
    indexImage++;
}

- (void)makeOneImage:(NSString *)imagePath withTitle:(NSString *)titleString
{
    [self.delegate makeOneImageOfTap:imagePath withImageName:titleString];
}

//画廊
- (void)imageList:(PageImageList *)pImageList
{
    GalleryView * gallView = [[GalleryView alloc]init];
    gallView.frame = CGRectMake(pImageList->rect.X0, pImageList->rect.Y0, pImageList->rect.X1 - pImageList->rect.X0, pImageList->rect.Y1 - pImageList->rect.Y0);
    gallView.tag = IMAGELIST + indeximageList;
    gallView.delegate = self;
    [gallView initIncomingData:pImageList];
    [gallView composition];
    [self addSubview:gallView];
    [gallView release];
    indeximageList++;
}

- (void) makeImageWithContent:(PageImageList1 *)pageImageList withTagOfTap:(NSInteger)tapTag withTitle:(NSString *)titleName
{
   [self.delegate closeTheHeadTopView];
   [self.delegate makeImageList:pageImageList withTagOfTap:tapTag withTitle:titleName];
}

//声音8
- (void)voice:(PageVoice *)pVoice
{
    MusicToolView *musciView = [[MusicToolView alloc]init];
    musciView.frame = CGRectMake(pVoice->rect.X0, pVoice->rect.Y0, pVoice->rect.X1 - pVoice->rect.X0, pVoice->rect.Y1 - pVoice->rect.Y0);
    musciView.tag = VOICE + indexVoice;
    [musciView initIncomingData:pVoice];
    [musciView composition];
    [self addSubview:musciView];
    [musciView release];
    indexVoice++;
}

- (void)closeTheVoiceView
{
    if (indexVoice != 0)
    {
        for (int i = 0; i < indexVoice; i++)
        {
            MusicToolView *musciView = (MusicToolView *)[self viewWithTag:VOICE+i];
            [musciView stop];
        }
    }
}

//文字滚动视图 9
- (void)TextRoll:(PageTextRoll *)pTextRoll
{
    QZPageTextRollWebView *pageTextRoll = [[QZPageTextRollWebView alloc]init];
    pageTextRoll.frame = CGRectMake(
        pTextRoll->rect.X0,
        pTextRoll->rect.Y0,
        pTextRoll->rect.X1 - pTextRoll->rect.X0,
        pTextRoll->rect.Y1 - pTextRoll->rect.Y0);
    pageTextRoll.tag = TOOLTIP + indexTextRoll;
    pageTextRoll.clipsToBounds = YES;
    [pageTextRoll initIncomingData:pTextRoll];
    [pageTextRoll composition];
    [self addSubview:pageTextRoll];
    indexTextRoll++;
}

//web链接10
- (void)webLink:(PageWebLink *)pageWebLink
{
    QZPageWebLinkView *page = [[QZPageWebLinkView alloc]initWithFrame:CGRectMake(pageWebLink->rect.X0,
            pageWebLink->rect.Y0,
            pageWebLink->rect.X1 - pageWebLink->rect.X0,
            pageWebLink->rect.Y1 - pageWebLink->rect.Y0)];
    page.tag = WEBLINK + indexWebLink;
    [page initIncomingData:pageWebLink];
    [page composition];
    [self addSubview:page];
    [page release];
    indexWebLink++;
}

#pragma mark - 点击按钮的弹出视图以及其关闭功能的视图
- (void)closeOtherViewOfTip
{
    UIView *view = (UIView *)[self viewWithTag:POPBTNVIEW];
    if (view)
    {
        [view removeFromSuperview];
    }
    
   [self deleteTheTipPopView];
   [self theTipPopViewOfBtn];
}

- (void)popBtnView:(PageNavButton *)pNavButton
{
    CGFloat x0 = pNavButton->rect.X0;
    CGFloat x1 = pNavButton->rect.X1;
    CGFloat y0 = pNavButton->rect.Y0;
    CGFloat y1 = pNavButton->rect.Y1;
 
    CGFloat toolW = pNavButton->nWidth;
    CGFloat toolH = pNavButton->nHeight*1.2;
    NSInteger fist;
    if (x0 <= DW/2 && y0 <= DW/2)
    {
        fist  = 1;
    }else if (x0 <= DW/2 && y0 > DW/2){
        fist = 3;
    }else if (x0 > DW/2 && y0 <= DW/2){
        fist = 2;
    }else{
        fist = 4;
    }
    
    UIImage *image = [UIImage imageNamed:@"g_Question_Tip_Btn@2x.png"];
    [image stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    UIImageView *popView = [[UIImageView alloc]init];
    [popView setImage:image];
    popView.userInteractionEnabled = YES;
    CGRect rectPop;
    if (fist == 1)
    {
        rectPop = CGRectMake(x0,y1+TIP_BUTTON_POP_ON_BTN_HEIGHT,toolW,toolH);
    }else if (fist == 2){
        rectPop = CGRectMake(x1-toolW,y1+TIP_BUTTON_POP_ON_BTN_HEIGHT,toolW,toolH);
        
    }else if (fist == 3){
            rectPop = CGRectMake(x0,y0-TIP_BUTTON_POP_ON_BTN_HEIGHT-toolH,toolW,toolH);
    }else{
            rectPop = CGRectMake(x1-toolW,y0-TIP_BUTTON_POP_ON_BTN_HEIGHT-toolH,toolW,toolH);
    }
    popView.tag = POPBTNVIEW;
    popView.frame = rectPop;
    [self addSubview:popView];
    [popView release];
    [self pressButton:pNavButton];
}

- (void)pressButton:(PageNavButton *)pNavButton
{
    UIView *popView = (UIView *)[self viewWithTag:POPBTNVIEW];
    CGSize size = [[NSString stringWithUTF8String:pNavButton->strTipText.c_str()] sizeWithFont:[UIFont fontWithName:@"Palatino" size:20] constrainedToSize:CGSizeMake(popView.FSW-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * textCont = [[UILabel alloc]init];
    textCont.backgroundColor = [UIColor clearColor];
    textCont.numberOfLines = 0;
    textCont.text = [NSString stringWithUTF8String:pNavButton->strTipText.c_str()];
    textCont.textColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
    textCont.font = [UIFont fontWithName:@"Palatino" size:20];
    textCont.frame = CGRectMake(0, 0, popView.FSW-40, size.height);
    UIScrollView * svc = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 20, popView.FSW-40, popView.FSH-50)];
    svc.contentSize = CGSizeMake(popView.FSW-40, size.height+140);
    [svc addSubview:textCont];
    [textCont release];
    for (int i = 0; i < pNavButton->vBtnList.size(); i++)
    {
        UIImage *image = [UIImage imageNamed:@"codedaohanganniu.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.tag =  NVACHILDBUTTON + pNavButton->vBtnList[i].nPageIndex; 
       [button setTitle:[NSString stringWithUTF8String:pNavButton->vBtnList[i].strBtnText.c_str()] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.frame = CGRectMake(((svc.FSW - pNavButton->vBtnList.size()*TIP_BUTTON_POP_THE_BTN_W-10)/pNavButton->vBtnList.size() + TIP_BUTTON_POP_THE_BTN_W)*i+10,
                size.height+30,
                TIP_BUTTON_POP_THE_BTN_W,TIP_BUTTON_POP_THE_BTN_HEIGHT);
        [button addTarget:self action:@selector(pressSkip:) forControlEvents:UIControlEventTouchUpInside];
        [svc addSubview:button];
    }
    [popView addSubview:svc];
    [svc release];
}

- (void)closePopTipView
{
    UIView *popView = (UIView *)[self viewWithTag:POPBTNVIEW];
    if (popView)
    {
        [popView removeFromSuperview];
        return;
    }
}

- (void)closeBtnView:(PageNavButton *)pageNavButton
{
    UIView *view = (UIView *)[self viewWithTag:POPBTNVIEW];
    if (view)
    {
        [view removeFromSuperview];
    }
}

#pragma mark - 关闭其他的ToolTip视图
- (void)closeOtherToolTip
{
    [self deleteTheTipPopView];
}

- (void)deleteTheTipPopView
{
    UIView *tipPopView = (UIView *)[self viewWithTag:TOOLTIPPOPVIEWTAG];
    if (tipPopView)
    {
        [tipPopView removeFromSuperview];
        tipPopView = nil;
    }
     UIImageView *imageViewArrow = (UIImageView *)[self viewWithTag:TOOLTIPPOPVIEWWITHIMAGETAG];
    if (imageViewArrow)
    {
        [imageViewArrow removeFromSuperview];
        imageViewArrow = nil;
    }
}

- (void)theTipPopViewOfBtn
{
    for (int i = 0; i < indexToolTip; i++)
    {
        QZPageToolTipView *pageToolTip = (QZPageToolTipView *)[self viewWithTag:TOOLTIP + i];
        [pageToolTip TheBtnSelected];
    }
}


- (void)createPageToolTipView:(PageToolTip *)pageToolTip withFrame:(CGRect)frame andWithAngleFrame:(CGRect)angleFrame withImageName:(NSString *)imageName
{
   UIView *tipPopView = [[UIView alloc]initWithFrame:frame];
    tipPopView.tag = TOOLTIPPOPVIEWTAG;
    tipPopView.backgroundColor = [UIColor
                                colorWithRed:pageToolTip->bgColor.rgbRed/255.0
                                green:pageToolTip->bgColor.rgbGreen/255.0
                                blue:pageToolTip->bgColor.rgbBlue/255.0
                                alpha:pageToolTip->bgColor.rgbAlpha/255.0];
    tipPopView.layer.cornerRadius = 10.0;
    [tipPopView.layer setShadowOffset:CGSizeMake(5, 5)];
    [tipPopView.layer setShadowRadius:10.0];
    [tipPopView.layer setShadowColor:[UIColor blackColor].CGColor];
    [tipPopView.layer setShadowOpacity:10.0];
    [self addSubview:tipPopView];
    [tipPopView release];
    
    UIImageView *imageViewArrow = [[UIImageView alloc]initWithFrame:angleFrame];
    imageViewArrow.tag = TOOLTIPPOPVIEWWITHIMAGETAG;
    imageViewArrow.backgroundColor  =[UIColor clearColor];
    UIImage *image = [UIImage imageNamed:imageName];
    [imageViewArrow setImage:image];
    [self addSubview:imageViewArrow];
    [imageViewArrow release];
}

- (void)isYesRichText:(PageToolTip *)pageToolTip
{
    
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize = 0.0;
    CGFloat  fristlineindent = 0.0;
//    用于记录偏移量的
    NSInteger startOffset = 0;
    for (int i = 0; i < pageToolTip->strTipText.vTextItemList.size(); i++)
    {
        switch (pageToolTip->strTipText.vTextItemList[i].pieceType)
        {
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                if (string && ![string isEqualToString:@""])
                {
                    [string appendString:@"\n"];
                }
                startOffset = pageToolTip->strTipText.vTextItemList[i].nLength;
            }
                break;
            case PAGE_RICH_TEXT_PIECE_DOT:
            {
                fristlineindent = 1;
                NSLog(@"前面有小圆点");
            }
                break;
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pageToolTip->strTipText.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pageToolTip->strTipText.vTextItemList[i].fontColor.rgbRed,pageToolTip->strTipText.vTextItemList[i].fontColor.rgbGreen,pageToolTip->strTipText.vTextItemList[i].fontColor.rgbBlue,pageToolTip->strTipText.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pageToolTip->strTipText.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pageToolTip->strTipText.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pageToolTip->strTipText.vTextItemList[i].fontSize;
            }
                break;
            default:
                break;
        }
    }
    if ([strFont isEqualToString:@"宋体"])
    {
        [strFont setString:@"Palatino"];
    }
     UIView *tipPopView = (UIView *)[self viewWithTag:TOOLTIPPOPVIEWTAG];
     UIFont *font = [UIFont fontWithName:strFont size:fontsize];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(tipPopView.FSW-22, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
     CGSize sizeO =[@"我" sizeWithFont:font constrainedToSize:(CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)) lineBreakMode:NSLineBreakByWordWrapping];
     NSInteger count = size.height/sizeO.height;
    UIScrollView *scText = [[UIScrollView alloc]initWithFrame:CGRectMake(11, 6, tipPopView.FSW-22, tipPopView.FSH - 22)];
    AttributedTextView *attStringView = [[AttributedTextView alloc]init];
    attStringView.backgroundColor = [UIColor redColor];
    if (startOffset > 0 || fristlineindent > 0)
    {
        scText.contentSize = CGSizeMake(tipPopView.FSW-22, size.height+count*10 + sizeO.height);
        attStringView.frame = CGRectMake(0 , 0, tipPopView.FSW-22, size.height+count*14 + sizeO.height);
    }else{
        scText.contentSize = CGSizeMake(tipPopView.FSW-22, size.height+count*10);
        attStringView.frame = CGRectMake(0 , 0, tipPopView.FSW-22, size.height+count*10 );
    }
    if (attStringView.FSH < scText.FSH)
    {
        attStringView.frame = CGRectMake(0 , 0, tipPopView.FSW-22,scText.FSH);
    }
    
    attStringView.backgroundColor = [UIColor clearColor];
    [attStringView setFontSize:fontsize];
    [attStringView setLineSpacing:5];
    [attStringView setFirstNum:0];
    [attStringView setPGFist:startOffset];
    [attStringView setText:string];
    
    [scText addSubview:attStringView];
    [attStringView release];
    [tipPopView addSubview:scText];
    [scText release];
}
- (void)isNoRichText:(PageToolTip *)pageToolTip
{
    UIView *tipPopView = (UIView *)[self viewWithTag:TOOLTIPPOPVIEWTAG];
    UILabel *label = [[UILabel alloc]init];
    label.frame = tipPopView.bounds;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.text = [NSString stringWithUTF8String:pageToolTip->strTipText.strText.c_str()];
    [tipPopView addSubview:label];
    [label release];
}

- (void)createTheTipViewOfText:(PageToolTip *)pageToolTip
{
    if (pageToolTip->strTipText.isRichText == YES)
    {
        [self isYesRichText:pageToolTip];
    }else{
        [self isNoRichText:pageToolTip];
    }
}

- (void)dealloc
{
    [array release];
    [bookMark release];
    [super dealloc];
}

@end
