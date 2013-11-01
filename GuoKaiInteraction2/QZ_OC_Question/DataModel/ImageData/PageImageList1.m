//
//  PageImageList.m
//  ImageGesture
//
//  Created by qanzone on 13-9-30.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageImageList1.h"

@implementation PageImageList1

@synthesize stTitle = _stTitle;
@synthesize isSmallImage = _isSmallImage;
@synthesize isComment = _isComment;
@synthesize vImages = _vImages;

- (id)init
{
    if (self = [super init])
    {
        self.vImages = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(NSString *)description
{
    return self.stTitle;
}


- (void)dealloc
{
    [self.stTitle release];
    [self.vImages release];
    [super dealloc];
}
@end
