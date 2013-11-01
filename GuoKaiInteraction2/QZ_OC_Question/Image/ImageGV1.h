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

@interface ImageGV1 : UIView
<UIGestureRecognizerDelegate,closeImageDelegate>
{
    
    PageImage *pImage;
    UITapGestureRecognizer *_tapOneGesture;
    UIImageView *_imageView;
    CGRect startRect;
    CGRect imageRect;
    IViewGV1 *iView;
//    记录图片是否是最大化
    BOOL isImageBig;
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) CALayer * backLayer;
@property (nonatomic, retain) CTView *ctV;
- (void)initIncomingData:(PageImage *)pageImage;
- (void)composition;

@end
