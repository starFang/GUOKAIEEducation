//
//  AttributedTextView.m
//  CookBook
//
//  Created by 岳宗申 on 13-8-24.
//  Copyright (c) 2013年 xujiangtao. All rights reserved.
//

#import "AttributedTextView.h"
#import<CoreText/CoreText.h> 

@implementation AttributedTextView

@synthesize text = _text;
@synthesize lineSpacing = _lineSpacing;

@synthesize redFColorValue = _redFColorValue;
@synthesize greenFColorValue = _greenFColorValue;
@synthesize blueFColorValue = _blueFColorValue;

@synthesize redHColorValue = _redHColorValue;
@synthesize greenHColorValue = _greenHColorValue;
@synthesize blueHColorValue = _blueHColorValue;

@synthesize firstNum = _firstNum;
@synthesize fontSize = _fontSize;
@synthesize pGFist = _pGFist;

- (void)dealloc
{
    [self.text release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                // Initialization code
        self.pGFist = 1;
            }
    return self;
}

- (void)setText:(NSString *)text
{
    dBool = YES;
        if (_text != text) {
                [_text release];
                _text = [text retain];
            }
    attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    long number = 1.0;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedText addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0,[text length])];
    CFRelease(num);
    
//    设置段前缩进self.fontSize*2
    CGFloat fristlineindent;
    fristlineindent = self.fontSize*2*self.pGFist;
    CTParagraphStyleSetting fristline;
    fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristline.valueSize = sizeof(fristlineindent);
    fristline.value = &fristlineindent;
    CTParagraphStyleSetting settingsf[] ={fristline};
    CTParagraphStyleRef stylef = CTParagraphStyleCreate(settingsf , sizeof(settingsf));
    [attributedText addAttribute:(id)kCTParagraphStyleAttributeName value:(id)stylef range:NSMakeRange(0 , [text length])];
    
//    if (self.pGFist > 100)
//    {
//        UIGraphicsBeginImageContext(CGSizeMake(25, 25));
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        CGContextBeginPath(ctx);
//        CGContextAddArc(ctx, 3, 3, 3, 0,2 * M_PI, YES);
//        CGContextSetRGBFillColor(ctx, 52.0/255.0, 52.0/255.0, 52.0/255.0, 1);
//        CGContextFillPath(ctx);
//        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        UIImageView * imageView = [[UIImageView alloc]initWithImage:img];
//        imageView.frame = CGRectMake(8, 18, 25, 25);
//        [self addSubview:imageView];
//    }
    
//  设置文本行间距
    CGFloat lineSpace = self.lineSpacing;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    CTParagraphStyleSetting settings[ ] ={lineSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings , sizeof(settings));
    
//   给文本添加设置
    [attributedText addAttribute:(id)kCTParagraphStyleAttributeName value:(id)style range:NSMakeRange(0 , [text length])];
//    设置前面几个字符为红色 self.firstNum个
    [attributedText addAttribute:(NSString*)(kCTForegroundColorAttributeName) value:(id)[[UIColor colorWithRed:self.redFColorValue/255.0 green:self.greenFColorValue/255.0 blue:self.blueHColorValue/255.0 alpha:1.0]CGColor] range:NSMakeRange(0,self.firstNum)];
//    设置后面的颜色
        [attributedText addAttribute:(NSString*)(kCTForegroundColorAttributeName) value:(id)[[UIColor colorWithRed:self.redHColorValue/255.0 green:self.greenHColorValue/255.0 blue:self.blueHColorValue/255.0 alpha:1.0]CGColor] range:NSMakeRange(self.firstNum,text.length-self.firstNum)];
    
//    CTFontRef font_hello = CTFontCreateWithName(CFSTR("FZHuangCao-S09S"),self.fontSize, NULL);
//    设置字体和大小
        CTFontRef font_world = CTFontCreateWithName((CFStringRef)@"Palatino-Roman",self.fontSize,NULL);
//    设置前面的字体
//        [attributedText addAttribute: (NSString*)(kCTFontAttributeName) value:(id)font_hello range:NSMakeRange(0,10)];
//    设置某段的字体
        [attributedText addAttribute: (NSString*)(kCTFontAttributeName) value:(id)font_world range:NSMakeRange(0,text.length)];
//        CFRelease(font_hello);
        CFRelease(font_world);
        [self setNeedsDisplay];
    }
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
        // Drawing code
    if (attributedText && dBool)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context,CGAffineTransformIdentity);//重置
        CGContextTranslateCTM(context,0,self.bounds.size.height+10); //y轴高度
        CGContextScaleCTM(context,1.0,-1.0);//y轴翻转
        CTFramesetterRef framesetter=CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText);//**********
        CGMutablePathRef path = CGPathCreateMutable();//###########
        CGRect iRect= self.bounds;
        CGPathAddRect(path, NULL, iRect);
        CTFrameRef workFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);//###########*********
        CTFrameDraw(workFrame, context);
        CFRelease(workFrame);//###########*********
        CFRelease(path);//###########
        UIGraphicsPushContext(context);
        CFRelease(framesetter);//**********
        [attributedText release];
        dBool = NO;
        
        
    }
}
- (void)fitToSuggestedHeight
{
    CGSize suggestedSize = [self.text sizeWithFont:[UIFont fontWithName:@"GillSans" size:26.0] constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
    CGRect viewFrame = self.frame;
    NSLog(@"height = %f",suggestedSize.height);
    if (suggestedSize.height >445) {
        viewFrame.size.height = suggestedSize.height+10;
      }
      else if (suggestedSize.height < 30.0)
      {
        viewFrame.origin.y = 50.0;
        viewFrame.size.height = 55;
      }
      else
      {
         viewFrame.origin.y = 20.0;
//         viewFrame.size.height = 498;
          viewFrame.size.height = suggestedSize.height+10;
      }
      self.frame = viewFrame;
}


- (CGSize)creatMeasureFrame:(CTFrameRef)frame forContext:(CGContextRef *)cgContext
{
    //frame为排版后的文本
    CGPathRef framePath =CTFrameGetPath(frame);
    CGRect frameRect =CGPathGetBoundingBox(framePath);
    
    CFArrayRef lines =CTFrameGetLines(frame);
    CFIndex numLines =CFArrayGetCount(lines);
    
    CGFloat maxWidth =0;
    CGFloat textHeight =0;
    
    CFIndex lastLineIndex = numLines -1;
    for(CFIndex index =0; index < numLines; index++)
    {
        CGFloat ascent, descent, leading, width;
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, index);
        width =CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
        
        if(width > maxWidth)
        {
            maxWidth = width;
        }
        
        if(index == lastLineIndex)
        {
 
            CGPoint lastLineOrigin;
            CTFrameGetLineOrigins(frame,CFRangeMake(lastLineIndex,1), &lastLineOrigin);
            textHeight = CGRectGetMaxY(frameRect) - lastLineOrigin.y+ descent;
        }
    }
    
    return CGSizeMake(ceil(maxWidth),ceil(textHeight));
}

@end
