//
//  MarkupP.m
//  MarkupParser
//
//  Created by qanzone on 13-9-22.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "MarkupParser.h"
#import <CoreText/CoreText.h>


@implementation MarkupParser
@synthesize font, color, strokeColor, strokeWidth,size;
@synthesize images;

-(id)init
{
    self = [super init];
    if (self) {
        
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.size = 25;
        self.images = [NSMutableArray array];
        
    }
    return self;
}

-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    NSMutableAttributedString* aString =
    [[NSMutableAttributedString alloc] initWithString:@""]; //1
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
        initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
        options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
            error:nil]; //2
    NSArray* chunks = [regex matchesInString:markup
                            options:0
                        range:NSMakeRange(0, [markup length])];
    [regex release];
    

    for (NSTextCheckingResult* b in chunks)
    {
        NSArray* parts = [[markup substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1
        CTFontRef fontRef = CTFontCreateWithName
        ((CFStringRef)self.font, self.size, NULL);//设置字体大小
        //apply the current text style //2
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
        (id)self.color.CGColor, kCTForegroundColorAttributeName,
        (id)fontRef, kCTFontAttributeName,
        (id)self.strokeColor.CGColor,
        (NSString *) kCTStrokeColorAttributeName,
        (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                               nil];
        
        [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs] autorelease]];
        
        CFRelease(fontRef);
        
        //handle new formatting tag //3
        if ([parts count]>1)
        {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            if ([tag hasPrefix:@"font"])
            {
                //stroke color
                NSRegularExpression* scolorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL] autorelease];

                [scolorRegex enumerateMatchesInString:tag
                 options:0
                range:NSMakeRange(0, [tag length])
                usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    
                    if ([[tag substringWithRange:match.range] isEqualToString:@"none"])
                    {
                        self.strokeWidth = 0.0;
                     } else {
                        self.strokeWidth = -3.0;
                         
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                 }];
                
                //color
                NSRegularExpression* colorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL] autorelease];
                
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
                {
                    
                    NSArray* part = [tag componentsSeparatedByString:@"\""];
            
                    CGFloat red = [[[[part objectAtIndex:1]componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
                    CGFloat green = [[[[part objectAtIndex:1]componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
                    CGFloat blue = [[[[part objectAtIndex:1]componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
                    CGFloat alpha = [[[[part objectAtIndex:1]componentsSeparatedByString:@","] objectAtIndex:3] floatValue];
    
                    self.color = [UIColor colorWithRed:red/255.0
                        green:green/255.0
                        blue:blue/255.0
                        alpha:alpha/255.0];
                    
                }];
                //face
                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL] autorelease];
                
                [faceRegex enumerateMatchesInString:tag
                           options:0
                           range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.font = [tag substringWithRange:match.range];
                 }];
              } //end of font parsing
        }
     }
    return (NSAttributedString*)aString;
}

-(void)dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.images = nil;
    [super dealloc];
}
@end
