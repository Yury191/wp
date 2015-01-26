//
//  WZYDashboardViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYDashboardViewController.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYDashboardPerfView.h"
#import "WZYLabelUtil.h"
#import "WZYTestSelectionController.h"

static const CGFloat kMarginTop = 48;
static const CGFloat kMarginTitle = 24;

@interface WZYDashboardViewController ()

@property(nonatomic) UIButton *settingsButton;

@property(nonatomic) UILabel *greetingLabel;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) WZYDashboardPerfView *performanceView;

@property(nonatomic) WZYButton *lessonButton;
@property(nonatomic) WZYButton *practiceButton;
@property(nonatomic) WZYButton *reviewButton;

@end

@implementation WZYDashboardViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Home";
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.settingsButton.titleLabel.font = [UIFont systemFontOfSize:24.0];
  [self.settingsButton setTitle:@"\u2699" forState:UIControlStateNormal];
  [self.settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.settingsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [self.view addSubview:self.settingsButton];

  self.greetingLabel = [WZYLabelUtil defaultLabelWithSize:18.0];
  self.greetingLabel.text = [self welcomeMessageWithDate];
  [self.view addSubview:self.greetingLabel];

  self.titleLabel = [WZYLabelUtil defaultLabelWithSize:40.0];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.text = @"Your Progress";
  [self.view addSubview:self.titleLabel];

  self.performanceView = [[WZYDashboardPerfView alloc] initWithFrame:CGRectZero];
  self.performanceView.layer.borderColor = [UIColor redColor].CGColor;
  self.performanceView.layer.borderWidth = 1.0;
  [self.view addSubview:self.performanceView];

  self.lessonButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                                 color:[WZYColors colorFromHexString:@"#650102"]];
  self.lessonButton.text = @"free lesson";
  [self.view addSubview:self.lessonButton];

  self.practiceButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                                 color:[WZYColors purpleColor]];
  self.practiceButton.text = @"practice";
  [self.practiceButton addTarget:self
                          action:@selector(practiceTapped)
                forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.practiceButton];

  self.reviewButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                                 color:[WZYColors cyanColor]];
  self.reviewButton.text = @"review past questions";
  [self.view addSubview:self.reviewButton];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  CGSize viewSize = self.view.frame.size;

  self.settingsButton.frame = CGRectMake(0, 20, 44, 44);

  [self.greetingLabel sizeToFit];
  CGSize greetingSize = self.greetingLabel.frame.size;
  self.greetingLabel.frame =
      CGRectIntegral(CGRectMake(viewSize.width / 2 - greetingSize.width / 2,
                                kMarginTop,
                                greetingSize.width,
                                greetingSize.height));

  [self.titleLabel sizeToFit];
  self.titleLabel.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.greetingLabel.frame),
                                     viewSize.width,
                                     self.titleLabel.frame.size.height);

  self.performanceView.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.titleLabel.frame) + kMarginTitle,
                                          viewSize.width,
                                          300);

  CGFloat buttonHeight = round((viewSize.height - CGRectGetMaxY(self.performanceView.frame)) / 3);

  self.lessonButton.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.performanceView.frame),
                                       viewSize.width,
                                       buttonHeight);

  self.practiceButton.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.lessonButton.frame),
                                       viewSize.width,
                                       buttonHeight);

  self.reviewButton.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.practiceButton.frame),
                                       viewSize.width,
                                       buttonHeight);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button Press

- (void)practiceTapped {
  WZYTestSelectionController *testVC = [[WZYTestSelectionController alloc] init];
  [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark - Helpers

- (NSString *)welcomeMessageWithDate {
  NSString *welcomeString;
  NSString *name = @"Yury";

  NSDateComponents *components =
      [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
  NSInteger hour = [components hour];

  if (hour >= 0 && hour < 12) {
    welcomeString = @"Good morning";
  } else if (hour >= 12 && hour < 17) {
    welcomeString = @"Good afternoon";
  } else if (hour >= 17) {
    welcomeString = @"Good evening";
  }

  welcomeString = [welcomeString stringByAppendingString:@", %@."];
  welcomeString = [NSString stringWithFormat:welcomeString, name];

  return welcomeString;
}

@end
