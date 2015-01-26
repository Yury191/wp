//
//  WZYPracticeController.h
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

@import Foundation;

#import "WZYQuestion.h"

@class WZYUser;

@protocol WZYPracticeDelegate <NSObject>

- (void)timerDidFire:(NSTimeInterval)currentTime;

@end

@interface WZYPracticeController : NSObject

@property(nonatomic, weak) id<WZYPracticeDelegate> delegate;

@property(nonatomic, assign, readonly) BOOL isTestMode;
@property(nonatomic, readonly) NSArray *questionArray;

- (id)initWithNumQuestions:(NSUInteger)numQuestions
              questionType:(WZYQuestionType)questionType
                      user:(WZYUser *)user
                  testMode:(BOOL)testMode;

@end
