//
//  WZYSignUpViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 2/7/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYFBViewController.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"
#import "WZYUser.h"

@interface WZYFBViewController ()<UIAlertViewDelegate>
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UIView *shadeView;
@property(nonatomic) UIActivityIndicatorView *activityView;
@end

@implementation WZYFBViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.titleLabel = [WZYLabelUtil defaultLabelWithSize:28.0];
  self.titleLabel.text = @"Connecting to Facebook";
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.numberOfLines = 2;
  [self.view addSubview:self.titleLabel];

  self.shadeView = [[UIView alloc] initWithFrame:self.view.bounds];
  self.shadeView.alpha = 0;
  self.shadeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];

  self.activityView = [[UIActivityIndicatorView alloc]
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [self.shadeView addSubview:self.activityView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self showActivityView];
  NSArray *permissionsArray = @[
                                @"user_education_history",
                                @"public_profile",
                                @"user_friends",
                                @"email"
                              ];

  // Sign the user in with FB. If we successfully get a new user back, make an API request for
  // the data we need. Otherwise, we can push him straight into the Dashboard.
  [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
    if (!user) {
      [self hideActivityView];
      if (error) {
        NSString *errorMessage = [error localizedDescription];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                     message:errorMessage
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
        [av show];
      } else {
        // User-cancelled FB auth, dump us back to main screen.
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
      }
    } else {
      if (user.isNew) {
        [self populateFBUserInfoForUser:user];
      } else {
        [self hideActivityView];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
      }
    }
  }];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.titleLabel.frame = CGRectMake(0,
                                     64.0,
                                     self.view.frame.size.width,
                                     100);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Helpers

- (void)showActivityView {
  [self.view addSubview:self.shadeView];
  [self.activityView sizeToFit];
  CGSize viewSize = self.view.frame.size;
  CGSize actSize = self.activityView.frame.size;
  self.activityView.frame = CGRectMake(viewSize.width / 2 - actSize.width / 2,
                                       viewSize.height / 2 - actSize.height / 2,
                                       actSize.width,
                                       actSize.height);
  [self.activityView startAnimating];
  [UIView animateWithDuration:0.2 animations:^{
    self.shadeView.alpha = 1.0;
  }];
}

- (void)hideActivityView {
  [UIView animateWithDuration:0.2 animations:^{
    self.shadeView.alpha = 0.0;
  } completion:^(BOOL finished) {
    [self.activityView stopAnimating];
    [self.shadeView removeFromSuperview];
  }];
}

- (void)populateFBUserInfoForUser:(PFUser *)user {
  FBRequest *request = [FBRequest requestForMe];
  [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                        id result,
                                        NSError *error) {
    [self hideActivityView];
    if (error) {
      NSString *errorMessage = [error localizedDescription];
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                   message:errorMessage
                                                  delegate:self
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
      [av show];
    } else {
      NSDictionary *userData = (NSDictionary *)result;
      user[kParseFirstNameKey] = userData[@"first_name"];
      user[kParseLastNameKey] = userData[@"last_name"];

      NSArray *educationHistory = userData[@"education"];
      for (NSDictionary *school in educationHistory) {
        if ([school[@"type"] isEqualToString:@"High School"]) {
          NSString *year = school[@"year"][@"name"];
          user[kParseHSNameKey] = school[@"school"][@"name"];
          user[kParseHSYearKey] = year;
        }
      }
      user.email = userData[@"email"];

      [user saveInBackground];
      [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
  }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
