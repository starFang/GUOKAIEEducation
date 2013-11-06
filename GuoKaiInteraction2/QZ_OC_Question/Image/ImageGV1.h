//
//  ImageGV.h
//  ImageGesture
//
//  Created by qanzone on 13-9-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IViewGV1.h"
#import "CTView.h"
#include "QZEpubPageObjs.h"

@protocol QZImageGVDelegate <NSObject>

- (void)makeOneImage:(NSString *)imagePath;

@end

@interface ImageGV1 : UIView
<UIGestureRecognizerDelegate,closeImageDelegate,QZImageGVDelegate>
{
    
    PageImage *pImage;
    UITapGestureRecognizer *_tapOneGesture;
    UIImageView *_imageView;
    CGRect startRect;
    CGRect imageRect;
    IViewGV1 *iView;
//    记录图片是否是最大化
    BOOL isImageBig;
    id<QZImageGVDelegate>delegate;
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) CALayer * backLayer;
@property (nonatomic, retain) CTView *ctV;
@property (nonatomic, assign) id<QZImageGVDelegate>delegate;

- (void)initIncomingData:(PageImage *)pageImage;
- (void)composition;

@end
