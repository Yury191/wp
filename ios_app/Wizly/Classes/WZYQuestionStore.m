//
//  WZYQuestionStore.m
//  Wizly
//
//  Created by Bezhou Feng on 2/7/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYQuestionStore.h"

#import <Parse/Parse.h>

#import "WZYQuestion.h"

static NSString *kParseQuestionIdKey = @"questionId";
static NSString *kParseQuestionTextKey = @"questiontext";
static NSString *kParseQuestionImageKey = @"questionimage";
static NSString *kParseChoice1Key = @"Choice1";
static NSString *kParseChoice2Key = @"Choice2";
static NSString *kParseChoice3Key = @"Choice3";
static NSString *kParseChoice4Key = @"Choice4";
static NSString *kParseChoice5Key = @"Choice5";
static NSString *kParseAnswerKey = @"answer";
static NSString *kParsePassageKey = @"passage";
static NSString *kParseDifficultyKey = @"difficulty";
static NSString *kParsePercentCorrectKey = @"percentanswercorrect";
static NSString *kParseQuestionTakenKey = @"usersthatdidquestion";
static NSString *kParseAverageAnswerTimeKey = @"avgusertimetoanswer";
static NSString *kParseIsDiagnosticKey = @"isdiagnotic";
static NSString *kParseIsSATorACTKey = @"SATorACT";
static NSString *kParseTypeKey = @"typeMewr";
static NSString *kParseImageChoiceKey = @"choicesAreImages";

// This category enhances NSMutableArray by providing methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end

@implementation NSMutableArray (Shuffling)

- (void)shuffle {
  NSUInteger count = [self count];
  for (NSUInteger i = 0; i < count; ++i) {
    NSInteger remainingCount = count - i;
    NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
    [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
  }
}

@end

@interface WZYQuestionStore ()
@property(nonatomic) NSMutableDictionary *internalDict;
@end

@implementation WZYQuestionStore

+ (WZYQuestionStore *)sharedStore {
  static WZYQuestionStore *store = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    store = [[WZYQuestionStore alloc] init];
  });
  return store;
}

- (id)init {
  self = [super init];
  if (self) {
    _internalDict = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Public

- (NSDictionary *)questionDict {
  return _internalDict;
}

- (void)loadQuestionsFromRemoteWithCompletion:(void (^)(NSArray *, NSError *))completion {
  [self loadQuestionsFromRemoteWithCompletion:completion fromLocalStore:NO];
}

- (void)loadQuestionsFromRemoteWithCompletion:(void (^)(NSArray *, NSError *))completion
                               fromLocalStore:(BOOL)fromLocalStore {
  NSDate *downloadStart = [NSDate date];

  PFQuery *query = [PFQuery queryWithClassName:@"QuestionsList"];
  if (fromLocalStore) {
    [query fromLocalDatastore];
  }
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    NSTimeInterval dlInterval = [[NSDate date] timeIntervalSinceDate:downloadStart];
    NSLog(@"download complete in %f", dlInterval);
    if (!error) {
      NSDate *start = [NSDate date];
      [self parseQuestionsFromArray:objects];
      NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:start];
      NSLog(@"parse complete in %f", interval);
      if (completion) {
        completion(_internalDict.allValues, nil);
      }
      // Always try to do a server retrieve after a local retrieve to update. Pin the new results.
      if (fromLocalStore) {
        [self loadQuestionsFromRemoteWithCompletion:completion fromLocalStore:NO];
      } else {
        // Flush cache and then repin new objects
        [PFObject unpinAllObjectsInBackgroundWithName:@"CachedQuestions"
                                                block:^(BOOL succeeded, NSError *error) {
          [PFObject pinAllInBackground:objects withName:@"CachedQuestions"];
        }];
      }
    } else {
      // TODO: how do we handle retrieval failures?
      NSLog(@"Question list error: %@", error);
      if (completion) {
        completion(nil, error);
      }
    }
  }];
}

- (NSArray *)questionsForTest:(WZYTestType)testType
                 numQuestions:(NSUInteger)numQuestions
                     sections:(WZYQuestionType)sections {
  NSMutableArray *questionArray = [NSMutableArray array];
  BOOL wantSAT = (testType == WZYTestSAT);

  // First, find all questions belonging to the right test
  for (WZYQuestion *q in self.internalDict.allValues) {
    if (q.isSAT == wantSAT) {
      [questionArray addObject:q];
    }
  }

  // Second, split the questions into the appropriate sections
  NSMutableArray *math = [NSMutableArray array];
  NSMutableArray *reading = [NSMutableArray array];
  NSMutableArray *writing = [NSMutableArray array];
  for (WZYQuestion *q in questionArray) {
    switch (q.questionType) {
      case WZYQuestionTypeMath:
        [math addObject:q];
        break;
      case WZYQuestionTypeWriting:
        [writing addObject:q];
        break;
      case WZYQuestionTypeReading:
        [reading addObject:q];
        break;
      default:
        break;
    }
  }

  // Third, figure out how many questions we want per section. Prefer uniform distribution and
  // prefer adding bonus questions to the math section.
  int numSections = 0;
  WZYQuestionType tempSection = sections;
  while (tempSection > 0) {
    if ((tempSection & 1) == 1) {
      numSections++;
    }
    tempSection >>= 1;
  }

  int questionsPerSection = 0;
  int extraQuestionsCount = 0;
  if (numSections > 0) {
     questionsPerSection = (int)numQuestions / numSections;
     extraQuestionsCount = numQuestions % numSections;
  }

  // Fourth, select randomly from each array until we've filled our question list.
  NSMutableArray *finalQuestionList = [NSMutableArray array];
  if (sections & WZYQuestionTypeMath) {
    [self randomlyPopulateArray:finalQuestionList
                      fromArray:math
                    numElements:questionsPerSection + extraQuestionsCount];
  }
  if (sections & WZYQuestionTypeReading) {
    [self randomlyPopulateArray:finalQuestionList
                      fromArray:reading
                    numElements:questionsPerSection];
  }
  if (sections & WZYQuestionTypeWriting) {
    [self randomlyPopulateArray:finalQuestionList
                      fromArray:writing
                    numElements:questionsPerSection];
  }

  // Fifth, shuffle our final array.
  [finalQuestionList shuffle];

  return finalQuestionList;
}


