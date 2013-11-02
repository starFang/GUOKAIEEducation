//
//  QZDirectDataModel.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-11-2.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZDirectDataModel : NSObject
{
    NSString *_dPageTitle;
    NSString *_dPageNumber;
}
@property (nonatomic, copy)NSString *dPageTitle;
@property (nonatomic, copy)NSString *dPageNumber;

@end
