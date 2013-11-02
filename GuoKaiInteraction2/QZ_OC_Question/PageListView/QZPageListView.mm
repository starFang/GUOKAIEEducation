//
//  QZPageListView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//


#import "QZPageListView.h"
#import <QuartzCore/QuartzCore.h>
#import "DrawLine.h"

#import "QuestionRootView.h"
#import "QZPageTextRollWebView.h"
#import "QZPageWebLinkView.h"
#import "QZPageToolTipView.h"
//音频
#import "MusicToolView.h"
#import "GalleryView.h"
#import "MovieView.h"
#import "ImageGV1.h"

#import "XMLParserBookData.h"

#define NVACHILDBUTTON 120

@implementation QZPageListView

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
#pragma mark - 背景图片
    NSString *path = [[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:[[[imageName objectAtIndex:0] objectForKey:@"0"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage * image = [UIImage imageWithData:data];
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
}

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
    [self.delegate showDBN];
    leftButton.userInteractionEnabled = NO;
}

- (void)closeView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.delegate closeTheView];
        [self closeOtherViewOfTip];
        if (isOpenDBN)
        {
            [self.delegate hideTheLeftView];
             leftButton.userInteractionEnabled = YES;
            isOpenDBN = NO;
        }
    }];
}

- (void)closeTheDBN
{
    isOpenDBN = YES;
}
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
}

