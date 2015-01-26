//
//  WZYQuestionUtil.m
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYQuestionUtil.h"

@implementation WZYQuestionUtil

+ (NSArray *)questionSetForTopics:(WZYQuestionType)questionType
                   numQuestions:(NSUInteger)numQuestions {
  NSMutableArray *questionSet = [[NSMutableArray alloc] init];

  for (int i = 0; i < numQuestions; i++) {
    WZYQuestion *question = [[WZYQuestion alloc] init];
    question.questionNumber = i;
    question.questionType = WZYQuestionTypeReading;
    question.questionAnswer = (NSUInteger)(i % 4);
    question.questionText = [NSString stringWithFormat:@"Text for question %i", i];

    [questionSet addObject:question];
  }

  return questionSet;
}

@end
