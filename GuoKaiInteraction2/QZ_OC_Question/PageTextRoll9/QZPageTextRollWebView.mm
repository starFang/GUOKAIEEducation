//
//  QZPageTextRollWebView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageTextRollWebView.h"

@implementation QZPageTextRollWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
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
    [webView setBackgroundColor:[UIColor clearColor]];
    NSString * str = [NSString stringWithFormat:@"file://%@",webPath];
    NSString *strURL = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    [webView loadRequest:request];
    [self addSubview: webView];
    [webView release];
}


@end
