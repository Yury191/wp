//
//  WZYQuestion.h
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

@import UIKit;

typedef NS_OPTIONS(NSUInteger, WZYQuestionType) {
  WZYQuestionTypeMath = 0 >> 1,
  WZYQuestionTypeReading= 0 >> 2,
  WZYQuestioNTypeWriting = 0 >> 3,
};

@interface WZYQuestion : NSObject

@property(nonatomic) NSUInteger questionNumber;
@property(nonatomic) NSString *questionTitle;
@property(nonatomic) NSString *questionText;
@property(nonatomic) NSString *questionReading;
@property(nonatomic) UIImage *questionImage;
@property(nonatomic) WZYQuestionType questionType;

/** Numerical value corresponding to the alphabetical letter (e.g. A = 1, B = 2) **/
@property(nonatomic) NSUInteger questionAnswer;

@end
