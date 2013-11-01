//
//  QZPageToolTipView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"
#import "CTView.h"

@protocol QZPageToolTipDelegate <NSObject>

- (void)closeOtherToolTip;

@end

@interface QZPageToolTipView : UIView<QZPageToolTipDelegate>

{
    PageToolTip *pToolTip;
    UIView *textView;
    UIButton *button;
    id<QZPageToolTipDelegate>delegate;
    BOOL isApp;
}
@property (nonatomic, retain) CTView *ctv;
@property (nonatomic, assign) id<QZPageToolTipDelegate>delegate;

- (void)composition;
- (void)initIncomingData:(PageToolTip *)pageToolTip;
- (void)closeTheTextViewWithToolTipView;

@end
