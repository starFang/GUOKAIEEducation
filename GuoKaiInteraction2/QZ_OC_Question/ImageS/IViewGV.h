//
//  IViewGV.h
//  ImageGesture
//
//  Created by qanzone on 13-9-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTView.h"
#import "MarkupParser.h"

@protocol closeImageDelegate <NSObject>

- (void)closeTheImage;

@end

@interface IViewGV : UIView
{
    MarkupParser *markParser;
    UIButton *_closeImageButton;
    id <closeImageDelegate>delegate;
}

@property (nonatomic, retain) CTView *ctV;
@property (nonatomic, retain) UIButton *closeImageButton;
@property (nonatomic, assign) id<closeImageDelegate>delegate;

//设置标题
- (void)titleAndClose:(NSString *)title;
@end
