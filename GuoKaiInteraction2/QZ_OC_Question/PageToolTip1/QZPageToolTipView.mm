//
//  QZPageToolTipView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageToolTipView.h"
#import "MarkupParser.h"
#import <QuartzCore/QuartzCore.h>
@implementation QZPageToolTipView

@synthesize ctv = _ctv;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initIncomingData:(PageToolTip *)pageToolTip
{
 pToolTip = pageToolTip;
}

- (void)composition
{
    [self createPress];
}

- (void)createView
{
    textView = [[UIView alloc]init];
    textView.hidden = YES;
    textView.backgroundColor = [UIColor
                                colorWithRed:pToolTip->bgColor.rgbRed/255.0
                                green:pToolTip->bgColor.rgbGreen/255.0
                                blue:pToolTip->bgColor.rgbBlue/255.0
                                alpha:pToolTip->bgColor.rgbAlpha/255.0];
    
    [textView.layer setShadowOffset:CGSizeMake(1, 1)];
    [textView.layer setShadowRadius:10.0];
    [textView.layer setShadowColor:[UIColor blackColor].CGColor];
    [textView.layer setShadowOpacity:1.0];
    CGRect tRect;
    if (pToolTip->rect.X0 <= DW/2.0 && pToolTip->rect.Y0 <= DH/2.0)
    {
        if (pToolTip->rect.X0 < 0)
        {
           tRect = CGRectMake(-pToolTip->rect.X0+20 ,SFSH,pToolTip->nWidth,pToolTip->nHeight);
        }else{
        tRect = CGRectMake(0,SFSH,pToolTip->nWidth,pToolTip->nHeight);
        }
        
     }else if (pToolTip->rect.X0 <= DW/2.0 && pToolTip->rect.Y0 > DH/2.0){
        
        if (pToolTip->rect.X0 < 0)
        {
            tRect = CGRectMake(-pToolTip->rect.X0+20,-SFSH,pToolTip->nWidth,pToolTip->nHeight);
        }else{
            tRect = CGRectMake(0,-SFSH,pToolTip->nWidth,pToolTip->nHeight);
        }
        
    }else if(pToolTip->rect.X0 > DW/2.0 && pToolTip->rect.Y0 <= DH/2.0)
    {
        if (pToolTip->rect.X1 > DW)
        {
          tRect = CGRectMake(SFSW - pToolTip->nWidth + (DW - pToolTip->rect.X1)-20,SFSH,pToolTip->nWidth,pToolTip->nHeight);
        }else{
           tRect = CGRectMake(SFSW - pToolTip->nWidth,SFSH,pToolTip->nWidth,pToolTip->nHeight); 
        }
     
    }else{
        if (pToolTip->rect.X1 > DW)
        {
            tRect = CGRectMake(SFSW - pToolTip->nWidth + (DW - pToolTip->rect.X1)-20,-SFSH,pToolTip->nWidth,pToolTip->nHeight);
        }else{
         tRect = CGRectMake(SFSW - pToolTip->nWidth,-SFSH,pToolTip->nWidth,pToolTip->nHeight);   
        }
    
    }
    textView.frame = tRect;
    [self addSubview:textView];
}


- (void)text
{
    if (pToolTip->strTipText.isRichText == YES)
    {
        [self isYesRichText:pToolTip];
    }else{
        [self isNoRichText:pToolTip];
    }
}

- (void)isYesRichText:(PageToolTip *)pageToolTip
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    for (int i = 0; i < pageToolTip->strTipText.vTextItemList.size(); i++)
    {
        switch (pageToolTip->strTipText.vTextItemList[i].pieceType)
        {

            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pageToolTip->strTipText.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pageToolTip->strTipText.vTextItemList[i].fontColor.rgbRed,pageToolTip->strTipText.vTextItemList[i].fontColor.rgbGreen,pageToolTip->strTipText.vTextItemList[i].fontColor.rgbBlue,pageToolTip->strTipText.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pageToolTip->strTipText.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pageToolTip->strTipText.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pageToolTip->strTipText.vTextItemList[i].fontSize;
                
            }
                break;

            default:
                break;
        }
    }

    UIFont *font = [UIFont fontWithName:strFont size:fontsize*1.1];
//    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(textView.FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel *label = [[UILabel alloc]init];
    label.frame = textView.bounds;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = font;
    label.text = string;
    [textView addSubview:label];
    [label release];
    
//    暂时用UILabel显示
//    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
//    self.ctv.frame  = CGRectMake(0, 0, textView.FSW , textView.FSH);
//    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
//    [self.ctv setAttString:attString];
//    [textView addSubview:self.ctv];
    
}

- (void)isNoRichText:(PageToolTip *)pageToolTip
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = textView.bounds;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.text = [NSString stringWithUTF8String:pToolTip->strTipText.strText.c_str()];
    [textView addSubview:label];
    [label release];
}

- (void)createPress
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    [button addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    [self addSubview:button];
    isApp = NO;
}

- (void)handleSingleTap:(UIButton *)btn
{
    if (!isApp)
    {
        [self createView];
        [self text];
    }
    isApp = YES;
    
    [self.delegate closeOtherToolTip];
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
    [self.ctv release];
    [textView release];
    [super dealloc];
}

@end
