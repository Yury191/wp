//
//  WZYPracticeController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYPracticeController.h"

#import <Parse/Parse.h>

#import "WZYQuestionStore.h"
#import "WZYQuestionUtil.h"
#import "WZYTestSession.h"
#import "WZYUser.h"

@interface WZYPracticeController ()
@property(nonatomic, assign) float score;
@property(nonatomic, readwrite) NSMutableArray *questionResponses;
@property(nonatomic) NSMutableArray *questionTimeArray;
@property(nonatomic) NSTimer *timer;
@property(nonatomic, assign, readwrite) NSTimeInterval timeElapsed;
@property(nonatomic, assign) BOOL testFinished;
@end

@implementation WZYPracticeController

- (id)initWithNumQuestions:(NSUInteger)numQuestions
              questionType:(WZYQuestionType)questionType
                      user:(WZYUser *)user
                  testMode:(BOOL)testMode {
  self = [super init];
  if (self) {
    WZYQuestionStore *store = [WZYQuestionStore sharedStore];
    _questionArray = [store questionsForTest:WZYTestSAT
                                numQuestions:numQuestions
                                    sections:questionType];
    _questionResponses = [NSMutableArray array];
    _questionTimeArray = [NSMutableArray array];
    for (int i = 0; i < _questionArray.count; i++) {
      [_questionResponses addObject:@-1];
      [_questionTimeArray addObject:@0];
    }

    self.score = -1;
  }
  return self;
}

- (id)initWithSession:(PFObject *)session {
  self = [super init];
  if (self) {
    self.testFinished = YES;

    WZYQuestionStore *store = [WZYQuestionStore sharedStore];
    NSDictionary *questionDict = session[kSessionAskedKey];
    NSArray *orderedQuestionArray = session[kSessionOrderedKey];

    _questionResponses = [NSMutableArray array];

    // Pull all asked question IDs from the store and add them to this session
    NSMutableArray *questionArray = [NSMutableArray array];
    for (NSString *questionId in orderedQuestionArray) {
      [questionArray addObject:store.questionDict[questionId]];
      [_questionResponses addObject:questionDict[questionId]];
    }
    _questionArray = questionArray;

    _questionTimeArray = session[kSessionQuestionTimeKey];
    _timeElapsed = [session[kSessionTimeElapsedKey] intValue];
    _score = [session[kSessionScoreKey] floatValue];
  }
  return self;
}

#pragma mark - Getters

- (WZYQuestion *)currentQuestion {
  return self.questionArray[self.currentIndex];
}

- (NSArray *)responses {
  return _questionResponses;
}

#pragma mark - Actions

- (void)start {
  if (self.timer) {
    NSLog(@"WARNING: Trying to start practice controller with an active timer. Returning.");
    return;
  }
  
  if (self.testFinished) {
    NSLog(@"WARNING: Cannot start a finished test. Instantiate a new controller object.");
    return;
  }

  _testStarted = YES;

  self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                target:self
                                              selector:@selector(timerFired)
                                              userInfo:nil
                                               repeats:YES];
  self.timeElapsed = 0;
}

- (void)stop {
  _testStarted = NO;
  [self.timer invalidate];
  self.timer = nil;
}

- (void)finishTest {
  [self stop];
  self.testFinished = YES;

  // Save a log of this test to the local datastore and eventually mirror to backend.
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    PFObject *testSession = [PFObject objectWithClassName:kSessionClassName];

    testSession[kSessionUserKey] = [PFUser currentUser];

    NSMutableDictionary *questionsAsked = [NSMutableDictionary dictionary];
    int index = 0;
    for (WZYQuestion *q in self.questionArray) {
      questionsAsked[q.questionId] = self.questionResponses[index];
      index++;
    }
    testSession[kSessionAskedKey] = questionsAsked;

    NSMutableArray *orderedQuestionArray = [NSMutableArray array];
    for (WZYQuestion *q in self.questionArray) {
      [orderedQuestionArray addObject:q.questionId];
    }
    testSession[kSessionOrderedKey] = orderedQuestionArray;

    testSession[kSessionTimeElapsedKey] = [NSString stringWithFormat:@"%.0f", self.timeElapsed];

    testSession[kSessionQuestionTimeKey] = self.questionTimeArray;

    // TODO: this is dumb, refactor so we don't need to call this method to calculate the score
    [self questionsAnsweredCorrectly];
    testSession[kSessionScoreKey] = [NSNumber numberWithFloat:self.score];

    testSession[kSessionDateKey] = [NSDate date];

    [testSession pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (succeeded) {
        NSLog(@"pinned session, marking for save");
        [testSession saveEventually];
      } else {
        NSLog(@"error pinning session: %@", error);
      }
    }];
  });
}

- (void)selectResponse:(NSNumber *)response {
  if (self.testFinished) return;
  self.questionResponses[self.currentIndex] = response;
}

- (WZYQuestion *)next {
  if (self.currentIndex + 1 < _questionArray.count) {
    self.currentIndex++;
    return self.questionArray[self.currentIndex];
  }
  return nil;
}

- (WZYQuestion *)prev {
  if (self.currentIndex != 0) {
    self.currentIndex--;
    return self.questionArray[self.currentIndex];
  }
  return nil;
}

- (WZYQuestion *)skipToIndex:(NSUInteger)index {
  if (index < _questionArray.count) {
    self.currentIndex = index;
    return _questionArray[self.currentIndex];
  }
  return nil;
}

- (BOOL)hasAnsweredAllQuestions {
  for (NSNumber *n in self.questionResponses) {
    if ([n intValue] == -1) {
      return NO;
    }
  }
  return YES;
}

- (NSArray *)questionsAnsweredCorrectly {
  NSMutableArray *questionsCorrect = [NSMutableArray array];
  int index = 0;
  for (NSNumber *n in self.questionResponses) {
    int answer = [n intValue] + 1;
    WZYQuestion *question = self.questionArray[index];
    if (question.questionAnswer == answer) {
      [questionsCorrect addObject:question];
    }
    index++;
  }

  if (self.testFinished && self.score < 0) {
    self.score = (float)questionsCorrect.count / (float)self.questionArray.count;
  }

  return questionsCorrect;
}

- (int)averageTimePerQuestion {
  int totalTime = 0;
  for (NSNumber *n in self.questionTimeArray) {
    totalTime += [n intValue];
  }
  if (self.questionTimeArray.count) {
    return totalTime / self.questionTimeArray.count;
  } else {
    return 0;
  }
}

#pragma mark - Timer

- (void)timerFired {
  self.timeElapsed += 1;
  [self.delegate timerDidFire:self.timeElapsed];

  // Increment time spent for current question
  NSNumber *time = self.questionTimeArray[self.currentIndex];
  self.questionTimeArray[self.currentIndex] = [NSNumber numberWithInt:[time intValue] + 1];
}

@end
