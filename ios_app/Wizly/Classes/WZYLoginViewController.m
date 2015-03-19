//
//  WZYSignUpViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 2/7/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYLoginViewController.h"

#import <Parse/Parse.h>

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"
#import "WZYTextFieldUtil.h"

@interface WZYLoginViewController () <UITextFieldDelegate>
@property(nonatomic) UIScrollView *scrollView;

@property(nonatomic) UIButton *exitButton;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UITextField *firstNameField;
@property(nonatomic) UITextField *lastNameField;
@property(nonatomic) UITextField *userField;
@property(nonatomic) UITextField *passwordField;
@property(nonatomic) UITextField *hsNameField;
@property(nonatomic) UITextField *hsYearField;

@property(nonatomic) WZYButton *signButton;

@property(nonatomic) UIView *shadeView;
@property(nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation WZYLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self registerForKeyboardNotifications];
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  self.scrollView.contentSize = self.view.bounds.size;
  [self.view addSubview:self.scrollView];

  self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.exitButton setTitle:@"Back" forState:UIControlStateNormal];
  [self.exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.exitButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [self.exitButton addTarget:self
                      action:@selector(backTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.exitButton];

  self.titleLabel = [WZYLabelUtil defaultLabelWithSize:32.0];
  self.titleLabel.text = @"Sign In";
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:self.titleLabel];

  self.userField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"email"];
  self.userField.delegate = self;
  self.userField.autocorrectionType = UITextAutocorrectionTypeNo;
  self.userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  [self.scrollView addSubview:self.userField];

  self.passwordField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"password"];
  self.passwordField.secureTextEntry = YES;
  self.passwordField.delegate = self;
  [self.scrollView addSubview:self.passwordField];

  self.signButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors purpleColor]];
  self.signButton.text = @"Sign me in";
  [self.signButton addTarget:self
                      action:@selector(signTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.scrollView addSubview:self.signButton];

  self.shadeView = [[UIView alloc] initWithFrame:self.view.bounds];
  self.shadeView.alpha = 0;
  self.shadeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];

  self.activityView = [[UIActivityIndicatorView alloc]
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [self.shadeView addSubview:self.activityView];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.exitButton.frame = CGRectMake(0, 16, 60, 44);

  [self.titleLabel sizeToFit];
  self.titleLabel.frame = CGRectMake(0,
                                     64.0,
                                     self.view.frame.size.width,
                                     self.titleLabel.frame.size.height);

  self.scrollView.frame =
      CGRectMake(0,
                 CGRectGetMaxY(self.titleLabel.frame) + 56.0,
                 self.view.frame.size.width,
                 self.view.frame.size.height - CGRectGetMaxY(self.titleLabel.frame) - 48.0);
  self.scrollView.contentSize = self.scrollView.frame.size;

  CGFloat fieldHeight = 44;
  CGFloat fieldGap = 2;

  self.userField.frame = CGRectMake(0,
                                    0,
                                    self.view.frame.size.width,
                                    fieldHeight);

  self.passwordField.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.userField.frame) + fieldGap,
                                        self.view.frame.size.width,
                                        fieldHeight);

  self.signButton.frame = CGRectMake(0,
                                     self.scrollView.frame.size.height - 88,
                                     self.view.frame.size.width,
                                     88);
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
  NSDictionary* info = [notification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;

  // Move sign up button right below hs year
  CGRect signFrame = self.signButton.frame;
  signFrame.origin.y = CGRectGetMaxY(self.passwordField.frame) + 8.0;
  self.signButton.frame = signFrame;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;

  // Move sign up button back to bottom of scroll view
  CGRect signFrame = self.signButton.frame;
  signFrame.origin.y = self.scrollView.frame.size.height - signFrame.size.height;
  self.signButton.frame = signFrame;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  return [textField resignFirstResponder];
}

#pragma mark - Button

- (void)backTapped {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)signTapped {
  // Check all fields entered
  if (!self.userField.text.length ||
      !self.passwordField.text.length) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                 message:@"Please make sure you've filled out all the fields."
                                                delegate:nil
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    [av show];
    return;
  }

  [self showActivityView];

  [PFUser logInWithUsernameInBackground:self.userField.text
                               password:self.passwordField.text
                                  block:^(PFUser *user, NSError *error) {
    [self hideActivityView];
    if (user) {
      [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
      NSLog(@"error: %@", error);
      NSString *errorMessage = @"Sorry, there was a problem logging you in. Please try again.";
      if (error.code == kPFErrorObjectNotFound) {
        errorMessage = @"Sorry, we were unable to find a user with that email and password.";
      }
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                   message:errorMessage
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
      [av show];
    }
  }];

}

@end
