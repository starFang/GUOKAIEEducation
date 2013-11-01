//
//  QZPageWebLinkView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageWebLinkView.h"

@implementation QZPageWebLinkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initIncomingData:(PageWebLink *)pageWebLink
{
    pWebLink = pageWebLink;
}
- (void)composition
{
    UITapGestureRecognizer * oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:oneTap];
    [oneTap release];

}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:pWebLink->strHtmlPath.c_str()]]];
}

@end
