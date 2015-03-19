//
//  WZYDNAVC.m
//  Wizly
//
//  Created by Bezhou Feng on 2/15/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYDNAVC.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"
#import "WZYQuestion.h"

static const CGFloat kLeftMargin = 24.0;
static const CGFloat kBottomMargin = 8.0;

@interface WZYDNAVC ()
@property(nonatomic) WZYQuestion *question;
@property(nonatomic) NSNumber *timeSpentSeconds;
@property(nonatomic, assign) int answerChoice;

@property(nonatomic) UIButton *backButton;

@property(nonatomic) WZYButton *helpButton;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *difficultyLabel;
@property(nonatomic) UILabel *answeredLabel;
@property(nonatomic) UILabel *numResponsesLabel;
@property(nonatomic) UILabel *myAnswerLabel;
@property(nonatomic) UILabel *correctAnswerLabel;
@property(nonatomic) UILabel *myTimeLabel;
@property(nonatomic) UILabel *avgTimeLabel;
@property(nonatomic) UILabel *explanationTitleLabel;
@property(nonatomic) UITextView *explanationTextView;
@end

@implementation WZYDNAVC

- (id)initWithQuestion:(WZYQuestion *)question
      timeSpentSeconds:(NSNumber *)timeSpentSeconds
          answerChoice:(int)answerChoice {
  self = [super init];
  if (self) {
    _question = question;
    _timeSpentSeconds = timeSpentSeconds;
    _answerChoice = answerChoice;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
  [self.backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
  [self.backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [self.backButton addTarget:self
                      action:@selector(backTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.backButton];

  self.titleLabel = [WZYLabelUtil defaultLabelWithSize:28.0];
  self.titleLabel.text = @"Question DNA";
  [self.view addSubview:self.titleLabel];

  self.difficultyLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.difficultyLabel.text = @"Hard \t\t difficulty";
  [self.view addSubview:self.difficultyLabel];

  self.answeredLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.answeredLabel.text = @"25% \t\t answered correctly";
  [self.view addSubview:self.answeredLabel];

  self.numResponsesLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.numResponsesLabel.text = @"29,953 \t\t user responses";
  [self.view addSubview:self.numResponsesLabel];

  self.myAnswerLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.myAnswerLabel.numberOfLines = 2;
  self.myAnswerLabel.text = @"your answer\nE";
  [self.view addSubview:self.myAnswerLabel];

  self.correctAnswerLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.correctAnswerLabel.numberOfLines = 2;
  self.correctAnswerLabel.text = @"correct answer\nE";
  [self.view addSubview:self.correctAnswerLabel];

  self.myTimeLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.myTimeLabel.numberOfLines = 2;
  self.myTimeLabel.text = @"your time\n45 sec";
  [self.view addSubview:self.myTimeLabel];

  self.avgTimeLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
  self.avgTimeLabel.numberOfLines = 2;
  self.avgTimeLabel.text = @"average time\n2 min 5 sec";
  [self.view addSubview:self.avgTimeLabel];

  self.helpButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors mainButtonColor]];
  self.helpButton.text = @"get help";
  [self.view addSubview:self.helpButton];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateLabels];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.backButton.frame = CGRectMake(self.view.frame.size.width - 66, 32, 66, 44);

  [self.titleLabel sizeToFit];
  self.titleLabel.frame = CGRectMake(kLeftMargin,
                                     64,
                                     self.titleLabel.frame.size.width,
                                     self.titleLabel.frame.size.height);

  [self.difficultyLabel sizeToFit];
  self.difficultyLabel.frame = CGRectMake(kLeftMargin,
                                          CGRectGetMaxY(self.titleLabel.frame) + kBottomMargin * 2,
                                          self.difficultyLabel.frame.size.width,
                                          self.difficultyLabel.frame.size.height);

  [self.answeredLabel sizeToFit];
  self.answeredLabel.frame = CGRectMake(kLeftMargin,
                                        CGRectGetMaxY(self.difficultyLabel.frame) + kBottomMargin,
                                        self.answeredLabel.frame.size.width,
                                        self.answeredLabel.frame.size.height);

  [self.numResponsesLabel sizeToFit];
  self.numResponsesLabel.frame = CGRectMake(kLeftMargin,
                                        CGRectGetMaxY(self.answeredLabel.frame) + kBottomMargin,
                                        self.numResponsesLabel.frame.size.width,
                                        self.numResponsesLabel.frame.size.height);

  [self.myAnswerLabel sizeToFit];
  self.myAnswerLabel.frame = CGRectMake(kLeftMargin,
                                        CGRectGetMaxY(self.numResponsesLabel.frame) + kBottomMargin,
                                        self.myAnswerLabel.frame.size.width,
                                        66);

  [self.correctAnswerLabel sizeToFit];
  self.correctAnswerLabel.frame = CGRectMake(CGRectGetMaxX(self.myAnswerLabel.frame) + kLeftMargin,
                                        CGRectGetMaxY(self.numResponsesLabel.frame) + kBottomMargin,
                                        self.correctAnswerLabel.frame.size.width,
                                        66);

  [self.myTimeLabel sizeToFit];
  self.myTimeLabel.frame = CGRectMake(kLeftMargin,
                                      CGRectGetMaxY(self.myAnswerLabel.frame),
                                      self.myTimeLabel.frame.size.width,
                                      66);

  [self.avgTimeLabel sizeToFit];
  self.avgTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.myTimeLabel.frame) + kLeftMargin,
                                       CGRectGetMaxY(self.myAnswerLabel.frame),
                                       self.avgTimeLabel.frame.size.width,
                                       66);

  self.helpButton.frame = CGRectMake(0,
                                     self.view.frame.size.height - 66,
                                     self.view.frame.size.width,
                                     66);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button

- (void)backTapped {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper

- (void)updateLabels {
  self.difficultyLabel.text =
      [NSString stringWithFormat:@"%@ difficulty", self.question.dnaDifficulty];
  self.answeredLabel.text =
      [NSString stringWithFormat:@"%@ \t\t answered correctly", self.question.dnaPercentCorrect];
  self.numResponsesLabel.text =
      [NSString stringWithFormat:@"%@ \t\t user responses", self.question.dnaUsersResponsed];

  if (self.answerChoice >= 0) {
    char myAnswerChar = 'A' + self.answerChoice;
    self.myAnswerLabel.text = [NSString stringWithFormat:@"your answer\n%c", myAnswerChar];
  } else {
    self.myAnswerLabel.text = [NSString stringWithFormat:@"your answer\nN/A"];
  }

  char answerChar = 'A' + (self.question.questionAnswer - 1);
  self.correctAnswerLabel.text = [NSString stringWithFormat:@"correct answer\n%c", answerChar];

  int timeToAnswerSeconds = [self.timeSpentSeconds intValue];
  int minutes = floor(timeToAnswerSeconds / 60.0);
  int seconds = timeToAnswerSeconds - (minutes * 60);

  self.myTimeLabel.text =
      [NSString stringWithFormat:@"your time\n%i min %i sec", minutes, seconds];

  timeToAnswerSeconds = [self.question.dnaTimeToAnswer intValue];
  minutes = floor(timeToAnswerSeconds / 60.0);
  seconds = timeToAnswerSeconds - (minutes * 60);

  self.avgTimeLabel.text =
      [NSString stringWithFormat:@"average time\n%i min %i sec", minutes, seconds];
}

@end
