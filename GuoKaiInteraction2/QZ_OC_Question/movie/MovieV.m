//
//  MovieV.m
//  MovieDemo
//
//  Created by qanzone on 13-9-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "MovieV.h"

@implementation MovieV

@synthesize movieView = _movieView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.movieView = [[MovieView alloc]initWithFrame:frame];
    }
    return self;
}
- (void)dealloc
{
    [self.movieView release];
    self.movieView = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
