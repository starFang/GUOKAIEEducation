//
//  MovieView.m
//  MovieDemo
//
//  Created by qanzone on 13-9-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "MusicToolView.h"
#import <QuartzCore/QuartzCore.h>
#import "MarkupParser.h"

@implementation MusicToolView

@synthesize moviePlayer = _moviePlayer;

- (void)dealloc
{
    [self.moviePlayer release];
    self.moviePlayer = nil;
    [musicTitle release];
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

- (void)initIncomingData:(PageVoice *)pageVoice
{
    pVoice = pageVoice;
}
- (void)composition
{
    if (pVoice->stTitle.isRichText == YES)
    {
        [self isYesRichText];
    }else{
        [self initTitle:self.frame];
    }
    [self loadMovie:[NSString stringWithUTF8String:pVoice->strVoicePath.c_str()]];
    [self initPressPlay];
}
- (void)isYesRichText
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    for (int i = 0; i < pVoice->stTitle.vTextItemList.size(); i++)
    {
        switch (pVoice->stTitle.vTextItemList[i].pieceType)
        {
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                if (![strBegin length]) {
                    
                }else{
                    [strBegin appendString:@"\n"];
                    [string appendString:@"\n"];
                }
                UIFont *font = [UIFont fontWithName:[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].fontFamily.c_str()] size:pVoice->stTitle.vTextItemList[i].fontSize];
                CGSize sizek = [@" " sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                NSInteger countK = (int)ceilf(pVoice->stTitle.vTextItemList[i].nLength/sizek.width);
                for (int j =0 ; j < countK; j++)
                {
                    [strBegin appendString:@" "];
                    [string appendString:@" "];
                }
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pVoice->stTitle.vTextItemList[i].fontColor.rgbRed,pVoice->stTitle.vTextItemList[i].fontColor.rgbGreen,pVoice->stTitle.vTextItemList[i].fontColor.rgbBlue,pVoice->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pVoice->stTitle.vTextItemList[i].fontSize;
                
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
    CGSize size = [string sizeWithFont:[UIFont fontWithName:strFont size:fontsize] constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
    ctv = [[CTView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [ctv setAttString:attString];
    [self addSubview:ctv];
    titHeight = size.height;
}
- (void)initTitle:(CGRect)frame
{
    musicTitle = [[UILabel alloc]init];
    musicTitle.backgroundColor = [UIColor clearColor];
    musicTitle.tag = MUSICTOOLVIEW_TITLE_TAG;
    musicTitle.numberOfLines = 0;
    [musicTitle setText:[NSString stringWithUTF8String:pVoice->strVoicePath.c_str()]];
    musicTitle.textAlignment = NSTextAlignmentLeft;
    CGSize sizeTt = [musicTitle.text sizeWithFont:QUESTION_TITLE_FONT constrainedToSize:CGSizeMake(FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    musicTitle.frame = CGRectMake(0, 0, FSW, sizeTt.height+1);
    [self addSubview:musicTitle];
    titHeight = musicTitle.FSH;
}

- (void)initPressPlay
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag  = MUSICTOOL_START_BTN_TAG;
    button.frame = CGRectMake(0,titHeight + 25, SFSW, MUSICTOOLVIEW_SLIDER_HEIGHT);
    
    NSLog(@"%f %d",SFSW,MUSICTOOLVIEW_SLIDER_HEIGHT);
    [button setBackgroundImage:[UIImage imageNamed:@"g_music_selected.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)pressButton:(UIButton *)button
{
    button.hidden = YES;
    [self.moviePlayer play];
}

- (void)loadMovie:(NSString *)movieName
{
    NSString *path = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"medias"] stringByAppendingPathComponent:movieName];
    NSURL * url = [NSURL fileURLWithPath:path];
    self.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    [self playMovie:nil];
}

-(void)playMovie:(NSString *)movieName
{
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    self.moviePlayer.view.backgroundColor = [UIColor clearColor];
    self.moviePlayer.backgroundView.backgroundColor = [UIColor clearColor];
    [self.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    [self.moviePlayer.view setFrame:CGRectMake(0,titHeight + 25, SFSW, MUSICTOOLVIEW_SLIDER_HEIGHT)];
    self.moviePlayer.initialPlaybackTime = -1;
    [self addSubview:self.moviePlayer.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    [self.moviePlayer prepareToPlay];
//    [self.moviePlayer play];
//    [self.moviePlayer pause];
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
//    UIButton *button = (UIButton *)[self viewWithTag:MUSICTOOL_START_BTN_TAG];
//    button.hidden = NO;
    [self.moviePlayer pause];
    self.moviePlayer.currentPlaybackTime = 0;
}

- (void)stop
{
    [self.moviePlayer stop];
}

@end
