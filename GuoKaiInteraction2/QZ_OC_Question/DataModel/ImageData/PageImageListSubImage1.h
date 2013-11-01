//
//  PageImageListSubImage.h
//  ImageGesture
//
//  Created by qanzone on 13-9-30.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageImageListSubImage1 : NSObject
{
//    图片说明
    NSString *_strImgPath;
//    图片内容
    NSString *_stImgComment;
}

@property (nonatomic, copy)NSString *strImgPath;
@property (nonatomic, copy)NSString *stImgComment;

@end
