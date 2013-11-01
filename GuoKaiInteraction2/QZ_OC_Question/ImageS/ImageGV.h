//
//  ImageGV.h
//  ImageGesture
//
//  Created by qanzone on 13-9-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IViewGV.h"

@protocol MutualDelegate <NSObject>

- (void)contentSize;
- (void)tapImageBig:(NSString *)name;
- (void)panImage:(NSString *)name;
- (void)removeFromTheView:(NSString *)name;

@end

@interface ImageGV : UIView
<UIGestureRecognizerDelegate,closeImageDelegate>

{
    UIRotationGestureRecognizer *_rotationGesture;
    UIPanGestureRecognizer *_panGesture;
    UIPinchGestureRecognizer *_pinchGesture;
    UITapGestureRecognizer *_tapOneGesture;
    UIImageView *_imageView;
    
//    坐标问题
    CGPoint startPoint;
    BOOL isEqualPoint;
//用来记录拉动中的center的开始和结束位置
    CGPoint firstPoint;
    CGPoint lastPoint;
    
    CGRect startRect;
    CGRect endRect;
    
    CGPoint distancePoint;
    
//    原始图片的大小
    CGFloat imageW;
    CGFloat imageH;
    
    IViewGV *iView;
//    记录图片是否是最大化
    BOOL isImageBig;
    
    id <MutualDelegate> delegate;
    NSString *imageNameNew;
}
@property (nonatomic,copy) NSString *imageNameNew;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) CGFloat lastRotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, retain) CALayer * backLayer;
@property (nonatomic, assign) id<MutualDelegate>delegate;

- (void)loadImage:(NSString *)imageName;

@end
