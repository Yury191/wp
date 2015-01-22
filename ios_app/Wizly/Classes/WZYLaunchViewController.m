//
//  LaunchViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYLaunchViewController.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLoginViewController.h"

// TODO: remove
#import "WZYDashboardViewController.h"

static const CGFloat kTextMargin = 8;
static const CGFloat kButtonSize = 66;

@interface WZYLaunchViewController ()

@property(nonatomic) UIImageView *bgImageView;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *subtitleLabel;
@property(nonatomic) WZYButton *signUpButton;
@property(nonatomic) WZYButton *fbButton;
@property(nonatomic) WZYButton *loginButton;

@end

@implementation WZYLaunchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  // Remove "back" title when we push a new VC onto the stack
  self.navigationItem.backBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@""
                                       style:UIBarButtonItemStylePlain
                                      target:nil
                                      action:nil];

  self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg.png"]];
  UIView *bgTintView = [[UIView alloc] initWithFrame:self.bgImageView.frame];
  bgTintView.backgroundColor = [WZYColors mainBackgroundColor];
  bgTintView.alpha = 0.5;
  bgTintView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.bgImageView addSubview:bgTintView];
  [self.view addSubview:self.bgImageView];

  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:72.0];
  self.titleLabel.textColor = [UIColor whiteColor];
  self.titleLabel.text = @"wizly";
  [self.view addSubview:self.titleLabel];

  self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
  self.subtitleLabel.textColor = [UIColor whiteColor];
  self.subtitleLabel.text = @"smarter, faster test prep";
  [self.view addSubview:self.subtitleLabel];

  self.signUpButton =
      [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors mainButtonColor]];
  self.signUpButton.text = @"Sign Up with Email";
  [self.view addSubview:self.signUpButton];

  self.fbButton =
      [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors colorFromHexString:@"#2957B2"]];
  self.fbButton.text = @"Continue with Facebook";
  [self.view addSubview:self.fbButton];

  self.loginButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[UIColor clearColor]];
  self.loginButton.textLabel.font = [self.loginButton.textLabel.font fontWithSize:16.0];
  self.loginButton.text = @"already have an account? login here";
  [self.loginButton addTarget:self
                       action:@selector(loginTapped)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.loginButton];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.bgImageView.frame = self.view.bounds;

  self.signUpButton.frame =
      CGRectIntegral(CGRectMake(0,
                                CGRectGetHeight(self.view.frame) / 2,
                                CGRectGetWidth(self.view.frame),
                                kButtonSize));

  self.fbButton.frame =
      CGRectIntegral(CGRectMake(0,
                                CGRectGetMaxY(self.signUpButton.frame),
                                CGRectGetWidth(self.view.frame),
                                kButtonSize));

  self.loginButton.frame =
        CGRectIntegral(CGRectMake(0,
                                  CGRectGetHeight(self.view.frame) - kButtonSize - kTextMargin,
                                  CGRectGetWidth(self.view.frame),
                                  kButtonSize));

  
  [self.titleLabel sizeToFit];
  CGSize labelSize = self.titleLabel.frame.size;
  self.titleLabel.frame =
      CGRectIntegral(CGRectMake(CGRectGetWidth(self.view.frame) / 2 - labelSize.width / 2,
                                self.signUpButton.frame.origin.y - labelSize.height * 1.8,
                                labelSize.width,
                                labelSize.height));

  [self.subtitleLabel sizeToFit];
  labelSize = self.subtitleLabel.frame.size;
  self.subtitleLabel.frame =
      CGRectIntegral(CGRectMake(CGRectGetWidth(self.view.frame) / 2 - labelSize.width / 2,
                                CGRectGetMaxY(self.titleLabel.frame),
                                labelSize.width,
                                labelSize.height));
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button Actions

- (void)loginTapped {
  WZYDashboardViewController *loginVC = [[WZYDashboardViewController alloc] init];
  [self presentViewController:loginVC animated:YES completion:nil];
  //[self.navigationController pushViewController:loginVC animated:YES];
}

@end
