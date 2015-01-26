//
//  WZYPracticeController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYPracticeController.h"

#import "WZYQuestionUtil.h"
#import "WZYUser.h"

@interface WZYPracticeController ()
@end

@implementation WZYPracticeController

- (id)initWithNumQuestions:(NSUInteger)numQuestions
              questionType:(WZYQuestionType)questionType
                      user:(WZYUser *)user
                  testMode:(BOOL)testMode {
  self = [super init];
  if (self) {
    _questionArray = [WZYQuestionUtil questionSetForTopics:WZYQuestionTypeReading
                                              numQuestions:20];
  }
  return self;
}

@end
