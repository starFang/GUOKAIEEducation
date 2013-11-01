//
//  IViewGV.m
//  ImageGesture
//
//  Created by qanzone on 13-9-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "IViewGV.h"
#import <QuartzCore/QuartzCore.h>

@implementation IViewGV

@synthesize ctV = _ctV;
@synthesize closeImageButton = _closeImageButton;
@synthesize delegate;
- (void)dealloc
{
    [self.ctV release];
    self.ctV = nil;
    self.closeImageButton = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithController];
    }
    return self;
}

- (void)initWithController
{
    
    self.backgroundColor = [UIColor blackColor];
    self.frame = CGRectMake(0, 0, 1024, 44);
    
    [self.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.layer setShadowRadius:10.0];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    
    self.closeImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeImageButton.frame = CGRectMake(20, 0, 44, 44);
    [self.closeImageButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeImageButton setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [self.closeImageButton setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
    [self addSubview: self.closeImageButton ];
    
    self.ctV = [[CTView alloc]init];
    self.ctV.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctV];

}

- (void)titleAndClose:(NSString *)title
{
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    //    字体和大小默认为Arial和66.0f 可随意设置
    [p setFont:@"Futura"];
    [p setSize:33];
    [p setColor:[UIColor colorWithRed:0.9 green:0.5 blue:0.7 alpha:1.0]];
    NSAttributedString * attString = [p attrStringFromMarkup:title];
    
    UIFont *font = [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:33];
    CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 44) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.width <= 1024-74)
    {
        self.ctV.frame  = CGRectMake(74 + (1024-74-size.width)/2, 3, size.width, 44);
    }else{
        self.ctV.frame  = CGRectMake(74 , 3, size.width, 44);
    }
    [self.ctV setAttString:attString];
}

-(void)pressButton:(id)sender
{
    [self.delegate closeTheImage];

}

@end
