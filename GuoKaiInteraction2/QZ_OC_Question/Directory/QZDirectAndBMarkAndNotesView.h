//
//  QZDirectAndBMarkAndNotesView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-31.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QZDBNDelegate <NSObject>

- (void)openTheSelectedPage:(NSInteger)pageNum;

@end

@interface QZDirectAndBMarkAndNotesView : UIView<UITableViewDataSource,UITableViewDelegate,QZDBNDelegate>
{
    UITableView *_gTableView;
    NSMutableArray *_dataSource;
    UIButton *DirectBtn;
    UIButton *BookMarkBtn;
    UIButton *NotesMarkBtn;
    id<QZDBNDelegate>delegate;
}

@property (nonatomic, retain)UITableView *gTableView;
@property (nonatomic, retain)NSMutableArray *dataSource;
@property (nonatomic, assign)id<QZDBNDelegate>delegate;

- (void)composition;

@end
