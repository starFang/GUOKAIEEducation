//
//  drawLine.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-26.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPage.h"
#include <vector>

@protocol DrawDelegate <NSObject>

- (void)popView;
- (void)bringFromTheFirst;
- (void)comeBackTheIndex;
- (void)closeView;

//开启滚动视图-滚动
- (void)scrollSCStart;

//滚动视图填充下面的区域
- (BOOL)closeTheDownBtn;

//用于划线文字的放大镜
- (void)pressLongBegin:(CGPoint)point;
- (void)pressLongChange:(CGPoint)point;
- (void)pressLongEnd:(CGPoint)point;

@end

@interface DrawLine : UIView
<UIGestureRecognizerDelegate,DrawDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
   QZEpubPage *pageObj;
   std::vector<QZ_BOX> vBoxes;
   UILongPressGestureRecognizer *_longPressGestureRecognizer;
   UITapGestureRecognizer *_tapGestureRecognizer;
//    记录是否是文字
    BOOL isWord;
    QZ_POS startPos;
    QZ_POS endPos;
    NSMutableDictionary *lineDictionary;
    NSMutableArray *arraySQL;
//  画线按钮
    UIButton *redBtn;
    UIButton *blueBtn;
    UIButton *purpleBtn;
    NSMutableString *lineColor;
//  删除线的ID
    NSMutableString *insertDate;
    NSString *newColor;
    NSString *oldColor;
    
//  弹出笔记框；
    UIImageView  *noteFrame;
//  笔记框的可编辑区域;
    UITextView *textView;
//  批注控制
    id<DrawDelegate>delegate; 
}
@property (nonatomic, assign)id<DrawDelegate>delegate;
@property (nonatomic, assign) NSInteger pageNumber;
- (void)composition;
- (void)incomingData:(QZEpubPage *)pObj;
- (void)saveData;
@end
