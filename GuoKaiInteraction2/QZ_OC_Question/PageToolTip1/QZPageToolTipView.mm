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

@synthesize delegate;
@synthesize selfTag;

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
    [textView.layer setShadowOffset:CGSizeMake(5, 5)];
    [textView.layer setShadowRadius:10.0];
    [textView.layer setShadowColor:[UIColor blackColor].CGColor];
    [textView.layer setShadowOpacity:10.0];
    
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
        
        if (isW)
        {
            image  =[UIImage imageNamed:@"g_tip_up_w.png"];
        }else{
            image  =[UIImage imageNamed:@"g_tip_up_y.png"];
        }
        
        if ((SFSH + TIP_POP_HEIGHT_OF_TAP + pToolTip->rect.Y0 + pToolTip->nHeight) > DH-30)
        {
            tRect = CGRectMake(0,-TIP_POP_HEIGHT_OF_TAP-pToolTip->nHeight,pToolTip->nWidth,pToolTip->nHeight);
            qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, -TIP_POP_HEIGHT_OF_TAP-5, 30, 20);
            
            if (isW) {
                image  =[UIImage imageNamed:@"g_tip_down_w.png"];
            }else{
                image  =[UIImage imageNamed:@"g_tip_down_y.png"];
            }
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
        qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, -TIP_POP_HEIGHT_OF_TAP-5, 30, 20);
          
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
        
        if ((SFSH + TIP_POP_HEIGHT_OF_TAP + pToolTip->rect.Y0 + pToolTip->nHeight) > DH-40)
        {
            tRect = CGRectMake(SFSW - pToolTip->nWidth,-TIP_POP_HEIGHT_OF_TAP-pToolTip->nHeight,pToolTip->nWidth,pToolTip->nHeight);
            qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, -TIP_POP_HEIGHT_OF_TAP-5, 30, 20);
            
            if (isW)
            {
                image  =[UIImage imageNamed:@"g_tip_down_w.png"];
            }else{
                image  =[UIImage imageNamed:@"g_tip_down_y.png"];
            }
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
        
        qRect = CGRectMake(centreL - pToolTip->rect.X0 - 15, -TIP_POP_HEIGHT_OF_TAP-3, 30, 20);
        if (isW) {
            image  =[UIImage imageNamed:@"g_tip_down_w.png"];
        }else{
            image  =[UIImage imageNamed:@"g_tip_down_y.png"];
        }
     }
    
    
    NSLog(@"%@",NSStringFromCGRect(tRect));
    imageViewArrow = [[UIImageView alloc]initWithFrame:qRect];
    imageViewArrow.hidden = YES;
    [imageViewArrow setImage:image];
    textView.frame = tRect;
    [self addSubview:textView];
    [self addSubview:imageViewArrow];
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
    CGFloat  fristlineindent;
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
            case PAGE_RICH_TEXT_PIECE_DOT:
            {
                fristlineindent = 1;
                NSLog(@"前面有小圆点");
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
    AttributedTextView *attStringView = [[AttributedTextView alloc]initWithFrame:CGRectMake(0, 0, textView.FSW-22, textView.FSH - 22)];
    attStringView.backgroundColor = [UIColor clearColor];
    [attStringView setFontSize:18];
    [attStringView setLineSpacing:5];
    [attStringView setRedFColorValue: 52.0];
    [attStringView setGreenFColorValue:52.0];
    [attStringView setBlueFColorValue:52.0];
    [attStringView setFirstNum:0];
    [attStringView setPGFist:fristlineindent];
    [attStringView setGreenHColorValue:52.0];
    [attStringView setRedHColorValue:52.0];
    [attStringView setBlueHColorValue:52.0];
    [attStringView setText:string];
    UIFont *font = [UIFont fontWithName:strFont size:fontsize];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(textView.FSW-22, MAXFLOAT)];
    CGSize sizeO =[@"我" sizeWithFont:font constrainedToSize:(CGSizeMake(MAXFLOAT, MAXFLOAT))];
    NSInteger count = size.height/sizeO.height;
    UIScrollView *scText = [[UIScrollView alloc]initWithFrame:CGRectMake(11, 6, textView.FSW-22, textView.FSH - 22)];
    scText.contentSize = CGSizeMake(textView.FSW-22, size.height+count*10);
    [textView addSubview:scText];
    [scText addSubview:attStringView];
    [scText release];
    [attStringView release]; 
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
    NSString *path = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:[NSString stringWithUTF8String:pToolTip->strBtnImage.c_str()]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([fileManager fileExistsAtPath:path])
    {
        UIImage *imageP = [UIImage imageWithContentsOfFile:path];
        [button setBackgroundImage:imageP forState:UIControlStateNormal];
        [button setBackgroundImage:imageP forState:UIControlStateHighlighted];
        [button setBackgroundImage:imageP forState:UIControlStateSelected];
     
        [button setTitle:[NSString stringWithUTF8String:pToolTip->strBtnText.c_str()] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    button.frame = self.bounds;
    [button addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(pressOne:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(pressTwo:) forControlEvents:UIControlEventTouchCancel];
    [button addTarget:self action:@selector(pressThree:) forControlEvents:UIControlEventTouchDragOutside];
    button.selected = NO;
    [self addSubview:button];
    isApp = NO;
}

- (void)pressOne:(UIButton *)btn
{
    [UIView animateWithDuration:0.1 animations:^{
            btn.transform =  CGAffineTransformMakeScale(1.1,1.1);
    }];
    [self.delegate bringTheSupV:self.selfTag];
}

- (void)pressTwo:(UIButton *)btn
{
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform =  CGAffineTransformMakeScale(1.0,1.0);
    }];
}

