//
//  WZYTestConfigController.m
//  Wizly
//
//  Created by Bezhou Feng on 2/21/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYTestConfigVC.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"
#import "WZYPracticeController.h"
#import "WZYTestViewController.h"

static const CGFloat kTopMargin = 88;
static const CGFloat kLeftMargin = 16;

@interface WZYTestConfigVC ()
@property(nonatomic) UISlider *numberSlider;

@property(nonatomic) UISwitch *mathSwitch;
@property(nonatomic) UISwitch *readingSwitch;
@property(nonatomic) UISwitch *writingSwitch;
@property(nonatomic) UISwitch *scienceSwitch;

@property(nonatomic) UILabel *numberLabel;
@property(nonatomic) UILabel *bigNumberLabel;
@property(nonatomic) UILabel *sectionsLabel;
@property(nonatomic) UILabel *mathLabel;
@property(nonatomic) UILabel *readingLabel;
@property(nonatomic) UILabel *writingLabel;
@property(nonatomic) UILabel *scienceLabel;

@property(nonatomic) WZYButton *startButton;
@end

@implementation WZYTestConfigVC

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.numberLabel = [WZYLabelUtil boldLabelWithSize:20.0];
  self.numberLabel.text = @"Number of questions";
  [self.view addSubview:self.numberLabel];

  // TODO: move this logic somewhere else
  NSInteger maxQuestions =
      [[WZYQuestionStore sharedStore] numberOfQuestionsForTestType:self.testType];
  if (maxQuestions > 100) maxQuestions = 100;
  self.numberSlider = [[UISlider alloc] initWithFrame:CGRectZero];
  self.numberSlider.minimumValue = 5;
  self.numberSlider.maximumValue = maxQuestions;
  self.numberSlider.value = self.numberSlider.maximumValue;
  [self.numberSlider addTarget:self
                        action:@selector(sliderChanged:)
              forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.numberSlider];

  self.bigNumberLabel = [WZYLabelUtil boldLabelWithSize:36.0];
  self.bigNumberLabel.text = [NSString stringWithFormat:@"%i", (int)self.numberSlider.maximumValue];
  [self.view addSubview:self.bigNumberLabel];

  // Section Labels --------------------------------------------------------------------------------

  self.sectionsLabel = [WZYLabelUtil boldLabelWithSize:20.0];
  self.sectionsLabel.text = @"Test Sections";
  [self.view addSubview:self.sectionsLabel];

  self.mathLabel = [WZYLabelUtil defaultLabelWithSize:20.0];
  self.mathLabel.text = @"Math";
  [self.view addSubview:self.mathLabel];

  self.readingLabel = [WZYLabelUtil defaultLabelWithSize:20.0];
  self.readingLabel.text = @"Reading";
  [self.view addSubview:self.readingLabel];

  self.writingLabel = [WZYLabelUtil defaultLabelWithSize:20.0];
  self.writingLabel.text = (self.testType == WZYTestSAT) ? @"Writing" : @"English";
  [self.view addSubview:self.writingLabel];

  if (self.testType == WZYTestACT) {
    self.scienceLabel = [WZYLabelUtil defaultLabelWithSize:20.0];
    self.scienceLabel.text = @"Science";
    [self.view addSubview:self.scienceLabel];
  }

  // Section Switches ------------------------------------------------------------------------------

  self.mathSwitch = [[UISwitch alloc] init];
  self.mathSwitch.on = YES;
  [self.view addSubview:self.mathSwitch];

  self.readingSwitch = [[UISwitch alloc] init];
  self.readingSwitch.on = YES;
  [self.view addSubview:self.readingSwitch];

  self.writingSwitch = [[UISwitch alloc] init];
  self.writingSwitch.on = YES;
  [self.view addSubview:self.writingSwitch];

  if (self.testType == WZYTestACT) {
    self.scienceSwitch = [[UISwitch alloc] init];
    self.scienceSwitch.on = YES;
    [self.view addSubview:self.scienceSwitch];
  }

  self.startButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors mainButtonColor]];
  self.startButton.text = @"start test";
  [self.startButton addTarget:self
                       action:@selector(startTapped)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.startButton];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  [self.numberLabel sizeToFit];
  self.numberLabel.frame = CGRectMake(kLeftMargin,
                                      kTopMargin,
                                      self.numberLabel.frame.size.width,
                                      self.numberLabel.frame.size.height);

  [self.bigNumberLabel sizeToFit];
  self.bigNumberLabel.frame = CGRectMake(self.view.frame.size.width - kLeftMargin - self.bigNumberLabel.frame.size.width,
                                         kTopMargin,
                                         self.bigNumberLabel.frame.size.width,
                                         self.bigNumberLabel.frame.size.height);

  self.numberSlider.frame = CGRectMake(self.numberLabel.frame.origin.x,
                                       CGRectGetMaxY(self.numberLabel.frame) + 24,
                                       self.view.frame.size.width - kLeftMargin * 2,
                                       44);

  [self.sectionsLabel sizeToFit];
  self.sectionsLabel.frame = CGRectMake(kLeftMargin,
                                        CGRectGetMaxY(self.numberSlider.frame) + 16,
                                        self.sectionsLabel.frame.size.width,
                                        self.sectionsLabel.frame.size.height);

  [self.mathLabel sizeToFit];
  self.mathLabel.frame = CGRectMake(kLeftMargin,
                                    CGRectGetMaxY(self.sectionsLabel.frame) + 24,
                                    self.mathLabel.frame.size.width,
                                    self.mathLabel.frame.size.height);

  CGSize switchSize = self.mathSwitch.frame.size;
  self.mathSwitch.frame = CGRectMake(self.view.frame.size.width - kLeftMargin - switchSize.width,
                                     self.mathLabel.frame.origin.y,
                                     switchSize.width,
                                     switchSize.height);

  [self.readingLabel sizeToFit];
  self.readingLabel.frame = CGRectMake(kLeftMargin,
                                    CGRectGetMaxY(self.mathLabel.frame) + 24,
                                    self.readingLabel.frame.size.width,
                                    self.readingLabel.frame.size.height);

  self.readingSwitch.frame = CGRectMake(self.view.frame.size.width - kLeftMargin - switchSize.width,
                                        self.readingLabel.frame.origin.y,
                                        switchSize.width,
                                        switchSize.height);

  [self.writingLabel sizeToFit];
  self.writingLabel.frame = CGRectMake(kLeftMargin,
                                    CGRectGetMaxY(self.readingLabel.frame) + 24,
                                    self.writingLabel.frame.size.width,
                                    self.writingLabel.frame.size.height);

  self.writingSwitch.frame = CGRectMake(self.view.frame.size.width - kLeftMargin - switchSize.width,
                                        self.writingLabel.frame.origin.y,
                                        switchSize.width,
                                        switchSize.height);

  if (self.testType == WZYTestACT) {
    [self.scienceLabel sizeToFit];
    self.scienceLabel.frame = CGRectMake(kLeftMargin,
                                         CGRectGetMaxY(self.writingLabel.frame) + 24,
                                         self.scienceLabel.frame.size.width,
                                         self.scienceLabel.frame.size.height);

    self.scienceSwitch.frame = CGRectMake(self.view.frame.size.width - kLeftMargin - switchSize.width,
                                          self.scienceLabel.frame.origin.y,
                                          switchSize.width,
                                          switchSize.height);
  }

  self.startButton.frame = CGRectMake(0,
                                      self.view.frame.size.height - 66,
                                      self.view.frame.size.width,
                                      66);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Buttons

- (void)startTapped {
  WZYQuestionType typeFlag = 0;
  if (self.mathSwitch.on) {
    typeFlag |= WZYQuestionTypeMath;
  }
  if (self.readingSwitch.on) {
    typeFlag |= WZYQuestionTypeReading;
  }
  if (self.writingSwitch.on) {
    typeFlag |= WZYQuestionTypeWriting;
  }
  if (self.scienceSwitch.on) {
    typeFlag |= WZYQuestionTypeScience;
  }

  WZYPracticeController *practice =
      [[WZYPracticeController alloc] initWithNumQuestions:round(self.numberSlider.value)
                                             questionType:typeFlag
                                                     user:nil
                                                 testMode:YES];

  WZYTestViewController *testVC = [[WZYTestViewController alloc] initWithPracticeController:practice];
  [self.navigationController pushViewController:testVC animated:YES];
}

- (void)sliderChanged:(UISlider *)slider {
  self.bigNumberLabel.text = [NSString stringWithFormat:@"%i", (int)round(slider.value)];
}

@end
