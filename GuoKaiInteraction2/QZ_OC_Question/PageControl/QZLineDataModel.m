//
//  QZLineDataModel.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-26.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZLineDataModel.h"

@implementation QZLineDataModel

@synthesize lineID = _lineID;
@synthesize lineCritique = _lineCritique;
@synthesize lineDate = _lineDate;
@synthesize linePageNumber = _linePageNumber;
@synthesize lineWords = _lineWords;
@synthesize lineStartIndex = _lineStartIndex;
@synthesize lineEndIndex = _lineEndIndex;
@synthesize lineColor = _lineColor;

- (NSString *)description
{

    return [NSString stringWithFormat:@"%@-%@-%@-%@- pageNumber ：%d-%@-%@-%@",self.lineID,self.lineWords,self.lineCritique,self.lineDate,[self.linePageNumber integerValue],self.lineStartIndex,self.lineEndIndex,self.lineColor];
}

@end
