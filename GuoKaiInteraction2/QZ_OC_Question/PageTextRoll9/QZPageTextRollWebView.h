//
//  QZPageTextRollWebView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZEpubPageObjs.h"
@interface QZPageTextRollWebView : UIView
{
    PageTextRoll *pTextRoll;
}
- (void)composition;
- (void)initIncomingData:(PageTextRoll *)pageTextRoll;
@end
