//
//  QZPageNavButtonView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageNavButtonView.h"



@implementation QZPageNavButtonView

@synthesize fist;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initIncomingData:(PageNavButton *)pageNavButton
{
    pNavButton = pageNavButton;
}

- (void)composition
{
    [self popTheView];
}

- (void)popTheView
{
    pressView = [UIButton buttonWithType:UIButtonTypeCustom];
    [pressView setBackgroundImage:[UIImage imageNamed:@"codelujingtishi.png"] forState:UIControlStateNormal];
    pressView.frame = self.bounds;
    [pressView addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    pressView.selected = NO;
    [self addSubview:pressView];
    
    [pressView addTarget:self action:@selector(pressOne:) forControlEvents:UIControlEventTouchDown];
    [pressView addTarget:self action:@selector(cancelThePress) forControlEvents:UIControlEventTouchDragOutside];
    [pressView addTarget:self action:@selector(cancelThePress) forControlEvents:UIControlEventTouchDragExit];
    [pressView addTarget:self action:@selector(cancelThePress) forControlEvents:UIControlEventTouchCancel];
}

- (void)pressOne:(UIButton *)button
{
    [UIView animateWithDuration:0.1 animations:^{
    pressView.transform = CGAffineTransformMakeScale(1.1,1.1);
  
    }];
}

- (void)cancelThePress
{
    [UIView animateWithDuration:0.1 animations:^{
        pressView.transform = CGAffineTransformMakeScale(1.0,1.0);
        
    }];
}

- (void)handleSingleTap:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        [self.delegate popBtnView:pNavButton];
    }else{
        [self.delegate closeBtnView:pNavButton];
    }
    [self cancelThePress];
}

- (void)dealloc
{

    [super dealloc];
}

@end
