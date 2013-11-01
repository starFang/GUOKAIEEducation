//
//  GalleryView.h
//  ImageGesture
//
//  Created by qanzone on 13-9-27.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTView.h"
#import "MarkupParser.h"
#import "PageImageList1.h"
#import "PageImageListSubImage1.h"
#import "QZEpubPageObjs.h"

@interface GalleryView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_gallerySCV;
    UITapGestureRecognizer *_tapOneGesture;
#pragma mark - 数据
    NSMutableString *tit;
    PageImageList1 *_pageImageList;
    PageImageList *pImageList;
    CGFloat titHeight;
    CTView *ctv;
//    判断是否是全屏
    BOOL isBigScreen;
//    第几张图片
    NSInteger imageNum;
}

@property (nonatomic, retain) UIScrollView *gallerySCV;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (retain, nonatomic) PageImageList1 *pageImageList;

- (void)composition;
- (void)initIncomingData:(PageImageList *)pageImageList;

@end
