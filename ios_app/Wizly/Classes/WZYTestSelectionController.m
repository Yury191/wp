//
//  WZYTestSelectionController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYTestSelectionController.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYDiagnosticInstructionVC.h"
#import "WZYLabelUtil.h"
#import "WZYQuestionStore.h"
#import "WZYTestConfigVC.h"
#import "WZYTestViewController.h"

static const CGFloat kTestButtonHeight = 66.0;

@interface WZYTestSelectionController ()
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) WZYButton *diagnosticButton;
@property(nonatomic) WZYButton *satButton;
@property(nonatomic) WZYButton *actButton;
@end

@implementation WZYTestSelectionController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.titleLabel = [WZYLabelUtil boldLabelWithSize:28.0];
  self.titleLabel.text = @"Pick a test!";
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:self.titleLabel];

  self.diagnosticButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                                     color:[WZYColors purpleColor]];
  self.diagnosticButton.text = @"Diagnostic Test: SAT or ACT?";
  [self.diagnosticButton addTarget:self
                            action:@selector(diagnosticTapped)
                  forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.diagnosticButton];

  self.satButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                              color:[WZYColors cyanColor]];
  self.satButton.text = @"SAT";
  [self.satButton addTarget:self
                     action:@selector(satTapped)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.satButton];

  self.actButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                              color:[WZYColors colorFromHexString:@"#196614"]];
  self.actButton.text = @"ACT";
  [self.view addSubview:self.actButton];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];

  self.diagnosticButton.frame =
      CGRectMake(0,
                 round(self.view.frame.size.height / 2 - kTestButtonHeight / 2),
                 self.view.frame.size.width,
                 kTestButtonHeight);

  self.satButton.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.diagnosticButton.frame),
                                    round(self.view.frame.size.width / 2),
                                    kTestButtonHeight);

  self.actButton.frame = CGRectMake(CGRectGetMaxX(self.satButton.frame),
                                    CGRectGetMaxY(self.diagnosticButton.frame),
                                    round(self.view.frame.size.width / 2),
                                    kTestButtonHeight);

  [self.titleLabel sizeToFit];
  self.titleLabel.frame = CGRectMake(0,
                                     self.diagnosticButton.frame.origin.y - kTestButtonHeight,
                                     self.view.frame.size.width,
                                     self.titleLabel.frame.size.height);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button Press

- (void)diagnosticTapped {
  WZYDiagnosticInstructionVC *diagVC = [[WZYDiagnosticInstructionVC alloc] init];
  [self.navigationController pushViewController:diagVC animated:YES];
}

- (void)satTapped {
  [self configTestForType:WZYTestSAT];
}

- (void)actTapped {
  [self configTestForType:WZYTestACT];
}

- (void)configTestForType:(WZYTestType)type {
  WZYTestConfigVC *configVC = [[WZYTestConfigVC alloc] init];
  configVC.testType = type;

  [self.navigationController pushViewController:configVC animated:YES];
}

@end
