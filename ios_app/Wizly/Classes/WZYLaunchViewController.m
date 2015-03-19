//
//  LaunchViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYLaunchViewController.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYDashboardViewController.h"
#import "WZYFBViewController.h"
#import "WZYLoginViewController.h"
#import "WZYNavController.h"
#import "WZYSignUpViewController.h"
#import "WZYQuestionStore.h"

static const CGFloat kTextMargin = 8;
static const CGFloat kButtonSize = 66;

@interface WZYLaunchViewController ()

@property(nonatomic) UIImageView *bgImageView;
//@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UIImageView *titleLogo;
@property(nonatomic) UILabel *subtitleLabel;
@property(nonatomic) WZYButton *signUpButton;
@property(nonatomic) WZYButton *fbButton;
@property(nonatomic) WZYButton *loginButton;

@end

@implementation WZYLaunchViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  WZYQuestionStore *store = [WZYQuestionStore sharedStore];
  [store loadQuestionsFromRemoteWithCompletion:nil];

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

  self.titleLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
  [self.view addSubview:self.titleLogo];

  /*
  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:72.0];
  self.titleLabel.textColor = [UIColor whiteColor];
  self.titleLabel.text = @"wizly";
  //[self.view addSubview:self.titleLabel];*/

  self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
  self.subtitleLabel.textColor = [UIColor whiteColor];
  self.subtitleLabel.text = @"smarter, faster test prep";
  [self.view addSubview:self.subtitleLabel];

  self.signUpButton =
      [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors mainButtonColor]];
  self.signUpButton.text = @"Sign Up with Email";
  [self.signUpButton addTarget:self
                        action:@selector(signUpTapped)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.signUpButton];

  self.fbButton =
      [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors colorFromHexString:@"#2957B2"]];
  self.fbButton.text = @"Continue with Facebook";
  [self.fbButton addTarget:self
                    action:@selector(fbTapped)
          forControlEvents:UIControlEventTouchUpInside];
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

  CGFloat ratio = self.titleLogo.frame.size.width / self.titleLogo.frame.size.height;
  CGFloat logoWidth = round(self.view.frame.size.width * 0.8);
  CGFloat logoHeight = logoWidth / ratio;
  self.titleLogo.frame = CGRectIntegral(
                             CGRectMake(self.view.frame.size.width / 2 - logoWidth / 2,
                                        self.signUpButton.frame.origin.y - logoHeight * 2,
                                        logoWidth,
                                        logoHeight));

  [self.subtitleLabel sizeToFit];
  CGSize labelSize = self.subtitleLabel.frame.size;
  self.subtitleLabel.frame =
      CGRectIntegral(CGRectMake(CGRectGetWidth(self.view.frame) / 2 - labelSize.width / 2,
                                CGRectGetMaxY(self.titleLogo.frame),
                                labelSize.width,
                                labelSize.height));
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // TODO: hack to avoid double sign since we dispatch the log off on a background thread
  // try and find a better way to do this.
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
    [self signInUserIfAvailable];
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button Actions

- (void)signUpTapped {
  WZYSignUpViewController *signVC = [[WZYSignUpViewController alloc] init];
  [self presentViewController:signVC animated:YES completion:nil];
}

- (void)loginTapped {
  WZYLoginViewController *loginVC = [[WZYLoginViewController alloc] init];
  [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)fbTapped {
  WZYFBViewController *fbVC = [[WZYFBViewController alloc] init];
  [self presentViewController:fbVC animated:YES completion:nil];
}

#pragma mark - Login

- (void)signInUserIfAvailable {
  PFUser *currentUser = [PFUser currentUser];
  if (currentUser) {
    WZYDashboardViewController *loginVC = [[WZYDashboardViewController alloc] init];

    WZYNavController *navVC =
    [[WZYNavController alloc] initWithRootViewController:loginVC];
    navVC.edgesForExtendedLayout = UIRectEdgeNone;
    [navVC.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navVC.navigationBar setShadowImage:[UIImage new]];
    [navVC.navigationBar setTranslucent:YES];
    navVC.navigationBar.tintColor = [UIColor whiteColor];

    [self presentViewController:navVC animated:YES completion:nil];
  }
}

@end
