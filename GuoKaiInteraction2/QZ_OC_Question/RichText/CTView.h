//
//  CTView.h
//  CoreTextDemo
//
//  Created by qanzone on 13-9-22.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface CTView : UIView
{
    float frameXOffset;
    float frameYOffset;
    NSAttributedString *attString;
}
@property (nonatomic, retain) NSAttributedString *attString;
@end
