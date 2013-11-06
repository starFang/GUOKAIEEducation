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

@protocol QZGalleryViewDelegate <NSObject>

- (void) makeImageWithContent:(PageImageList1 *)pageImageList withTagOfTap:(NSInteger)tapTag withTitle:(NSString *)titleName;

@end

@interface GalleryView : UIView<UIScrollViewDelegate,QZGalleryViewDelegate>
{
    UIScrollView *_gallerySCV;
    UIScrollView *smallSVC;
    UITapGestureRecognizer *_tapOneGesture;
#pragma mark - 数据
    NSMutableString *tit;
    PageImageList1 *_pageImageList;
    PageImageList *pImageList;
    CGFloat titHeight;
    CTView *ctv;
//    第几张图片
    NSInteger imageNum;
    id<QZGalleryViewDelegate>delegate;
}

@property (nonatomic, retain) UIScrollView *gallerySCV;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (retain, nonatomic) PageImageList1 *pageImageList;
@property (nonatomic, assign) id<QZGalleryViewDelegate>delegate;

- (void)composition;
- (void)initIncomingData:(PageImageList *)pageImageList;
@end
