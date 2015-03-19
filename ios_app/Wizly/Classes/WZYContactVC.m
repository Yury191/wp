//
//  WZYContactVC.m
//  Wizly
//
//  Created by Bezhou Feng on 2/22/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYContactVC.h"

#import <Parse/Parse.h>

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"
#import "WZYUser.h"
#import "WZYTextFieldUtil.h"

static const CGFloat kLeftMargin = 16.0;

static NSString *kWaitingForTutorKey = @"waitingForTutoar";

@interface WZYContactVC ()<UITextFieldDelegate>
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *textLabel;
@property(nonatomic) UIButton *backButton;

@property(nonatomic) UILabel *cellLabel;
@property(nonatomic) UITextField *cellField;
@property(nonatomic) WZYButton *cellButton;
@property(nonatomic) WZYButton *noThanksButton;

@property(nonatomic) UIScrollView *scrollView;
@end

@implementation WZYContactVC

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self registerForKeyboardNotifications];

  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  self.scrollView.contentSize = self.view.bounds.size;
  [self.view addSubview:self.scrollView];

  PFUser *user = [PFUser currentUser];
  NSString *name = user[kParseFirstNameKey];

  self.cellLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.cellLabel.text = @"Uh-oh, it looks like we don't have your number on file yet.\n\n"
      @"If you want, enter it below to help our tutors schedule your free lesson.\n\n"
      @"Otherwise, we'll contact you at the email you signed up with.";
  self.cellLabel.numberOfLines = 0;
  self.cellLabel.lineBreakMode = NSLineBreakByWordWrapping;
  [self.scrollView addSubview:self.cellLabel];

  self.cellField = [WZYTextFieldUtil defaultTextFieldWithPlaceholder:@"phone number"];
  self.cellField.keyboardType = UIKeyboardTypePhonePad;
  self.cellField.backgroundColor = [WZYColors cyanColor];
  self.cellField.delegate = self;
  [self.scrollView addSubview:self.cellField];

  self.cellButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors mainButtonColor]];
  self.cellButton.text = @"Send my number";
  self.cellButton.enabled = NO;
  [self.cellButton addTarget:self
                      action:@selector(cellTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.scrollView addSubview:self.cellButton];

  self.noThanksButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors purpleColor]];
  self.noThanksButton.text = @"No thanks";
  [self.noThanksButton addTarget:self
                      action:@selector(noThanksButton)
            forControlEvents:UIControlEventTouchUpInside];
  [self.scrollView addSubview:self.noThanksButton];

  self.titleLabel = [WZYLabelUtil defaultLabelWithSize:24.0];
  self.titleLabel.text =
      [NSString stringWithFormat:@"Thanks %@!\n\n"
       @"A message has been sent to one of our geniuses. We'll be in touch shortly!", name];
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  [self.view addSubview:self.titleLabel];

  self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
  [self.backButton setTitleColor:[WZYColors mainButtonColor] forState:UIControlStateNormal];
  [self.backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [self.backButton addTarget:self
                       action:@selector(backTapped)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.backButton];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.backButton.frame = CGRectMake(kLeftMargin, 24, 44, 44);

  PFUser *user = [PFUser currentUser];
  // If the user has opted not to give their number, we'll store an empty string. If the string
  // is completely nil, use that as a sign we need to prompt them for the number.
  if (user[kParsePhoneKey]) {
    self.cellLabel.hidden = YES;
    self.cellField.hidden = YES;
    self.cellButton.hidden = YES;
    self.noThanksButton.hidden = YES;

    self.titleLabel.hidden = NO;
  } else {
    self.titleLabel.hidden = YES;

    self.cellLabel.hidden = NO;
    self.cellField.hidden = NO;
    self.cellButton.hidden = NO;
    self.noThanksButton.hidden = NO;
  }

  self.scrollView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.backButton.frame),
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);

  self.cellLabel.frame = CGRectMake(kLeftMargin,
                                    0,
                                    self.view.frame.size.width - 2 * kLeftMargin,
                                    200);

  self.cellField.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.cellLabel.frame) + 8.0,
                                    self.view.frame.size.width,
                                    44);

  self.cellButton.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.cellField.frame) + 8.0,
                                     self.view.frame.size.width,
                                     66);

  self.noThanksButton.frame = CGRectMake(0,
                                         CGRectGetMaxY(self.cellButton.frame),
                                         self.view.frame.size.width,
                                         66);

  [self.titleLabel sizeToFit];
  CGFloat titleWidth = self.view.frame.size.width - (2 * kLeftMargin);
  self.titleLabel.frame = CGRectMake(kLeftMargin,
                                     48,
                                     titleWidth,
                                     300);

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  PFUser *user = [PFUser currentUser];
  if (user[kParsePhoneKey]) {
    [self sendMessage];
  }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)backTapped {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper

- (void)sendMessage {
  [self.cellField endEditing:NO];
  
  PFUser *user = [PFUser currentUser];
  if (![user[kWaitingForTutorKey] boolValue]) {
    NSString *cellNumber = self.cellField.text;
    if (!cellNumber.length) {
      cellNumber = @"";
    }
    [self.view setNeedsLayout];
    [PFCloud callFunctionInBackground:@"emailTutor"
                       withParameters:@{@"userEmail" : user.email,
                                        @"cellNumber" : cellNumber,
                                        @"userName" : user[kParseFirstNameKey],
                                        }
     block:^(id object, NSError *error) {
       if (error) {
         NSLog(@"Error sending email: %@", error);
       } else {
         user[kWaitingForTutorKey] = [NSNumber numberWithBool:YES];
         [user saveInBackground];
       }
    }];
  }
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

  [self.scrollView setContentOffset:CGPointMake(0, self.cellField.frame.origin.y) animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;

}

#pragma mark - Buttons

- (void)cellTapped {
  PFUser *user = [PFUser currentUser];
  user[kParsePhoneKey] = self.cellField.text;
  [user saveInBackground];
  [self sendMessage];
}

- (void)noThanksTapped {
  PFUser *user = [PFUser currentUser];
  user[kParsePhoneKey] = @"";
  [user saveInBackground];
  [self sendMessage];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
  if (string.length) {
    self.cellButton.enabled = YES;
  } else if (textField.text.length == 1) {
    self.cellButton.enabled = NO;
  }
  return YES;
}

@end
