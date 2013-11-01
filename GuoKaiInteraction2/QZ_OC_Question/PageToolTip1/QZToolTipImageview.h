//
//  QZToolTipImageview.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"

@protocol QZPageToolTipImageViewDelegate <NSObject>

- (void)closeTheTextView;

@end
@interface QZToolTipImageview : UIView<QZPageToolTipImageViewDelegate>
{
    id<QZPageToolTipImageViewDelegate>delegate;
    PageToolImageTip *pToolImageTip;
    
    UIWebView *textView;
    UIButton *button;
    NSInteger fist;
}

@property (nonatomic, assign)id<QZPageToolTipImageViewDelegate>delegate;
@property (nonatomic ,assign)NSInteger fist;
- (void)composition;
- (void)initIncomingData:(PageToolImageTip *)pageToolImageTip;
- (void)closeTheTextViewWithToolTipView;
@end
