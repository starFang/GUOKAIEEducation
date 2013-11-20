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
}

- (void)pressOne:(UIButton *)btn
{
    [UIView animateWithDuration:0.1 animations:^{
            btn.transform =  CGAffineTransformMakeScale(1.1,1.1);
    }];
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
    [self.delegate closeOtherToolTip];
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        NSLog(@"YES");
        [self createTipViewOfContentWithText:pToolTip];
    }else{
        NSLog(@"NO");
        [self.delegate closeOtherToolTip];
    }
[UIView animateWithDuration:0.1 animations:^{
    btn.transform =  CGAffineTransformMakeScale(1.0,1.0);
}];

}

- (void)TheBtnSelected
{
    button.selected = NO;
}

- (void)createTipViewOfContentWithText:(PageToolTip *)pageToolTip
{
    [self createViewStar];
    [self.delegate createPageToolTipView:pageToolTip withFrame:tipFrame andWithAngleFrame:angleFrame withImageName:imageName];
    [self.delegate createTheTipViewOfText:pageToolTip];
}

- (void)dealloc
{
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
