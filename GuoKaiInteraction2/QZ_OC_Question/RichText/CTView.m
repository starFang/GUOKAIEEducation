//
//  CTView.m
//  CoreTextDemo
//
//  Created by qanzone on 13-9-22.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "CTView.h"
#import "MarkupParser.h"

@implementation CTView

@synthesize attString;

- (void)dealloc
{
    [self.attString release];
    self.attString = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    CTFrameDraw(frame, context); //4
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
}

@end
