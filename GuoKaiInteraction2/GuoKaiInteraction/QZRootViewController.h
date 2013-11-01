//
//  QZRootViewController.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZPageListView.h"

@interface QZRootViewController : UIViewController
<QZPageListViewDelegate>
{
    NSMutableArray * arrayImage;
    NSInteger indexImage;
   
}
- (void)saveDate;

@end
