//
//  PageQuestionConnection.h
//  Question

//¡¨œﬂÃ‚connection question
//struct PageQuestionConnection:public PageQuestionBase
//{
//	std::string					strQuestion;
//	std::vector<std::string>    vLeftSide;
//	std::vector<std::string>    vRightSide;
//	std::vector<QZ_INT>         vAnswers;
//};

//  Created by qanzone on 13-10-12.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "PageQuestionBase1.h"

@interface PageQuestionConnection1 : PageQuestionBase1
{

    NSString *strQuestion;
	NSMutableArray *vLeftSide;
	NSMutableArray *vRightSide;
	NSMutableArray *vAnswers;
}

@property (nonatomic, copy)NSString *strQuestion;
@property (nonatomic, retain)NSMutableArray *vLeftSide;
@property (nonatomic, retain)NSMutableArray *vRightSide;
@property (nonatomic, retain)NSMutableArray *vAnswers;
@end
