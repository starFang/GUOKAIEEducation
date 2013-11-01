//
//  QZPageNavRectView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageNavRectView.h"

@implementation QZPageNavRectView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initIncomingData:(PageNavRect *)pageNavRect
{
    pNavRect = pageNavRect;
}

- (void)composition
{
    oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:oneTap];
    
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.delegate skip:pNavRect->nPageIndex];
}

- (void)dealloc
{
    [oneTap release];
    [super dealloc];
}

@end