- (void)updateWithPress
{
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(upPage:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(downPage:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(ZERO, ZERO  , 100, SFSH);
    rightButton.frame = CGRectMake(SFSW-50, ZERO, 100, SFSH);
    [self addSubview:leftButton];
    [self addSubview:rightButton];
}

- (void)upPage:(id)sender
{
    if (indexVoice != 0)
    {
        for (int i = 0; i < indexVoice; i++)
        {
            MusicToolView *musciView = (MusicToolView *)[self viewWithTag:VOICE+i];
            [musciView stop];
        }
    }
    for (int i = 0; i < indexVideo; i++)
    {
        MovieView *movieView = (MovieView *)[self viewWithTag:VIDEO + i];
        if (movieView.isPlaying)
        {
            [movieView next];
        }
    }
    [self.delegate up:sender];
    isOpenDBN = YES;
}

- (void)downPage:(id)sender
{
    if (indexVoice != 0)
    {
        for (int i = 0; i < indexVoice; i++)
        {
            MusicToolView *musciView = (MusicToolView *)[self viewWithTag:VOICE+i];
            [musciView stop];
        }
    }
    for (int i = 0; i < indexVideo; i++)
    {
        MovieView *movieView = (MovieView *)[self viewWithTag:VIDEO + i];
        if (movieView.isPlaying)
        {
        [movieView next];
        }
    }
    
    [self.delegate down:sender];
    isOpenDBN = YES;
}

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
    QuestionRootView *qView = [[QuestionRootView alloc]init];
    qView.frame = CGRectMake(
        pQuestionList->rect.X0,
        pQuestionList->rect.Y0,
        pQuestionList->rect.X1 - pQuestionList->rect.X0,
        pQuestionList->rect.Y1 - pQuestionList->rect.Y0
                            );
    qView.tag = QUESTION + indexQuestion;
    [qView initIncomingData:pQuestionList];
    [qView composition];
    [self addSubview:qView];
    indexQuestion++;
}

//视频
- (void)video:(PageVideo *)pVideo
{
    MovieView *movieView = [[MovieView alloc]init];
    movieView.frame = CGRectMake(pVideo->rect.X0, pVideo->rect.Y0, pVideo->rect.X1 - pVideo->rect.X0, pVideo->rect.Y1 - pVideo->rect.Y0);
    movieView.delegate = self;
    movieView.tag = VIDEO + indexVideo;
    [movieView initIncomingData:pVideo];
    [movieView composition];
    [self addSubview:movieView];
    [movieView release];
    indexVideo++;
}

- (void)newMovieView
{
    if (isPlay)
    {
        for (int i = 0; i < indexVideo; i++)
        {
            MovieView *movieView = (MovieView *)[self viewWithTag:VIDEO + i];
            [movieView next];
        }
    }
    isPlay = !isPlay;
}

//单张图片
- (void)image:(PageImage *)pImage
{
    ImageGV1 *image = [[ImageGV1 alloc]init];
    image.frame = CGRectMake(pImage->rect.X0, pImage->rect.Y0, pImage->rect.X1 - pImage->rect.X0, pImage->rect.Y1 - pImage->rect.Y0);
    image.tag  = IMAGE + indexImage;
    [image initIncomingData:pImage];
    [image composition];
    [self addSubview:image];
    [image release];
    indexImage++;
}

//画廊
- (void)imageList:(PageImageList *)pImageList
{
    GalleryView * gallView = [[GalleryView alloc]init];
    gallView.frame = CGRectMake(pImageList->rect.X0, pImageList->rect.Y0, pImageList->rect.X1 - pImageList->rect.X0, pImageList->rect.Y1 - pImageList->rect.Y0);
    gallView.tag = IMAGELIST + indeximageList;
    [gallView initIncomingData:pImageList];
    [gallView composition];
    [self addSubview:gallView];
    [gallView release];
    indeximageList++;
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

- (void)closeOtherViewOfTip
{
    if (indexToolTip > 0)
    {
        for (int i = 0; i < indexToolTip ; i++)
        {
            QZPageToolTipView *pageToolTip = (QZPageToolTipView *)[self viewWithTag:TOOLTIP+i];
            [pageToolTip closeTheTextViewWithToolTipView];
        }
    }
    UIView *view = (UIView *)[self viewWithTag:POPBTNVIEW];
    if (view)
    {
        [view removeFromSuperview];
    }
}

- (void)popBtnView:(PageNavButton *)pNavButton
{
    CGFloat x0 = pNavButton->rect.X0;
    CGFloat x1 = pNavButton->rect.X1;
    CGFloat y0 = pNavButton->rect.Y0;
    CGFloat y1 = pNavButton->rect.Y1;
    //    弹出视图的宽高
    CGFloat toolX;
    CGFloat toolY;
    CGFloat toolW = pNavButton->nWidth;
    CGFloat toolH = pNavButton->nHeight;
    NSInteger fist;
    if (x0 <= DW/2 && y0 <= DW/2)
    {
        toolX = x0;
        toolY = y0;
        fist  = 1;
    }else if (x0 <= DW/2 && y0 > DW/2){
        toolX = x0;
        toolY = y1-toolH;
        fist = 3;
    }else if (x0 > DW/2 && y0 <= DW/2){
        toolX = x1 - pNavButton->nWidth;
        toolY = y0;
        fist = 2;
    }else{
        toolX = x1-pNavButton->nWidth;
        toolY = y1-toolH;
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
    CGSize size = [[NSString stringWithUTF8String:pNavButton->strTipText.c_str()] sizeWithFont:[UIFont systemFontOfSize:21] constrainedToSize:CGSizeMake(popView.FSW-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * textCont = [[UILabel alloc]init];
    textCont.backgroundColor = [UIColor clearColor];
    textCont.numberOfLines = 0;
    textCont.text = [NSString stringWithUTF8String:pNavButton->strTipText.c_str()];
    textCont.font = [UIFont systemFontOfSize:21];
    textCont.frame = CGRectMake(20, 20, popView.FSW-40, size.height);
    UIScrollView * svc = [[UIScrollView alloc]init];
    svc.frame = popView.bounds;
    svc.contentSize = CGSizeMake(popView.FSW-40, size.height+140);
    [svc addSubview:textCont];
    [textCont release];
    for (int i = 0; i < pNavButton->vBtnList.size(); i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"黄色背景.png"] forState:UIControlStateNormal];
        button.tag =  NVACHILDBUTTON + pNavButton->vBtnList[i].nPageIndex; 
        [button setTitle:[NSString stringWithUTF8String:pNavButton->vBtnList[i].strBtnText.c_str()] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.frame = CGRectMake(25+((popView.FSW - 50)/pNavButton->vBtnList.size())*i, size.height+30, (popView.FSW - 50)/pNavButton->vBtnList.size(), TIP_BUTTON_POP_THE_BTN_HEIGHT);
        [button addTarget:self action:@selector(pressSkip:) forControlEvents:UIControlEventTouchUpInside];
        [svc addSubview:button];
    }
    [popView addSubview:svc];
    [svc release];
}

- (void)closeOtherToolTip
{
    if (indexToolTip > 0)
    {
        for (int i = 0; i < indexToolTip ; i++)
        {
            QZPageToolTipView *pageToolTip = (QZPageToolTipView *)[self viewWithTag:TOOLTIP+i];
            [pageToolTip closeTheTextViewWithToolTipView];
        }
    }
}

- (void)pressSkip:(UIButton *)button
{
    UIView *view = (UIView *)[self viewWithTag:POPBTNVIEW];
    if (view)
    {
        [view removeFromSuperview];
    }
    [self.delegate skipPage: button.tag - NVACHILDBUTTON];
   
}

- (void)closeBtnView:(PageNavButton *)pageNavButton
{
    UIView *view = (UIView *)[self viewWithTag:POPBTNVIEW];
    if (view)
    {
        [view removeFromSuperview];
    }
}

-(void)skip:(QZ_INT)pageNum
{
    if (indexVoice != 0)
    {
        for (int i = 0; i < indexVoice; i++)
        {
        MusicToolView *musciView = (MusicToolView *)[self viewWithTag:VOICE+i];
            [musciView stop];
        }
    }
    [self.delegate skipPage:pageNum];
}

- (void)dealloc
{
    [array release];
    [super dealloc];
}

@end
