//
//  WZYSignUpViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 2/7/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYSignUpViewController.h"

#import <Parse/Parse.h>

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"
#import "WZYTextFieldUtil.h"
#import "WZYUser.h"

@interface WZYSignUpViewController () <UITextFieldDelegate>
@property(nonatomic) UIScrollView *scrollView;

@property(nonatomic) UIButton *exitButton;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UITextField *firstNameField;
@property(nonatomic) UITextField *lastNameField;
@property(nonatomic) UITextField *emailField;
@property(nonatomic) UITextField *passwordField;
@property(nonatomic) UITextField *hsNameField;
@property(nonatomic) UITextField *hsYearField;

@property(nonatomic) WZYButton *signButton;

@property(nonatomic) UIView *shadeView;
@property(nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation WZYSignUpViewController

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
  self.titleLabel.text = @"Create an Account";
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:self.titleLabel];

  self.firstNameField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"first name"];
  self.firstNameField.delegate = self;
  [self.scrollView addSubview:self.firstNameField];

  self.lastNameField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"last name"];
  self.lastNameField.delegate = self;
  [self.scrollView addSubview:self.lastNameField];

  self.emailField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"email"];
  self.emailField.delegate = self;
  self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
  self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  [self.scrollView addSubview:self.emailField];

  self.passwordField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"create password"];
  self.passwordField.secureTextEntry = YES;
  self.passwordField.delegate = self;
  [self.scrollView addSubview:self.passwordField];

  self.hsNameField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"high school name"];
  self.hsNameField.delegate = self;
  [self.scrollView addSubview:self.hsNameField];

  self.hsYearField =
      [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"high school graduation year"];
  self.hsYearField.keyboardType = UIKeyboardTypeNumberPad;
  self.hsYearField.delegate = self;
  [self.scrollView addSubview:self.hsYearField];

  self.signButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors purpleColor]];
  self.signButton.text = @"Sign me up";
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
  self.firstNameField.frame = CGRectMake(0,
                                         0,
                                         round(self.view.frame.size.width / 2) - fieldGap,
                                         fieldHeight);

  self.lastNameField.frame = CGRectMake(CGRectGetMaxX(self.firstNameField.frame) + fieldGap,
                                        self.firstNameField.frame.origin.y,
                                        self.view.frame.size.width / 2,
                                        fieldHeight);

  self.emailField.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.firstNameField.frame) + fieldGap,
                                     self.view.frame.size.width,
                                     fieldHeight);

  self.passwordField.frame = CGRectMake(0,
                                  CGRectGetMaxY(self.emailField.frame) + fieldGap,
                                  self.view.frame.size.width,
                                  fieldHeight);

  self.hsNameField.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.passwordField.frame) + fieldGap,
                                      self.view.frame.size.width,
                                      fieldHeight);

  self.hsYearField.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.hsNameField.frame) + fieldGap,
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
  signFrame.origin.y = CGRectGetMaxY(self.hsYearField.frame) + 8.0;
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

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
  if (!string.length) {
    return YES;
  }

  if (textField == self.hsYearField) {
    return [string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound;
  }

  return YES;
}

#pragma mark - Button

- (void)backTapped {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)signTapped {
  if (![self validateEmail]) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                 message:@"Please make sure you've entered your email correctly."
                                                delegate:nil
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    [av show];
    return;
  }

  // Check all fields entered
  if (!self.firstNameField.text.length ||
      !self.lastNameField.text.length ||
      !self.emailField.text.length ||
      !self.passwordField.text.length ||
      !self.hsNameField.text.length ||
      !self.hsYearField.text.length) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                 message:@"Please make sure you've filled out all the fields."
                                                delegate:nil
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    [av show];
    return;
  }

  PFUser *user = [PFUser user];
  user.username = self.emailField.text;
  user.password = self.passwordField.text;
  user.email = self.emailField.text;
  user[kParseFirstNameKey] = self.firstNameField.text;
  user[kParseLastNameKey] = self.lastNameField.text;
  user[kParseHSNameKey] = self.hsNameField.text;
  user[kParseHSYearKey] = self.hsYearField.text;

  [self showActivityView];

  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    [self hideActivityView];
    if (!error) {
      [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
      NSString *errorString = [error userInfo][@"error"];
      NSString *errorMessage =
          [NSString stringWithFormat:@"We got the following error while signing you up:\n"
                                       @"%@\n"
                                       @"Please try again.", errorString];
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                   message:errorMessage
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
      [av show];
    }
  }];
}

- (BOOL)validateEmail {
  NSError *regexError;
  NSString *email = [self.emailField.text copy];
  NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
  NSRegularExpression *regex =
      [[NSRegularExpression alloc] initWithPattern:laxString
                                           options:NSRegularExpressionCaseInsensitive
                                             error:&regexError];
  NSUInteger numMatches =
      [regex numberOfMatchesInString:email options:0 range:NSMakeRange(0, email.length)];
  return numMatches != 0;
}

@end