#pragma mark - Helper

- (void)randomlyPopulateArray:(NSMutableArray *)toArray
                    fromArray:(NSMutableArray *)fromArray
                  numElements:(NSUInteger)numElements {
  if (fromArray.count < numElements) {
    NSLog(@"Error: Attempted to pull more questions into array than exist.");
    numElements = fromArray.count;
  }
  NSMutableSet *indexSet = [NSMutableSet set];
  int count = 0;
  while (count < numElements) {
    int randIndex = arc4random_uniform((u_int32_t)fromArray.count);
    NSNumber *randNumber = [NSNumber numberWithInt:randIndex];
    if (![indexSet containsObject:randNumber]) {
      WZYQuestion *q = fromArray[randIndex];
      [toArray addObject:q];
      [indexSet addObject:[NSNumber numberWithInt:randIndex]];
      count++;
    }
  }
}

- (void)parseQuestionsFromArray:(NSArray *)array {
  char aValue = 'a';
  for (PFObject *object in array) {
    WZYQuestion *question = [[WZYQuestion alloc] init];
    question.questionId = object[kParseQuestionIdKey];
    question.questionText = object[kParseQuestionTextKey];
    question.questionImageName = object[kParseQuestionImageKey];
    question.questionReading = object[kParsePassageKey];
    question.questionType = [self questionTypeFromString:object[kParseTypeKey]];

    NSString *choice1 = object[kParseChoice1Key];
    if (!choice1) {
      choice1 = @"";
    }

    NSString *choice2 = object[kParseChoice2Key];
    if (!choice2) {
      choice2 = @"";
    }

    NSString *choice3 = object[kParseChoice3Key];
    if (!choice3) {
      choice3 = @"";
    }

    NSString *choice4 = object[kParseChoice4Key];
    if (!choice4) {
      choice4 = @"";
    }

    NSString *choice5 = object[kParseChoice5Key];
    if (!choice5) {
      choice5 = @"";
    }

    question.questionChoices = @[
                                  choice1,
                                  choice2,
                                  choice3,
                                  choice4,
                                  choice5,
                                ];

    NSString *answerString = object[kParseAnswerKey];
    answerString = [answerString lowercaseString];
    question.questionAnswer = ([answerString characterAtIndex:0] - aValue) + 1;

    question.isSAT = [object[kParseIsSATorACTKey] isEqualToString:@"SAT"];
    question.choicesAreImages = [object[kParseImageChoiceKey] boolValue];

    // Populate DNA properties
    question.dnaPercentCorrect = object[kParsePercentCorrectKey];
    question.dnaUsersResponsed = object[kParseQuestionTakenKey];
    question.dnaTimeToAnswer = object[kParseAverageAnswerTimeKey];
    question.dnaDifficulty = object[@"difficulty"];

    self.internalDict[question.questionId] = question;
  }
}

- (NSInteger)numberOfQuestionsForTestType:(WZYTestType)type {
  // TODO: once we have a better way to represent test type in the backend, refactor this to not
  // use a bool.
  BOOL wantSAT = (type == WZYTestSAT);

  // First, find all questions belonging to the right test
  int count = 0;
  for (WZYQuestion *q in self.internalDict.allValues) {
    if (wantSAT && q.isSAT) {
      count++;
    } else if (!wantSAT && !q.isSAT) {
      count++;
    }
  }
  return count;
}

- (WZYQuestionType)questionTypeFromString:(NSString *)string {
  if ([string caseInsensitiveCompare:@"m"] == NSOrderedSame) {
    return WZYQuestionTypeMath;
  } else if ([string caseInsensitiveCompare:@"w"] == NSOrderedSame) {
    return WZYQuestionTypeWriting;
  } else if ([string caseInsensitiveCompare:@"r"] == NSOrderedSame) {
    return WZYQuestionTypeReading;
  } else if ([string caseInsensitiveCompare:@"e"] == NSOrderedSame) {
    return WZYQuestionTypeEnglish;
  }
  return WZYQuestionTypeUnknown;
}

@end
