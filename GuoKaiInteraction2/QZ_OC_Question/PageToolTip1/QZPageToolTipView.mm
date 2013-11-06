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
    
    BOOL isW = YES;
    if (pToolTip->bgColor.rgbRed == pToolTip->bgColor.rgbGreen && pToolTip->bgColor.rgbGreen == pToolTip->bgColor.rgbBlue && pToolTip->bgColor.rgbBlue == 255)
    {
        isW = YES;
    }else{
        isW = NO;
    }
    
    textView.layer.cornerRadius = 10.0;
    textView.layer.masksToBounds = YES;
    [textView.layer setShadowOffset:CGSizeMake(5, 5)];
    [textView.layer setShadowRadius:10.0];
    [textView.layer setShadowColor:[UIColor blackColor].CGColor];
    [textView.layer setShadowOpacity:1.0];
    
#pragma mark - 各种尖角的位置
    CGRect qRect;
    UIImage *image;
#pragma mark - 各种坐标计算
    CGRect tRect;
//    中间点
    CGFloat centreL = (pToolTip->rect.X0 + pToolTip->rect.X1)/2;
    CGFloat centre = (pToolTip->rect.X0 + pToolTip->rect.X1)/2 - pToolTip->rect.X0;
    
    if (pToolTip->rect.X0 <= DW/2.0 && pToolTip->rect.Y0 <= DH/2.0)
    {
        if (pToolTip->rect.X0 < 0)
        {
        tRect = CGRectMake(-pToolTip->rect.X0+20 ,SFSH + TIP_POP_HEIGHT_OF_TAP,pToolTip->nWidth,pToolTip->nHeight);
        }else{
            if (centreL - (pToolTip->nWidth/2) >= 20)
            {
               tRect = CGRectMake(centre-pToolTip->nWidth/2,
                                  SFSH + TIP_POP_HEIGHT_OF_TAP,
                                  pToolTip->nWidth ,pToolTip->nHeight);
            }else{
               tRect = CGRectMake(0,SFSH + TIP_POP_HEIGHT_OF_TAP,
                                  pToolTip->nWidth ,pToolTip->nHeight);
            }
        }
         qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, SFSH + TIP_POP_HEIGHT_OF_TAP/2, 30, 20);
        
        if (isW) {
            image  =[UIImage imageNamed:@"g_tip_up_w.png"];
        }else{
            image  =[UIImage imageNamed:@"g_tip_up_y.png"];
        }
        
        
      }else if (pToolTip->rect.X0 <= DW/2.0 && pToolTip->rect.Y0 > DH/2.0){
        
        if (pToolTip->rect.X0 < 0)
        {
            tRect = CGRectMake(-pToolTip->rect.X0+20,-SFSH-TIP_POP_HEIGHT_OF_TAP,pToolTip->nWidth,pToolTip->nHeight);
        }else{
            
            if (centreL + (pToolTip->nWidth/2) >= 20)
            {
                tRect = CGRectMake(centre-(pToolTip->nWidth/2),-TIP_POP_HEIGHT_OF_TAP-pToolTip->nHeight,pToolTip->nWidth ,pToolTip->nHeight);
            }else{
                tRect = CGRectMake(0,-TIP_POP_HEIGHT_OF_TAP-pToolTip->nHeight,pToolTip->nWidth,pToolTip->nHeight);
            }
        }
        qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, -TIP_POP_HEIGHT_OF_TAP, 30, 20);
          
          if (isW) {
              image  =[UIImage imageNamed:@"g_tip_down_w.png"];
          }else{
              image  =[UIImage imageNamed:@"g_tip_down_y.png"];
          }
    }else if(pToolTip->rect.X0 > DW/2.0 && pToolTip->rect.Y0 <= DH/2.0){
        if (pToolTip->rect.X1 > DW)
        {
          tRect = CGRectMake(SFSW - pToolTip->nWidth + (DW - pToolTip->rect.X1)-20,
                             SFSH+TIP_POP_HEIGHT_OF_TAP,
                             pToolTip->nWidth,pToolTip->nHeight);
        }else{
            if (centreL + (pToolTip->nWidth/2) <= DW-20)
            {
                tRect = CGRectMake(centre-(pToolTip->nWidth/2),SFSH+TIP_POP_HEIGHT_OF_TAP,pToolTip->nWidth ,pToolTip->nHeight);
            }else{
                tRect = CGRectMake(SFSW - pToolTip->nWidth,
                                   SFSH+TIP_POP_HEIGHT_OF_TAP,
                                   pToolTip->nWidth,pToolTip->nHeight);
            }
        }
        qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, SFSH+TIP_POP_HEIGHT_OF_TAP/2, 30, 20);
        if (isW) {
            image  =[UIImage imageNamed:@"g_tip_up_w.png"];
        }else{
            image  =[UIImage imageNamed:@"g_tip_up_y.png"];
        }
    }else{
        
        if (pToolTip->rect.X1 > DW)
        {
            tRect = CGRectMake(SFSW - pToolTip->nWidth + (DW - pToolTip->rect.X1)-20,
                               -TIP_POP_HEIGHT_OF_TAP-pToolTip->nHeight,
                               pToolTip->nWidth,pToolTip->nHeight);
        }else{
            if (centreL + (pToolTip->nWidth/2) <= DW-20)
            {
                tRect = CGRectMake(centre-(pToolTip->nWidth/2),
                                   -TIP_POP_HEIGHT_OF_TAP-pToolTip->nHeight,
                                   pToolTip->nWidth,pToolTip->nHeight);
            }else{
                tRect = CGRectMake(SFSW - pToolTip->nWidth,
                                   -TIP_POP_HEIGHT_OF_TAP-pToolTip->nHeight,
                                   pToolTip->nWidth,pToolTip->nHeight);
            } 
        }
        
        qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, -TIP_POP_HEIGHT_OF_TAP, 30, 20);
        if (isW) {
            image  =[UIImage imageNamed:@"g_tip_down_w.png"];
        }else{
            image  =[UIImage imageNamed:@"g_tip_down_y.png"];
        }
    }
    imageViewArrow = [[UIImageView alloc]initWithFrame:qRect];
    imageViewArrow.hidden = YES;
    [imageViewArrow setImage:image];
    [self addSubview:imageViewArrow];
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
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                if (string && ![string isEqualToString:@""])
                {
                    [string appendString:@"\n"];
                }
            }
                break;
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

    UIFont *font = [UIFont fontWithName:strFont size:fontsize];
    UILabel *label = [[UILabel alloc]init];
//    [label drawTextInRect:CGRectMake(11, 11, textView.FSW-22, textView.FSH - 22)];
    label.frame= CGRectMake(11, 11, textView.FSW-22, textView.FSH - 22);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
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
        imageViewArrow.hidden = NO;
    }else{
            textView.hidden = YES;
        imageViewArrow.hidden = YES;
    }
    
}

- (void)closeTheTextViewWithToolTipView
{
    textView.hidden = YES;
    imageViewArrow.hidden = YES;
}

- (void)dealloc
{
    [self.ctv release];
    [textView release];
    [imageViewArrow release];
    [super dealloc];
}

@end
