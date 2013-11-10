//
//  QZPageTextRollWebView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageTextRollWebView.h"
#import <QuartzCore/QuartzCore.h>

@implementation QZPageTextRollWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    }
    return self;
}

- (void)initIncomingData:(PageTextRoll *)pageTextRoll
{
    pTextRoll = pageTextRoll;
}

- (void)composition
{
    NSString *webPath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"medias"] stringByAppendingPathComponent:[NSString stringWithUTF8String:pTextRoll->strFilePath.c_str()]];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(10,10,SFSW-20,SFSH-20)];
    [webView loadHTMLString:webPath baseURL:nil];
    [webView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    NSString * str = [NSString stringWithFormat:@"file://%@",webPath];
    NSString *strURL = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    [webView loadRequest:request];
    [self addSubview: webView];
    [webView release];
    
    UIScrollView  *scroller = [webView.subviews objectAtIndex:0];
    if (scroller) {
        for (UIView *v in [scroller subviews]) {
            if ([v isKindOfClass:[UIImageView class]])
            {
                v.hidden = YES;
            }
        }  
    }
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SFSW, 20)];
    view1.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    [view1.layer setShadowOffset:CGSizeMake(0, 10)];
    [view1.layer setShadowRadius:2.0];
    [view1.layer setShadowColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0].CGColor];
    [view1.layer setShadowOpacity:1.0];
    [self addSubview:view1];
    [view1 release];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, SFSH-25, SFSW, 20)];
    view2.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    [view2.layer setShadowOffset:CGSizeMake(0, -10)];
    [view2.layer setShadowRadius:2.0];
    [view2.layer setShadowColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0].CGColor];
    [view2.layer setShadowOpacity:1.0];
    [self addSubview:view2];
    [view2 release];
}


@end
