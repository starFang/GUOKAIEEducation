//
//  MarkupP.h
//  MarkupParser
//
//  Created by qanzone on 13-9-22.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkupParser : NSObject
{
    
    NSString* font;
    CGFloat size;
    UIColor* color;
    UIColor* strokeColor;
    float strokeWidth;
    
    NSMutableArray* images;
}

@property (assign, nonatomic) CGFloat size;
@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (retain, nonatomic) NSMutableArray* images;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;
@end
