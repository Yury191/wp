//
//  WZYScoreCalculator.h
//  Wizly
//
//  Created by Bezhou Feng on 2/16/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZYScoreCalculator : NSObject

+ (int)mathScoreForCorrect:(float)correct;
+ (int)readingScoreForCorrect:(float)correct;
+ (int)writingScoreForCorrect:(float)correct;

@end
