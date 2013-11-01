//
//  QZRootViewController.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZPageListView.h"
#import "QZHeadTopView.h"
#import "QZDirectAndBMarkAndNotesView.h"

@interface QZRootViewController : UIViewController
<QZPageListViewDelegate,QZHeadTopViewDelegate,UIScrollViewDelegate,QZDBNDelegate>
{
    NSMutableArray * arrayImage;
    NSInteger indexImage;
    UIScrollView * upAndDown;
    UIScrollView *gScrollView;
    
    QZHeadTopView * headTopView;
    UIImageView *bookMark;
}
- (void)saveDate;

@end
