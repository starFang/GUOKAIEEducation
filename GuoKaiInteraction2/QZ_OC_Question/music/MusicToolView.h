//
//  MusicToolView.h
//  ImageGesture
//
//  Created by qanzone on 13-10-5.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "QZEpubPageObjs.h"
#import "CTView.h"

@interface MusicToolView : UIView
{
    PageVoice *pVoice;
    AVAudioPlayer * mp3Player;
    CTView *ctv;
    CGFloat titHeight;
}
@property (nonatomic, retain)UILabel *musicTitle;
- (void)mp3Player:(NSString *)musicName;

- (void)initIncomingData:(PageVoice *)pageVoice;
- (void)composition;
- (void)stop;
@end
