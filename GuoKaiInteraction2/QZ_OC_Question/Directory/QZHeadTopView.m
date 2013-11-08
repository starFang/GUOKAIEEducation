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
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, SFSW, SFSH);
    [imageView setImage:[UIImage imageNamed:@"g_headTop.png"]];
    [self addSubview:imageView];
    [imageView release];
    
    BookshelfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BookshelfBtn setImage:[UIImage imageNamed:@"g_BookShelf@2x.png"] forState:UIControlStateNormal];
    BookshelfBtn.frame = CGRectMake(30, 6, 40, 30);
    [BookshelfBtn addTarget:self action:@selector(pressBtnOfBookshelf:) forControlEvents:UIControlEventTouchUpInside];
    
    
    DirectoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    DirectoryBtn.frame = CGRectMake(70+15, 6, 40, 30);
    [DirectoryBtn setImage:[UIImage imageNamed:@"g_DBN_Menu@2x.png"] forState:UIControlStateNormal];
    [DirectoryBtn addTarget:self action:@selector(pressBtnOfDirectory:) forControlEvents:UIControlEventTouchUpInside];
    
    
    BookMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    BookMarkBtn.frame = CGRectMake(DW - 70, 6, 20, 30);
    [BookMarkBtn setImage:[UIImage imageNamed:@"g_DBN_BookMark_select@2x.png"]forState:UIControlStateNormal];
    [BookMarkBtn setImage:[UIImage imageNamed:@"g_DBN_BookMark_selected@2x.png"] forState:UIControlStateSelected];
    BookMarkBtn.selected = NO;
    [BookMarkBtn addTarget:self action:@selector(pressBtnOfBookMark:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:BookshelfBtn];
    [self addSubview:DirectoryBtn];
    [self addSubview:BookMarkBtn];
}

- (void)pressBtnOfBookshelf:(id)sender
{
    
}

- (void)pressBtnOfDirectory:(id)sender
{
    [self.delegate showDirectory];
}

- (void)pressBtnOfBookMark:(id)sender
{
    BookMarkBtn.selected = !BookMarkBtn.selected;
    if (BookMarkBtn.selected)
    {
       [self.delegate addBookMark]; 
    }else{
        [self.delegate deleteBookMark];
    }
}

- (void)bookMarkYES
{
    BookMarkBtn.selected = YES;
}

- (void)bookMarkNO
{
    BookMarkBtn.selected = NO;
}


@end
