//
//  PageQuestionDragPoint.h
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QZ_BOX1.h"

@interface PageQuestionDragPoint1 : NSObject
{
    QZ_BOX1 * rect;
    NSInteger nAnswer;
}
@property (nonatomic, retain) QZ_BOX1 * rect;
@property (nonatomic, assign) NSInteger nAnswer;
@end
