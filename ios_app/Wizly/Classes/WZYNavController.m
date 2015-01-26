//
//  WZYNavController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYNavController.h"

@interface WZYNavController ()

@end

@implementation WZYNavController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
  return [self.topViewController prefersStatusBarHidden];
}

@end
