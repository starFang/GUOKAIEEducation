//
//  QZHeadTopView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-31.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZHeadTopView.h"

@implementation QZHeadTopView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)composition
{
    BookshelfBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [BookshelfBtn setTitle:@"书架" forState:UIControlStateNormal];
    BookshelfBtn.frame = CGRectMake(20, 6, 50, 30);
    [BookshelfBtn addTarget:self action:@selector(pressBtnOfBookshelf:) forControlEvents:UIControlEventTouchUpInside];
    
    DirectoryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [DirectoryBtn setTitle:@"目录" forState:UIControlStateNormal];
    DirectoryBtn.frame = CGRectMake(70+15, 6, 40, 30);
    [DirectoryBtn addTarget:self action:@selector(pressBtnOfDirectory:) forControlEvents:UIControlEventTouchUpInside];
    
    BookMarkBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [BookMarkBtn setTitle:@"书签" forState:UIControlStateNormal];
    BookMarkBtn.frame = CGRectMake(DW - 70, 6, 40, 30);
    [DirectoryBtn addTarget:self action:@selector(pressBtnOfBookMark:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:BookshelfBtn];
    [self addSubview:DirectoryBtn];
    [self addSubview:BookMarkBtn];
}

- (void)pressBtnOfBookshelf:(id)sender
{
    
}

- (void)pressBtnOfDirectory:(id)sender
{
    NSLog(@"-----------------------------");
    [self.delegate showDirectory];
    
}

- (void)pressBtnOfBookMark:(id)sender
{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
