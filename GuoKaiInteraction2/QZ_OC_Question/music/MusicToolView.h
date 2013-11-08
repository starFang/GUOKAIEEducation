//
//  MovieView.h
//  MovieDemo
//
//  Created by qanzone on 13-9-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "QZEpubPageObjs.h"
#import "CTView.h"

@interface MusicToolView : UIView
{
    PageVoice *pVoice;
    CTView *ctv;
    CGFloat titHeight;
    UILabel * musicTitle;
}
@property (nonatomic, retain)UILabel *musicTitle;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
- (void)initIncomingData:(PageVoice *)pageVoice;
- (void)composition;
- (void)stop;

@end
