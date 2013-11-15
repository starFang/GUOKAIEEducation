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
//主要用于视图弹出及其它操作
- (void)createPageToolTipView:(PageToolTip *)pageToolTip withFrame:(CGRect)frame andWithAngleFrame:(CGRect)angleFrame withImageName:(NSString *)imageName;
- (void)createTheTipViewOfText:(PageToolTip *)pageToolTip;

@end

@interface QZPageToolTipView : UIView<QZPageToolTipDelegate>
{
    PageToolTip *pToolTip;
    UIButton *button;
    id<QZPageToolTipDelegate>delegate;
    CGRect tipFrame;
    CGRect angleFrame;
    NSString *imageName;
}
@property (nonatomic, assign) id<QZPageToolTipDelegate>delegate;

- (void)composition;
- (void)initIncomingData:(PageToolTip *)pageToolTip;

@end
