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


#import "QZPageToolTipView.h"
#import "QZToolTipImageview.h"
#import "QZPageNavButtonView.h"
#include "QZPageNavRectView.h"


@protocol QZPageListViewDelegate <NSObject>

- (void)skipPage:(QZ_INT)pageNum;
- (void)up:(id)sender;
- (void)down:(id)sender;
- (void)showDBN;
- (void)hideTheLeftView;
- (void)closeTheView;
@end

@interface QZPageListView : UIView<QZPageToolTipImageViewDelegate,QZPageNavRectViewDelegate,QZPageNavButtonViewDelegate,QZPageToolTipDelegate,DrawDelegate>
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
}

@property (nonatomic, copy)NSString *pageName;
@property (nonatomic, assign)id<QZPageListViewDelegate>delegate;
@property (nonatomic, assign)NSInteger pageNumber;

- (void)isNowOpenDBN;
- (void)closeAllView;
- (void)save;
- (void)composition;
- (void)initIncomingData:(NSArray *)imageName;

@end
