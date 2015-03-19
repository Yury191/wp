//
//  WZYQuestionUtil.m
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYQuestionUtil.h"

NSString *string = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer in neque ac ligula varius tempor. Etiam non risus nec lacus ullamcorper viverra. Ut diam ipsum, varius non bibendum quis, accumsan non eros. Phasellus et lobortis sapien. Aliquam vehicula sem a pretium tristique. Nam id sollicitudin nulla, id congue lectus. Vestibulum molestie urna vitae erat rutrum pretium. Vestibulum rutrum eu ex et ornare. Aenean tincidunt risus orci. Nam sit amet augue vitae nisi luctus tempor nec id arcu. Nam in tincidunt lorem, ac ultrices turpis. Suspendisse consequat mi id enim lobortis, et sodales est malesuada.";

@implementation WZYQuestionUtil

+ (NSArray *)questionSetForTopics:(WZYQuestionType)questionType
                   numQuestions:(NSUInteger)numQuestions {
  NSMutableArray *questionSet = [[NSMutableArray alloc] init];

  for (int i = 0; i < numQuestions; i++) {
    WZYQuestion *question = [[WZYQuestion alloc] init];
    question.questionId = [NSString stringWithFormat:@"%i", i];
    question.questionType = WZYQuestionTypeReading;
    question.questionAnswer = (NSUInteger)(i % 4);
    question.questionText = string;

    NSMutableArray *questionChoices = [NSMutableArray array];
    char c = 'A';
    for (int j = 0; j < 5; j++) {
      [questionChoices addObject:[NSString stringWithFormat:@"This is the right answer (%c)", c]];
      c++;
    }
    question.questionChoices = questionChoices;

    [questionSet addObject:question];
  }

  return questionSet;
}

@end