- (void)pressThree:(UIButton *)btn
{
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform =  CGAffineTransformMakeScale(1.0,1.0);
    }];
}

- (void)handleSingleTap:(UIButton *)btn
{
//    if (!isApp)
//    {
//        [self createView];
//        [self text];
//    }
//    isApp = YES;
//    
    [self.delegate closeOtherToolTip];
    btn.selected = !btn.selected;
//    if (btn.selected)
//    {
//            textView.hidden = NO;
//        imageViewArrow.hidden = NO;
//    }else{
//            textView.hidden = YES;
//        imageViewArrow.hidden = YES;
//    }
[UIView animateWithDuration:0.1 animations:^{
    btn.transform =  CGAffineTransformMakeScale(1.0,1.0);
}];
    
    [self createTipViewOfContentWithText:pToolTip];
}

- (void)createTipViewOfContentWithText:(PageToolTip *)pageToolTip
{
    [self  createViewStar];
    [self.delegate createPageToolTipView:pageToolTip withFrame:tipFrame andWithAngleFrame:angleFrame withImageName:imageName];
    [self.delegate createTheTipViewOfText:pageToolTip];
}

- (void)closeTheTextViewWithToolTipView
{
    textView.hidden = YES;
    imageViewArrow.hidden = YES;
}

- (void)dealloc
{
    [textView release];
    [imageViewArrow release];
    [super dealloc];
}

