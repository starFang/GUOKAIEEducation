//
//  UIQuestButton.h
//  logo
//
//  Created by qanzone on 13-11-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIQuestButton : UIControl
{
    UIImageView *_subImageV;
    UILabel *_subLabelA;
    UILabel *_subLabelContent;
    
    NSString *_subImageName;
    NSString *_subAName;
    NSString *_subLContentName;
}
@property (nonatomic, retain) UIImageView *subImageV;
@property (nonatomic, retain) UILabel *subLabelA;
@property (nonatomic, retain) UILabel *subLabelContent;

@property (nonatomic, copy) NSString *subImageName;
@property (nonatomic, copy) NSString *subAName;
@property (nonatomic, copy) NSString *subLContentName;
//设置坐标偏移距离
@property (nonatomic, assign) CGFloat headLength;

- (void)buju;

@end
