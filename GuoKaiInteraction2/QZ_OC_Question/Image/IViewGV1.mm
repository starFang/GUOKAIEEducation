//
//  IViewGV.m
//  ImageGesture
//
//  Created by qanzone on 13-9-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "IViewGV1.h"
#import <QuartzCore/QuartzCore.h>


@implementation IViewGV1

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
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, 1024, 44);
    [self.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.layer setShadowRadius:10.0];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    self.closeImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeImageButton.frame = CGRectMake(20, 0, 44, 44);
    [self.closeImageButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeImageButton setImage:[UIImage imageNamed:@"g_close_image@2x.png"] forState:UIControlStateNormal];
    [self.closeImageButton setImage:[UIImage imageNamed:@"g_close_image@2x.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.closeImageButton];
    
    self.ctV = [[CTView alloc]init];
    self.ctV.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctV];

}

- (void)titleAndClose:(PageImage *)pageRichTextImage
{
    if (pageRichTextImage->stTitle.isRichText == YES)
    {
        [self isYesRichText:pageRichTextImage];
    }else{
        [self isNoRichText:pageRichTextImage];
    }
}

- (void)isYesRichText:(PageImage *)pageRichTextImage
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    for (int i = 0; i < pageRichTextImage->stTitle.vTextItemList.size(); i++)
    {
        switch (pageRichTextImage->stTitle.vTextItemList[i].pieceType)
        {
            
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pageRichTextImage->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbRed,pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbGreen,pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbBlue,pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pageRichTextImage->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pageRichTextImage->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pageRichTextImage->stTitle.vTextItemList[i].fontSize;
                
            }
                break;
            default:
                break;
        }
     }
    
    [p setFont:strFont];
    [p setSize:fontsize];
    UIFont *font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:33];
    CGSize size = [[NSString stringWithUTF8String:pageRichTextImage->stTitle.strText.c_str()] sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 44) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.width <= 1024-74) {
        self.ctV.frame  = CGRectMake(74 + (DW-74-size.width)/2, 3, size.width, 44);
    }else{
        self.ctV.frame  = CGRectMake(74 , 3, size.width, 44);
    }
    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
    [self.ctV setAttString:attString];
}

- (void)isNoRichText:(PageImage *)pageRichTextImage
{

    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    [p setFont:@"Arial Rounded MT Bold"];
    [p setSize:44];
    [p setColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    NSAttributedString * attString = [p attrStringFromMarkup:[NSString stringWithUTF8String:pageRichTextImage->stTitle.strText.c_str()]];
    
    UIFont *font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:33];
    CGSize size = [[NSString stringWithUTF8String:pageRichTextImage->stTitle.strText.c_str()] sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 44) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.width <= 1024-74) {
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
