//
//  ImageGV.m
//  ImageGesture
//
//  Created by qanzone on 13-9-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "ImageGV1.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageGV1

@synthesize imageView = _imageView;
@synthesize backLayer = _backLayer;
@synthesize ctV =_ctV;

- (void)dealloc
{
    
    [self.imageView release];
    self.imageView = nil;
    [self.ctV  release];
    self.ctV = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (void)initIncomingData:(PageImage *)pageImage
{
    pImage = pageImage;
}
- (void)composition
{
    startRect = self.frame;
    isImageBig = NO;
    [self title];
    [self initImage];
    [self loadImage];
    [self initGesture];
    [self initIView];
}

- (void)title
{
    self.ctV = [[CTView alloc]init];
    if (pImage->stTitle.isRichText == YES)
    {
        [self isYesRichText:pImage];
    }else{
        [self isNoRichText:pImage];
    }
    [self addSubview:self.ctV];
    
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
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                if (![strBegin length]) {
                    
                }else{
                    [strBegin appendString:@"\n"];
                    [string appendString:@"\n"];
                }
                UIFont *font = [UIFont fontWithName:[NSString stringWithUTF8String:pageRichTextImage->stTitle.vTextItemList[i].fontFamily.c_str()] size:pageRichTextImage->stTitle.vTextItemList[i].fontSize];
                
                CGSize sizek = [@" " sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                NSInteger countK = (int)ceilf(pageRichTextImage->stTitle.vTextItemList[i].nLength/sizek.width);
                for (int j =0 ; j < countK; j++)
                {
                    [strBegin appendString:@" "];
                    [string appendString:@" "];
                }
            }
                break;
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pageRichTextImage->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbRed,pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbGreen,pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbBlue,pageRichTextImage->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pageRichTextImage->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pageRichTextImage->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pageRichTextImage->stTitle.vTextItemList[i].fontSize;
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_END:
            {
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_DOT:
            {
                
            }
                break;
            default:
                break;
        }
    }
    [p setFont:strFont];
    [p setSize:fontsize];
    CGSize size = [string sizeWithFont:[UIFont fontWithName:strFont size:fontsize] constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    self.ctV.frame  = CGRectMake(0, 0, SFSW , size.height);
    self.ctV.backgroundColor = [UIColor clearColor];
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

-(void)initIView
{
    iView = [[IViewGV1 alloc]init];
    iView.delegate = self;
    iView.hidden = YES;
    [iView titleAndClose:pImage];
    [self addSubview:iView];
}

- (void)initGesture
{
    _tapOneGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.imageView addGestureRecognizer:_tapOneGesture];
}

static int indexTap;
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self endTwoState:gestureRecognizer];
    if (isImageBig == YES)
    {
        if (indexTap%2 == 1)
        {
            iView.hidden = NO;
        }else{
            iView.hidden = YES;
        }
        indexTap++;
    }
}
-(void)closeTheImage
{
    self.ctV.hidden = NO;
    [self endOneState:nil];
}
-(void)initImage
{
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = CGRectMake(ZERO, self.ctV.FSH +10, SFSW, SFSH - (self.ctV.FSH+10));
    imageRect = self.imageView.frame;
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
}

- (void)loadImage
{
    NSString *imagepath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:[NSString stringWithUTF8String:pImage->strImgPath.c_str()]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagepath])
    {
    NSData * imageData = [NSData dataWithContentsOfFile:imagepath];
    UIImage * image = [UIImage imageWithData:imageData];
    [self.imageView setImage:image];
    }else{
        UIImage * image = [UIImage imageNamed:@"2.png"];
        [self.imageView setImage:image];
    }  
}

-(void)endOneState:(UIGestureRecognizer *)gestureRecoginzer
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    iView.hidden = YES;
    self.frame =startRect;
    self.imageView.frame = imageRect;
    isImageBig = NO;
    [UIView commitAnimations];
}

-(void)endTwoState:(UIGestureRecognizer *)gestureRecoginzer
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    self.frame = CGRectMake(ZERO, ZERO, DW, DH-20);
    self.imageView.frame = CGRectMake(ZERO, ZERO, DW, DH-20);
    self.imageView.center = self.center;
    self.ctV.hidden = YES;
    isImageBig = YES;
    [UIView commitAnimations];
}

@end
