//
//  PageQuestionDrag.h
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionBase1.h"

@interface PageQuestionDrag1 : PageQuestionBase1
{
    NSString *_strBackGroundImage;
	NSString *_strQuestion;
	NSMutableArray *_vImageSide;
	NSMutableArray *_vStringSide;
}
@property (nonatomic, copy) NSString *strBackGroundImage;
@property (nonatomic, copy) NSString *strQuestion;
@property (nonatomic, retain) NSMutableArray *vImageSide;
@property (nonatomic, retain) NSMutableArray *vStringSide;

@end
