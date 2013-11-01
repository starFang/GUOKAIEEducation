//
//  PageImageListSubImage.m
//  ImageGesture
//
//  Created by qanzone on 13-9-30.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageImageListSubImage1.h"

@implementation PageImageListSubImage1

@synthesize stImgComment = _stImgComment;
@synthesize strImgPath = _strImgPath;

- (void)dealloc
{
    [self.strImgPath release];
    [self.stImgComment release];
 
    [super dealloc];
}
@end
