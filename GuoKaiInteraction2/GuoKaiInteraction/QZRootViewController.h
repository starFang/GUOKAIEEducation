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
#import "PageImageList1.h"
#import "PageImageListSubImage1.h"

#import "MBProgressHUD.h"

@interface QZRootViewController : UIViewController
<QZPageListViewDelegate,QZHeadTopViewDelegate,UIScrollViewDelegate,QZDBNDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray * arrayImage;
    NSInteger indexImage;
    QZHeadTopView * headTopView;
    UIImageView *bookMark;
//    准备用于下拉加书签和翻页使用
    UIScrollView * upAndDown;
    BOOL isHaveTheMark;
    UIScrollView *gScrollView;
//    是否存在书签(用于记录滑动的时候)
    BOOL isSCHaveBookMark;
//    主要用于画廊和单张图片的制作
    NSInteger imageListCount;
    PageImageList1 *pImageList;
//    是否存在下面的按钮
    BOOL isHaveTheDownBtn;
    BOOL isTheDBNAtTheLeft;
    //定义一个全局变量，用于存放书签
    NSMutableArray *_bookMarkArray;
//  缓冲动画
    MBProgressHUD * HUD;
}

@property (nonatomic, retain) NSMutableArray *bookMarkArray;
+(QZRootViewController *)shareQZRoot;
- (void)saveDate;

@end
