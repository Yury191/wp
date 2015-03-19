//
//  WZYDashboardPerfView.h
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//


@import UIKit;

#import "WZYUser.h"

extern const NSString *kPerfNumKey;
extern const NSString *kPerfScoreKey;
extern const NSString *kMathScoreKey;
extern const NSString *kReadingScoreKey;
extern const NSString *kWritingScoreKey;
extern const NSString *kScienceScoreKey;

@interface WZYDashboardPerfView : UIView

- (id)initWithFrame:(CGRect)frame user:(WZYUser *)user;

- (void)updateWithQuestionDict:(NSDictionary *)questionDict;

@end
