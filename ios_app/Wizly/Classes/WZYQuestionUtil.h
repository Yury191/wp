//
//  WZYQuestionUtil.h
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

@import Foundation;

#import "WZYQuestion.h"

@interface WZYQuestionUtil : NSObject

+ (NSArray *)questionSetForTopics:(WZYQuestionType)questionType
                     numQuestions:(NSUInteger)numQuestions;

@end
