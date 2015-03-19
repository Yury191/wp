//
//  WZYQuestion.h
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

@import UIKit;

typedef NS_OPTIONS(NSUInteger, WZYQuestionType) {
  WZYQuestionTypeUnknown = 0,
  WZYQuestionTypeMath = 1 << 1,
  WZYQuestionTypeReading = 1 << 2,
  WZYQuestionTypeWriting = 1 << 3,
  WZYQuestionTypeEnglish = 1 << 4,
  WZYQuestionTypeScience = 1 << 5,
  WZYQuestionTypeAllSAT = WZYQuestionTypeMath | WZYQuestionTypeReading | WZYQuestionTypeWriting,
  WZYQuestionTypeAllACT = WZYQuestionTypeMath | WZYQuestionTypeReading | WZYQuestionTypeWriting | WZYQuestionTypeScience,
};

@interface WZYQuestion : NSObject

@property(nonatomic) NSString *questionId;
@property(nonatomic) NSString *questionText;
@property(nonatomic) NSString *questionReading;
@property(nonatomic) UIImage *questionImage;
@property(nonatomic) NSString *questionImageName;
@property(nonatomic) WZYQuestionType questionType;

// DNA properties
@property(nonatomic) NSString *dnaPercentCorrect;
@property(nonatomic) NSString *dnaUsersResponsed;
@property(nonatomic) NSString *dnaTimeToAnswer;
@property(nonatomic) NSString *dnaDifficulty;

@property(nonatomic, assign) BOOL isSAT;
@property(nonatomic, assign) BOOL choicesAreImages;

/** Numerical value corresponding to the alphabetical letter (e.g. A = 1, B = 2) **/
@property(nonatomic, assign) NSUInteger questionAnswer;

/** Strings for each answer option **/
@property(nonatomic) NSArray *questionChoices;

@end
