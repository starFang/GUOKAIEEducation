//
//  QZPageToolTipView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"

@protocol QZPageToolTipDelegate <NSObject>

- (void)closeOtherToolTip;
- (void)bringTheSupV:(NSInteger)selfTagInSup;
//主要用于视图弹出及其它操作

@end

@interface QZPageToolTipView : UIView<QZPageToolTipDelegate>

{
    PageToolTip *pToolTip;
    UIView *textView;
    UIImageView *imageViewArrow;
    UIButton *button;
    id<QZPageToolTipDelegate>delegate;
    BOOL isApp;
}
@property (nonatomic, assign) NSInteger selfTag;
@property (nonatomic, assign) id<QZPageToolTipDelegate>delegate;

- (void)composition;
- (void)initIncomingData:(PageToolTip *)pageToolTip;
- (void)closeTheTextViewWithToolTipView;

@end
