//
//  MovieV.h
//  MovieDemo
//
//  Created by qanzone on 13-9-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieView.h"
@interface MovieV : UIView
{
    MovieView *_movieView;
}
@property (nonatomic, retain)MovieView *movieView;

@end
