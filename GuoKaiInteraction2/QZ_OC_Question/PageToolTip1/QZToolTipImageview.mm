//
//  QZToolTipImageview.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZToolTipImageview.h"

@implementation QZToolTipImageview

@synthesize delegate;
@synthesize fist;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)initIncomingData:(PageToolImageTip *)pageToolImageTip
{
    pToolImageTip = pageToolImageTip;
}

- (void)composition
{
    [self textView];
    [self press];
}

- (void)press
{
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    CGFloat x0 = pToolImageTip->rect.X0;
    CGFloat x1 = pToolImageTip->rect.X1;
    CGFloat y0 = pToolImageTip->rect.Y0;
    CGFloat y1 = pToolImageTip->rect.Y1;
    
    
    if (self.fist == 1)
    {
        button.frame = CGRectMake(SFSW/2-(x1-x0)/2,0,x1-x0,y1-y0);
    }
    else if (self.fist == 2)
    {
        
        button.frame = CGRectMake(SFSW/2-(x1-x0)/2,0,x1-x0,y1-y0);
    
    }
    else if (self.fist == 3)
    {
        
        button.frame = CGRectMake(SFSW/2-(x1-x0)/2,SFSH-(y1-y0),x1-x0,y1-y0);
    }
    else if (self.fist == 4)
    {
        button.frame = CGRectMake(SFSW/2-(x1-x0)/2,SFSH-(y1-y0),x1-x0,y1-y0);
    }
    
    [button addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    [self addSubview:button];
}

- (void)textView
{
    CGFloat x0 = pToolImageTip->rect.X0;
    CGFloat x1 = pToolImageTip->rect.X1;
    CGFloat y0 = pToolImageTip->rect.Y0;
    CGFloat y1 = pToolImageTip->rect.Y1;
    
    
    if (self.fist == 1)
    {
        textView.frame = CGRectMake((SFSW - pToolImageTip->nWidth)/2,y1-y0+20,pToolImageTip->nWidth,pToolImageTip->nHeight);
    }
    else if (self.fist == 2)
    {
        
         textView.frame = CGRectMake((SFSW - pToolImageTip->nWidth)/2,y1-y0+20,pToolImageTip->nWidth,pToolImageTip->nHeight);
        
    }
    else if (self.fist == 3)
    {
        
         textView.frame = CGRectMake((SFSW - pToolImageTip->nWidth)/2,0,pToolImageTip->nWidth,pToolImageTip->nHeight);
    }
    else if (self.fist == 4)
    {
        textView.frame = CGRectMake((SFSW - pToolImageTip->nWidth)/2,0,pToolImageTip->nWidth,pToolImageTip->nHeight);
    }
    
    textView = [[UIWebView alloc]initWithFrame:self.bounds];
    
    textView.hidden = YES;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:pToolImageTip->filePath.c_str()]]];
    [textView loadRequest:request];
    [self addSubview: textView];
    [textView release];
}

- (void)handleSingleTap:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        textView.hidden = NO;
    }else{
        textView.hidden = YES;
    }
}

- (void)closeTheTextViewWithToolTipView
{
    textView.hidden = YES;
}


- (void)dealloc
{
    [textView release];
    [super dealloc];
}


@end
