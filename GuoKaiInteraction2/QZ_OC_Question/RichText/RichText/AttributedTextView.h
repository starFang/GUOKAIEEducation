//
//  AttributedTextView.h
//  CookBook
//
//  Created by 岳宗申 on 13-8-24.
//  Copyright (c) 2013年 xujiangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributedTextView : UIView
{
  NSMutableAttributedString *attributedText;
    BOOL dBool;
}
//文本
@property (nonatomic, copy) NSString *text;
//行间距
@property (nonatomic, assign) NSInteger lineSpacing;
//颜色设置 前面字体颜色
@property (nonatomic, assign) CGFloat redFColorValue;
@property (nonatomic, assign) CGFloat greenFColorValue;
@property (nonatomic, assign) CGFloat blueFColorValue;
//后面字体颜色
@property (nonatomic, assign) CGFloat redHColorValue;
@property (nonatomic, assign) CGFloat greenHColorValue;
@property (nonatomic, assign) CGFloat blueHColorValue;
//前面多少字的颜色
@property (nonatomic, assign) NSInteger firstNum;
//设置字号大小
@property (nonatomic, assign) NSInteger fontSize;
//设置字体的段前间距
@property (nonatomic, assign) NSInteger pGFist;

@end
