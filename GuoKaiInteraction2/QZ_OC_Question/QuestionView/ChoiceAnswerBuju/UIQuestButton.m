//
//  UIQuestButton.m
//  logo
//
//  Created by qanzone on 13-11-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "UIQuestButton.h"

@implementation UIQuestButton

@synthesize subImageV = _subImageV;
@synthesize subLabelA = _subLabelA;
@synthesize subLabelContent = _subLabelContent;

@synthesize subAName = _subAName;
@synthesize subImageName = _subImageName;
@synthesize subLContentName = _subLContentName;

@synthesize headLength;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
    [self.subImageV release];
    [self.subLabelA release];
    [self.subLabelContent release];
    [super dealloc];
}

- (void)buju
{
    UIFont *font = [UIFont fontWithName:@"Palatino" size:20];
    CGSize size = [self.subLContentName sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width - 71, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize sizeOne = [@"我" sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height > sizeOne.height)
    {
        [self buju1];
    }else{
        [self buju2];
    }
}



- (void)buju1
{
    [self setTheSubImage:self.subImageName];
    [self setTheSubLabelA:self.subAName];
    [self setTheSubLabelContent:self.subLContentName];
}

- (void)setTheSubImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.subImageV = [[UIImageView alloc]initWithImage:image];
    self.subLabelContent.backgroundColor = [UIColor whiteColor];
    self.subImageV.frame = CGRectMake(5, 5, 23, 23);
    [self addSubview:self.subImageV];
}

- (void)setTheSubLabelA:(NSString *)numberOfContent
{
    UIFont *font =[UIFont boldSystemFontOfSize:20];
    CGSize size = [numberOfContent sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    self.subLabelA = [[UILabel alloc]initWithFrame:CGRectMake(38, 5, size.width, size.height)];
    self.subLabelA.font = font;
    self.subLabelA.numberOfLines = 0;
   self.subLabelA.backgroundColor = [UIColor clearColor];
    self.subLabelA.text = numberOfContent;
    [self addSubview:self.subLabelA];
}

- (void)setTheSubLabelContent:(NSString *)contentOfString
{
    UIFont *font = [UIFont fontWithName:@"Palatino" size:20];
    CGSize size = [contentOfString sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width - 48-self.subLabelA.frame.size.width-5, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    self.subLabelContent = [[UILabel alloc]initWithFrame:CGRectMake(48 + self.subLabelA.frame.size.width, 5, size.width, size.height)];
    self.subLabelContent.numberOfLines = 0;
    self.subLabelContent.font = font;
    self.subLabelContent.backgroundColor = [UIColor clearColor];
   self.subLabelContent.text = contentOfString;
    [self addSubview:self.subLabelContent];
}



- (void)buju2
{
    
    UIFont *font = [UIFont fontWithName:@"Palatino" size:20];
    CGSize size = [self.subLContentName sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width - 71, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    UIImage *image = [UIImage imageNamed:self.subImageName];
    self.subImageV = [[UIImageView alloc]initWithImage:image];
    self.subLabelContent.backgroundColor = [UIColor whiteColor];
    self.subImageV.frame = CGRectMake(self.headLength, 5, 23, 23);
    [self addSubview:self.subImageV];
    
    UIFont *fontA =[UIFont boldSystemFontOfSize:20];
    CGSize sizeA = [self.subAName sizeWithFont:fontA constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    self.subLabelA = [[UILabel alloc]initWithFrame:CGRectMake(self.headLength +33, 5, sizeA.width, sizeA.height)];
    self.subLabelA.font = fontA;
    self.subLabelA.numberOfLines = 0;
    self.subLabelA.backgroundColor = [UIColor clearColor];
    self.subLabelA.text = self.subAName;
    [self addSubview:self.subLabelA];
    
    self.subLabelContent = [[UILabel alloc]initWithFrame:CGRectMake(self.headLength+33+5+23, 5, size.width, size.height)];
    self.subLabelContent.numberOfLines = 0;
    self.subLabelContent.font = font;
    self.subLabelContent.backgroundColor = [UIColor clearColor];
    self.subLabelContent.text = self.subLContentName;
    [self addSubview:self.subLabelContent];
}



- (void)setSubImageName:(NSString *)subImageName
{

    [self.subImageV setImage:[UIImage imageNamed:subImageName]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
