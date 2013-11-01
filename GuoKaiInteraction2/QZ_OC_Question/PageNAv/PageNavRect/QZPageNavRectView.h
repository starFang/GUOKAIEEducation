//
//  QZPageNavRectView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"

@protocol QZPageNavRectViewDelegate <NSObject>

- (void)skip:(QZ_INT)pageNum;

@end

@interface QZPageNavRectView : UIView
{
    PageNavRect *pNavRect;
    UITapGestureRecognizer *oneTap;
    id<QZPageNavRectViewDelegate>delegate;
}
@property (nonatomic, assign)id<QZPageNavRectViewDelegate>delegate;
- (void)initIncomingData:(PageNavRect *)pageNavRect;
- (void)composition;

@end
