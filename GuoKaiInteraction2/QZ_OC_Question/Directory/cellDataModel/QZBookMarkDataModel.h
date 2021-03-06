//
//  QZBookMarkDataModel.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-11-2.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZBookMarkDataModel : NSObject
{
    NSString *_bmPageTitle;
    NSInteger _bmPageNumber;
    NSString *_bmDate;
}

@property (nonatomic, retain)NSString *bmDate;
@property (nonatomic, copy)NSString *bmPageTitle;
@property (nonatomic, assign)NSInteger bmPageNumber;

@end
