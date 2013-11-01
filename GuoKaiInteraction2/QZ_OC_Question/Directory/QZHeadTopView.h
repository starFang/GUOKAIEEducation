//
//  QZHeadTopView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-31.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QZHeadTopViewDelegate <NSObject>

- (void)showDirectory;
- (void)addBookMark;
- (void)deleteBookMark;

@end

@interface QZHeadTopView : UIView<QZHeadTopViewDelegate>
{
//   书架
    UIButton *BookshelfBtn;
//   目录
    UIButton *DirectoryBtn;
//   书签
    UIButton *BookMarkBtn;
    id<QZHeadTopViewDelegate>delegate;
}

@property (nonatomic, assign)id<QZHeadTopViewDelegate>delegate;
- (void)composition;
- (void)bookMarkYES;
- (void)bookMarkNO;
@end
