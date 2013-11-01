//
//  PageQuestionSort.h
//  Question
//
//  Created by qanzone on 13-10-13.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionBase1.h"

@interface PageQuestionSort1 : PageQuestionBase1
{
    NSString *strQuestion;
    NSMutableArray *vStrTexts;
    NSMutableArray *vSortedList;
}

@property (nonatomic, copy) NSString *strQuestion;
@property (nonatomic, retain) NSMutableArray *vStrTexts;
@property (nonatomic, retain) NSMutableArray *vSortedList;
@end
