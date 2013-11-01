//
//  QZLineDataModel.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-26.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZLineDataModel : NSObject
{
    NSString *_lineID;
    NSString *_linePageNumber;
    NSString *_lineStartIndex;
    NSString *_lineEndIndex;
    NSString *_lineWords;
    NSString *_lineDate;
    NSString *_lineCritique;
    NSString *_lineColor;
    
}
@property (nonatomic, copy) NSString *lineID;
@property (nonatomic, copy) NSString *lineWords;
@property (nonatomic, copy) NSString *lineDate;
@property (nonatomic, copy) NSString *lineCritique;
@property (nonatomic, copy) NSString *linePageNumber;
@property (nonatomic, copy) NSString *lineStartIndex;
@property (nonatomic, copy) NSString *lineEndIndex;
@property (nonatomic, copy) NSString *lineColor;

@end
