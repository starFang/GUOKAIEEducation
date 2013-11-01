//
//  QZPageNavButtonView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"

@protocol QZPageNavButtonViewDelegate <NSObject>
-(void)popBtnView:(PageNavButton *)pageNavButton;
-(void)closeBtnView:(PageNavButton *)pageNavButton;
@end

@interface QZPageNavButtonView : UIView
{
    PageNavButton *pNavButton;
    UIButton *pressView;
    
    NSInteger fist;
    CGRect startRect;
    id<QZPageNavButtonViewDelegate>delegate;
}

@property (nonatomic, assign) NSInteger fist;
@property (nonatomic, assign) id<QZPageNavButtonViewDelegate>delegate;
- (void)initIncomingData:(PageNavButton *)pageNavButton;
- (void)composition;
@end
