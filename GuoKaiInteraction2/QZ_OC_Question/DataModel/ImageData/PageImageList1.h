//
//  PageImageList.h
//  ImageGesture
//
//  Created by qanzone on 13-9-30.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageBaseElements1.h"
@interface PageImageList1 : PageBaseElements1
{
    NSString *_stTitle;
    BOOL _isComment;
	BOOL _isSmallImage;
    NSMutableArray *_vImages;
}

@property (nonatomic, copy)NSString *stTitle;
@property (nonatomic)BOOL isComment;
@property (nonatomic)BOOL isSmallImage;
@property (nonatomic, retain)NSMutableArray *vImages;

@end
