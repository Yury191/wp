//
//  WZYDiagnosticInstructionVC.m
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYDiagnosticInstructionVC.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"

static const CGFloat kLeftMargin = 24.0;
static const CGFloat kTopMargin = 16.0;

@interface WZYDiagnosticInstructionVC ()
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *infoLabel;
@property(nonatomic) UILabel *itemsLabel;
@property(nonatomic) UILabel *itemListLabel;
@property(nonatomic) WZYButton *startButton;
@end

@implementation WZYDiagnosticInstructionVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.titleLabel = [WZYLabelUtil boldLabelWithSize:28.0];
  self.titleLabel.text = @"Diagnostic Instructions";
  [self.view addSubview:self.titleLabel];

  self.infoLabel = [WZYLabelUtil defaultLabelWithSize:20.0];
  self.infoLabel.text = @"This 60-minute timed diagnostic will tell you whether you should prep "
                            @"for the ACT or SAT and also approximate your score on both tests.";
  self.infoLabel.numberOfLines = 0;
  [self.view addSubview:self.infoLabel];

  self.itemsLabel = [WZYLabelUtil boldLabelWithSize:28.0];
  self.itemsLabel.text = @"What you need";
  [self.view addSubview:self.itemsLabel];

  self.itemListLabel = [WZYLabelUtil defaultLabelWithSize:20.0];
  self.itemListLabel.text = @"- a TI-83 or TI-84 Plus Calculator\n\n"
                              @"- a pencil and paper (for math)\n\n"
                              @"- a quiet area";
  self.itemListLabel.numberOfLines = 0;
  [self.view addSubview:self.itemListLabel];

  self.startButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors cyanColor]];
  self.startButton.text = @"Start";
  [self.view addSubview:self.startButton];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  [self.titleLabel sizeToFit];
  self.titleLabel.frame = CGRectMake(kLeftMargin,
                                     CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                     self.titleLabel.frame.size.width,
                                     self.titleLabel.frame.size.height);

  self.infoLabel.frame = CGRectMake(kLeftMargin,
                                    CGRectGetMaxY(self.titleLabel.frame),
                                    self.view.frame.size.width - kLeftMargin * 2,
                                    160);

  [self.itemsLabel sizeToFit];
  self.itemsLabel.frame = CGRectMake(kLeftMargin,
                                     CGRectGetMaxY(self.infoLabel.frame),
                                     self.itemsLabel.frame.size.width,
                                     self.itemsLabel.frame.size.height);

  self.itemListLabel.frame = CGRectMake(kLeftMargin,
                                    CGRectGetMaxY(self.itemsLabel.frame),
                                    self.view.frame.size.width - kLeftMargin * 2,
                                    160);

  self.startButton.frame = CGRectMake(0,
                                      self.view.frame.size.height - 66,
                                      self.view.frame.size.width,
                                      66);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
