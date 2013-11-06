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

@interface QZRootViewController : UIViewController
<QZPageListViewDelegate,QZHeadTopViewDelegate,UIScrollViewDelegate,QZDBNDelegate>
{
    NSMutableArray * arrayImage;
    NSInteger indexImage;
    QZHeadTopView * headTopView;
    UIImageView *bookMark;
//    准备用于下拉加书签和翻页使用
    UIScrollView * upAndDown;
    BOOL isHaveTheMark;
    UIScrollView *gScrollView;
    
//    主要用于画廊和单张图片的制作
    NSInteger imageListCount;
    PageImageList1 *pImageList;
}
- (void)saveDate;

@end
