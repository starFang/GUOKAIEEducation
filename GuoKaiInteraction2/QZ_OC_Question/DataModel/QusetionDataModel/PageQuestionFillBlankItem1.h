//
//  PageQuestionFillBlankItem.h
//  Question
//
//  Created by qanzone on 13-10-15.
//  Copyright (c) 2013年 star. All rights reserved.
//
//fill blank

//struct PageQuestionFillBlankItem
//{
//	QZ_BOOL isAnswer;
//	std::string strText;
//    
//	PageQuestionFillBlankItem():isAnswer(QZ_FALSE)
//	{}
//};

#import <Foundation/Foundation.h>

@interface PageQuestionFillBlankItem1 : NSObject
{
    BOOL isAnswer;
    NSString *strText;
}

@property (nonatomic, copy)NSString *strText;
@property (nonatomic, assign)BOOL isAnswer;

@end
