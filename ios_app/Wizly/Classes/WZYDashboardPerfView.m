//
//  WZYDashboardPerfView.m
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYDashboardPerfView.h"

@interface WZYDashboardPerfView ()
@property(nonatomic) WZYUser *user;
@end

@implementation WZYDashboardPerfView

- (id)initWithFrame:(CGRect)frame user:(WZYUser *)user {
  self = [super initWithFrame:frame];
  if (self) {
    self.user = user;
  }
  return self;
}

- (void)layoutSubviews {
  // TODO: fill this out
}

@end
