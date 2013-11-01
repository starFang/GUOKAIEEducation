//
//  QZDirectAndBMarkAndNotesView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-31.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZDirectAndBMarkAndNotesView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_gTableView;
    NSMutableArray *_dataSource;
}

@property (nonatomic, retain)UITableView *gTableView;
@property (nonatomic, retain)NSMutableArray *dataSource;

- (void)composition;

@end
