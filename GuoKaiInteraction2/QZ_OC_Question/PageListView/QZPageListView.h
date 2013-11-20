//
//  QZPageListView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "QZEpubPage.h"
#include <vector>
#import "DrawLine.h"

#import "QuestionRootView.h"
#import "GalleryView.h"
#import "QZPageToolTipView.h"
#import "QZToolTipImageview.h"
#import "QZPageNavButtonView.h"
#include "QZPageNavRectView.h"

#import "PageImageList1.h"
#import "ImageGV1.h"
@class ACMagnifyingGlass;

@protocol QZPageListViewDelegate <NSObject>

- (void)skipPage:(QZ_INT)pageNum;
- (void)up:(id)sender;
- (void)down:(id)sender;
- (void)showDBN;
- (void)hideTheLeftView;
- (void)closeTheHeadTopView;
- (void)makeImageList:(PageImageList1 *)pageImageList withTagOfTap:(NSInteger)tapTag withTitle:(NSString *)titleName;
- (void)makeOneImageOfTap:(NSString *)imagePath withImageName:(NSString *)imageName;

//用来停止和开启父滚动视图的能否拖动
- (void)pageListViewOfSupSCStartDrag;
- (void)pageListViewOfSupSCStopDrag;

- (BOOL)closeTheBtnOfTheDown;

@end

@interface QZPageListView : UIView<QZPageToolTipImageViewDelegate,QZPageNavRectViewDelegate,QZPageNavButtonViewDelegate,QZPageToolTipDelegate,DrawDelegate,QZGalleryViewDelegate,QZImageGVDelegate,QZQuestionDelegate>
{
    UIButton *leftButton;
    UIButton *rightButton;
    NSMutableArray *array;
    QZEpubPage pageObj;
    id<QZPageListViewDelegate>delegate;
//    用来记录各种交互的数量的TAG值
    NSInteger indexToolTip;
    NSInteger indexToolImageTip;
    NSInteger indexNavRect;
    NSInteger indexNavButton;
    NSInteger indexVideo;
    NSInteger indexQuestion;
    NSInteger indexImage;
    NSInteger indeximageList;
    NSInteger indexVoice;
    NSInteger indexTextRoll;
    NSInteger indexWebLink;
    
//    控制播放视屏的参数
    BOOL isPlay;
    //是否打开目录等
    BOOL isOpenDBN;
//    增加联动书签
    UIImageView *bookMark;
}

@property (nonatomic, copy)NSString *pageName;
@property (nonatomic, assign)id<QZPageListViewDelegate>delegate;
@property (nonatomic, assign)NSInteger pageNumber;
@property (nonatomic, retain) ACMagnifyingGlass *magnifyingGlass;

- (void)isNowOpenDBN;
- (void)closeAllView;
- (void)save;
- (void)composition;
- (void)initIncomingData:(NSArray *)imageName;
- (void)isHaveTheBookMarkOnPage:(BOOL)isBookMark;
- (void)isHaveTheBookMarkForPage;
@end