- (void)createViewStar
{
    BOOL isW = YES;
    if (pToolTip->bgColor.rgbRed == pToolTip->bgColor.rgbGreen && pToolTip->bgColor.rgbGreen == pToolTip->bgColor.rgbBlue && pToolTip->bgColor.rgbBlue == 255)
    {
        isW = YES;
    }else{
        isW = NO;
    }
    
    CGFloat ToolX = pToolTip->rect.X0;
    CGFloat ToolY = pToolTip->rect.Y0;
    CGFloat ToolW = pToolTip->nWidth;
    CGFloat ToolH = pToolTip->nHeight;
    
#pragma mark - 各种尖角的位置
    CGRect qRect;
#pragma mark - 各种坐标计算
    CGRect tRect;
    //    中间点
    CGFloat centre = (ToolX + pToolTip->rect.X1)/2;
    if (ToolX <= DW/2.0 && ToolY <= DH/2.0)
    {
        if (centre - ToolW/2 >= 20)
        {
            tRect = CGRectMake(centre-ToolW/2,
                               pToolTip->rect.Y1 + TIP_POP_HEIGHT_OF_TAP,
                               ToolW,
                               ToolH);
        }else{
            tRect = CGRectMake(ToolX,pToolTip->rect.Y1 + TIP_POP_HEIGHT_OF_TAP,
                               ToolW ,ToolH);
        }
        
        qRect = CGRectMake(centre - 15,
                           pToolTip->rect.Y1  + TIP_POP_HEIGHT_OF_TAP/2, 30, 20);
        if (isW)
        {
            imageName = @"g_tip_up_w.png";
        }else{
            imageName = @"g_tip_up_y.png";
        }
        
        if ((SFSH + TIP_POP_HEIGHT_OF_TAP + ToolY + ToolH) > DH-30)
        {
            tRect = CGRectMake(ToolX,ToolY - TIP_POP_HEIGHT_OF_TAP - ToolH,ToolW,ToolH);
            qRect = CGRectMake(centre - 15,ToolY - TIP_POP_HEIGHT_OF_TAP-5, 30, 20);
            
            if (isW)
            {
                imageName = @"g_tip_down_w.png";
            }else{
                imageName = @"g_tip_down_y.png";
            }
        }
        
       }
    else if (ToolX <= DW/2.0 && ToolY > DH/2.0)
    {
        if (centre + ToolW/2 >= 20)
        {
            tRect = CGRectMake(centre - ToolW/2,
                               ToolY - TIP_POP_HEIGHT_OF_TAP-ToolH,
                               ToolW ,ToolH);
        }else{
            tRect = CGRectMake(ToolX,
                               ToolY-TIP_POP_HEIGHT_OF_TAP-ToolH,
                               ToolW,ToolH);
        }
        qRect = CGRectMake(centre - 15,
                           ToolY -TIP_POP_HEIGHT_OF_TAP-5, 30, 20);
        
        if (isW)
        {
            imageName = @"g_tip_down_w.png";
        }
        else
        {
            imageName = @"g_tip_down_y.png";
        }
        
        if ((ToolY - TIP_POP_HEIGHT_OF_TAP - ToolH) < 30)
        {
            tRect = CGRectMake(ToolX,pToolTip->rect.Y1 + TIP_POP_HEIGHT_OF_TAP,
                               ToolW ,ToolH);
            qRect = CGRectMake(centre  - 15,
                               pToolTip->rect.Y1  + TIP_POP_HEIGHT_OF_TAP/2, 30, 20);
            if (isW)
            {
                imageName = @"g_tip_up_w.png";
            }else{
                imageName = @"g_tip_up_y.png";
            }
        }
    }
    else if(ToolX > DW/2.0 && ToolY <= DH/2.0)
    {
        if (pToolTip->rect.X1 > DW)
        {
            tRect = CGRectMake(DW - (DW - pToolTip->rect.X1) - 30 - ToolW,
                               pToolTip->rect.Y1 +  TIP_POP_HEIGHT_OF_TAP,
                               ToolW,ToolH);
            qRect = CGRectMake(centre - 30, pToolTip->rect.Y1+TIP_POP_HEIGHT_OF_TAP/2, 30, 20);
            
        }else{
            if (centre + ToolW/2 <= DW-20)
            {
                tRect = CGRectMake(centre - ToolW/2,
                                   pToolTip->rect.Y1 +  TIP_POP_HEIGHT_OF_TAP,
                                   ToolW,ToolH);
            }else{
                tRect = CGRectMake(pToolTip->rect.X1 - ToolW,
                                   pToolTip->rect.Y1 + TIP_POP_HEIGHT_OF_TAP,
                                   ToolW,ToolH);
            }
            qRect = CGRectMake(centre - 15, pToolTip->rect.Y1+TIP_POP_HEIGHT_OF_TAP/2, 30, 20);
        }
        
        if (isW) {
            imageName = @"g_tip_up_w.png";
        }else{
            imageName = @"g_tip_up_y.png";
        }
        
        if ((SFSH + TIP_POP_HEIGHT_OF_TAP + ToolY + ToolH) > DH-40)
        {
            tRect = CGRectMake(pToolTip->rect.X1 - ToolW,
                               ToolY - TIP_POP_HEIGHT_OF_TAP - ToolH,
                               ToolW,ToolH);
            qRect = CGRectMake(centre - 15,
                               ToolY - TIP_POP_HEIGHT_OF_TAP - 5, 30, 20);
            
            if (isW)
            {
                imageName = @"g_tip_down_w.png";
            }else{
                imageName = @"g_tip_down_y.png";
            }
        }
    
    }
    else
    {
        if (centre + ToolW/2 <= DW-20)
        {
            tRect = CGRectMake(centre-ToolW/2,
                               ToolY - TIP_POP_HEIGHT_OF_TAP-ToolH,
                               ToolW,ToolH);
        }else{
            tRect = CGRectMake(pToolTip->rect.X1 - ToolW,
                               ToolY - TIP_POP_HEIGHT_OF_TAP-ToolH,
                               ToolW,ToolH);
        }
        
        qRect = CGRectMake(centre - 15,ToolY - TIP_POP_HEIGHT_OF_TAP-3, 30, 20);
        if (isW) {
            imageName = @"g_tip_down_w.png";
        }else{
            imageName = @"g_tip_down_y.png";
        }
     
        if ((ToolY - TIP_POP_HEIGHT_OF_TAP - ToolH) < 30)
        {
            tRect = CGRectMake(ToolX,
                               ToolY-TIP_POP_HEIGHT_OF_TAP-ToolH,
                               ToolW,ToolH);
            qRect = CGRectMake(centre - 15,
                               ToolY -TIP_POP_HEIGHT_OF_TAP-5, 30, 20);
            if (isW)
            {
                imageName = @"g_tip_down_w.png";
            }
            else
            {
                imageName = @"g_tip_down_y.png";
            }
         }
    }
    
    tipFrame = tRect;
    angleFrame = qRect;
 }

@end
