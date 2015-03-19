//
//  WZYDNAVC.h
//  Wizly
//
//  Created by Bezhou Feng on 2/15/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZYQuestion;

@interface WZYDNAVC : UIViewController

- (id)initWithQuestion:(WZYQuestion *)question
      timeSpentSeconds:(NSNumber *)timeSpentSeconds
          answerChoice:(int)answerChoice;

@end
