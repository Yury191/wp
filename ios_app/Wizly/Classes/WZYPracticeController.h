//
//  WZYPracticeController.h
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

@import Foundation;

#import "WZYQuestion.h"

@class PFObject;
@class WZYUser;

@protocol WZYPracticeDelegate <NSObject>

- (void)timerDidFire:(NSTimeInterval)currentTime;

@end

@interface WZYPracticeController : NSObject

@property(nonatomic, weak) id<WZYPracticeDelegate> delegate;

@property(nonatomic, assign, readonly) BOOL isTestMode;
@property(nonatomic, readonly) NSArray *questionArray;
@property(nonatomic, readonly) NSMutableArray *questionTimeArray;
@property(nonatomic, assign) NSUInteger currentIndex;
@property(nonatomic, readonly) WZYQuestion *currentQuestion;
@property(nonatomic, readonly) NSTimeInterval timeElapsed;
@property(nonatomic, readonly) BOOL testStarted;
@property(nonatomic, readonly) BOOL testFinished;

// Note: These responses are all zero-indexed, as opposed to the WZYQuestion format, which is
// 1-indexed.
// TODO: refactor WZYQuestion answer format so that it is also zero-indexed and we avoid a bunch
// of off by one errors. Yes, I'm dumb; I should have done this initially.
@property(nonatomic, readonly) NSArray *responses;

- (id)initWithNumQuestions:(NSUInteger)numQuestions
              questionType:(WZYQuestionType)questionType
                      user:(WZYUser *)user
                  testMode:(BOOL)testMode;

// Initializes the practice controller with a previous session so the student can review.
- (id)initWithSession:(PFObject *)session;

/** Sets the response for the current question **/
- (void)selectResponse:(NSNumber *)response;

/** Call to start the timer **/
- (void)start;
- (void)stop;
- (void)finishTest;

/** Call to move to next question **/
- (WZYQuestion *)next;

/** Call to go to previous question **/
- (WZYQuestion *)prev;

- (WZYQuestion *)skipToIndex:(NSUInteger)index;

/** Checks if all questions in this session have a response **/
- (BOOL)hasAnsweredAllQuestions;

/** Returns an array of the questions currently answered correctly **/
- (NSArray *)questionsAnsweredCorrectly;

- (int)averageTimePerQuestion;

@end
