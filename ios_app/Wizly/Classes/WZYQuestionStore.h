//
//  WZYQuestionStore.h
//  Wizly
//
//  Created by Bezhou Feng on 2/7/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

@import Foundation;

#import "WZYQuestion.h"

typedef NS_ENUM(NSInteger, WZYTestType) {
  WZYTestSAT,
  WZYTestACT,
};

@interface WZYQuestionStore : NSObject

@property(nonatomic, readonly) NSDictionary *questionDict;

+ (WZYQuestionStore *)sharedStore;

- (void)loadQuestionsFromRemoteWithCompletion:
    (void (^)(NSArray *questions, NSError *error))completion;

- (NSInteger)numberOfQuestionsForTestType:(WZYTestType)type;

- (NSArray *)questionsForTest:(WZYTestType)testType
                 numQuestions:(NSUInteger)numQuestions
                     sections:(WZYQuestionType)sections;

@end
