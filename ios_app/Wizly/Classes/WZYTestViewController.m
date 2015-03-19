//
//  WZYTestViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/24/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYTestViewController.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYDNAVC.h"
#import "WZYLabelUtil.h"
#import "WZYPassageVC.h"
#import "WZYPracticeController.h"
#import "WZYQuestion.h"
#import "WZYResultsViewController.h"

static const CGFloat kLeftMargin = 16.0;

@interface WZYTestViewController ()<UIAlertViewDelegate, WZYPracticeDelegate>

@property(nonatomic) NSMutableArray *answerButtonArray;

@property(nonatomic) WZYPracticeController *practiceController;

@property(nonatomic) UIButton *extraInfoButton;
@property(nonatomic) UIButton *endTestButton;
@property(nonatomic) UIButton *pauseButton;
@property(nonatomic) UIButton *dnaButton;

@property(nonatomic) UILabel *questionNumLabel;
@property(nonatomic) UITextView *questionLabel;
@property(nonatomic) UILabel *timerLabel;
@property(nonatomic) WZYButton *prevButton;
@property(nonatomic) WZYButton *nextButton;

@property(nonatomic) UIScrollView *responseScrollView;

@property(nonatomic, assign) BOOL finishedTest;

@end

@implementation WZYTestViewController

- (id)initWithPracticeController:(WZYPracticeController *)practiceController {
  self = [super init];
  if (self) {
    _practiceController = practiceController;
    _practiceController.delegate = self;
    _finishedTest = practiceController.testFinished;
    _answerButtonArray = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.dnaButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.dnaButton setTitle:@"Question DNA" forState:UIControlStateNormal];
  [self.dnaButton setTitleColor:[WZYColors mainButtonColor] forState:UIControlStateNormal];
  [self.dnaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [self.dnaButton addTarget:self
                         action:@selector(dnaTapped)
               forControlEvents:UIControlEventTouchUpInside];
  self.dnaButton.alpha = 0;
  [self.view addSubview:self.dnaButton];

  self.endTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.endTestButton setTitle:@"End Test" forState:UIControlStateNormal];
  [self.endTestButton setTitleColor:[WZYColors mainButtonColor] forState:UIControlStateNormal];
  [self.endTestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [self.endTestButton addTarget:self
                         action:@selector(endButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.endTestButton];

  self.extraInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.extraInfoButton setTitle:@"Image" forState:UIControlStateNormal];
  [self.extraInfoButton setTitleColor:[WZYColors mainButtonColor] forState:UIControlStateNormal];
  [self.extraInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [self.extraInfoButton addTarget:self
                         action:@selector(extraInfoTapped)
               forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.extraInfoButton];

  self.questionNumLabel = [WZYLabelUtil boldLabelWithSize:16.0];
  self.questionNumLabel.text = @"Question: 1 / 40";
  [self.view addSubview:self.questionNumLabel];

  self.timerLabel = [WZYLabelUtil boldLabelWithSize:16.0];
  // Emulate a timer fire with the time elapsed in the practice controller in case we're starting
  // from an archived session.
  [self timerDidFire:self.practiceController.timeElapsed];
  [self.view addSubview:self.timerLabel];

  self.questionLabel = [[UITextView alloc] initWithFrame:CGRectZero];
  self.questionLabel.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.questionLabel.backgroundColor = [UIColor clearColor];
  self.questionLabel.editable = NO;
  self.questionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
  self.questionLabel.textColor = [UIColor whiteColor];
  self.questionLabel.text = @"Question text";
  [self.view addSubview:self.questionLabel];

  self.prevButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                               color:[WZYColors colorFromHexString:@"#9575CD"]];
  self.prevButton.text = @"prev";
  [self.prevButton addTarget:self action:@selector(prevTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.prevButton];

  self.nextButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                               color:[WZYColors mainButtonColor]];
  self.nextButton.text = @"next";
  [self.nextButton addTarget:self action:@selector(nextTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.nextButton];

  self.responseScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.responseScrollView];

  UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedRight)];
  swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:swipeRight];

  UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedLeft)];
  swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:swipeLeft];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  [self updateViewForQuestion:self.practiceController.currentQuestion];

  if (!self.practiceController.testFinished && !self.practiceController.testStarted) {
    [_practiceController start];
  } else if (self.practiceController.testFinished) {
    [self.endTestButton setTitle:@"Results" forState:UIControlStateNormal];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  //[_practiceController stop];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  CGSize viewSize = self.view.frame.size;

  self.endTestButton.frame = CGRectMake(viewSize.width - 100, 30, 100, 44);

  [self.extraInfoButton sizeToFit];
  self.extraInfoButton.frame = CGRectMake(kLeftMargin, 30, self.extraInfoButton.frame.size.width, 44);

  CGFloat dnaWidth = 120;
  self.dnaButton.frame = CGRectMake(round(viewSize.width / 2 - dnaWidth / 2),
                                    self.endTestButton.frame.origin.y,
                                    dnaWidth,
                                    44);
  self.dnaButton.alpha = (self.finishedTest) ? 1 : 0;

  [self.questionNumLabel sizeToFit];
  self.questionNumLabel.frame = CGRectMake(kLeftMargin,
                                           CGRectGetMaxY(self.endTestButton.frame) + 8,
                                           160,
                                           self.questionNumLabel.frame.size.height);

  [self.timerLabel sizeToFit];
  CGFloat timerWidth = self.timerLabel.frame.size.width;
  self.timerLabel.frame = CGRectMake(viewSize.width - timerWidth - kLeftMargin,
                                     self.questionNumLabel.frame.origin.y,
                                     timerWidth,
                                     self.timerLabel.frame.size.height);

  self.questionLabel.frame =
      CGRectMake(kLeftMargin,
                 CGRectGetMaxY(self.questionNumLabel.frame) + 8,
                 self.view.frame.size.width - kLeftMargin * 2,
                 round(viewSize.height / 2) - CGRectGetMaxY(self.questionNumLabel.frame));

  self.prevButton.frame = CGRectMake(0, viewSize.height - 66, floor(viewSize.width * 0.3), 66);
  self.nextButton.frame = CGRectMake(floor(viewSize.width * 0.3),
                                     viewSize.height - 66,
                                     floor(viewSize.width * 0.7),
                                     66);

  // Height available for each answer button.
  CGFloat spaceAvailable = self.nextButton.frame.origin.y - CGRectGetMaxY(self.questionLabel.frame);
  self.responseScrollView.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.questionLabel.frame),
                                             viewSize.width,
                                             spaceAvailable);

  CGFloat buttonSize;
  if (self.practiceController.currentQuestion.choicesAreImages) {
    buttonSize = 160;
  } else {
    buttonSize = 66.0;
  }

  CGFloat yOffset = 0;
  for (UIView *v in self.answerButtonArray) {
    v.frame = CGRectMake(0, yOffset, viewSize.width, buttonSize);
    yOffset += buttonSize + 4.0;
  }

  self.responseScrollView.contentSize = CGSizeMake(viewSize.width,
                                                   (buttonSize + 4) * self.answerButtonArray.count);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button

- (void)endButtonTapped {
  if (self.finishedTest) {
    [self showResults];
    return;
  }

  NSString *message = @"Please confirm you'd like to end this session.";
  if (![_practiceController hasAnsweredAllQuestions]) {
    message = @"You haven't answered all the questions on the test. Please confirm you'd like to "
                  @"end this session.";
  }
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Are you sure you're done?"
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:@"Return"
                                     otherButtonTitles:@"End Test", nil];
  [av show];
}


- (void)extraInfoTapped {
  NSString *imageName = self.practiceController.currentQuestion.questionImageName;
  if (imageName) {
    WZYPassageVC *passageVC = [[WZYPassageVC alloc] initWithImageName:imageName];
    [self presentViewController:passageVC animated:YES completion:nil];
  }
}

- (void)prevTapped {
  WZYQuestion *question = [_practiceController prev];
  if (question) {
    [self updateViewForQuestion:question];
  }
}

- (void)nextTapped {
  WZYQuestion *question = [_practiceController next];
  if (question) {
    [self updateViewForQuestion:question];
  }
}

- (void)dnaTapped {
  WZYQuestion *question = _practiceController.currentQuestion;
  NSNumber *myTime = _practiceController.questionTimeArray[_practiceController.currentIndex];
  int myChoice = [_practiceController.responses[_practiceController.currentIndex] intValue];
  WZYDNAVC *dnaVC = [[WZYDNAVC alloc] initWithQuestion:question
                                      timeSpentSeconds:myTime
                                          answerChoice:myChoice];
  [self presentViewController:dnaVC animated:YES completion:nil];
}

- (void)answerTapped:(WZYButton *)button {
  if (self.finishedTest) return;

  NSNumber *currentResponse = _practiceController.responses[_practiceController.currentIndex];

  // If we've already set an answer and we've tapped on the selected button, reset it.
  if ([currentResponse intValue] != -1 && [currentResponse intValue] == button.tag) {
    [_practiceController selectResponse:@-1];
    button.backgroundColor = [WZYColors cyanColor];
  } else {
    [_practiceController selectResponse:[NSNumber numberWithInteger:button.tag]];
  }

  int newAnswer = [_practiceController.responses[_practiceController.currentIndex] intValue];
  if (newAnswer == -1) return;

  // Loop through all the buttons and when we hit the one that matches the new answer, set it's
  // background color.
  int index = 0;
  for (WZYButton *b in self.answerButtonArray) {
    if (index == newAnswer) {
      b.backgroundColor = [WZYColors colorFromHexString:@"#03A9F4"];
    } else {
      b.backgroundColor = [WZYColors cyanColor];
    }
    index++;
  }
}

#pragma mark - Helper

- (void)updateViewForQuestion:(WZYQuestion *)question {
  if (_practiceController.currentIndex + 1 == _practiceController.questionArray.count) {
    self.nextButton.text = @"finish";
    [self.nextButton removeTarget:self
                           action:@selector(nextTapped)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self
                        action:@selector(endButtonTapped)
              forControlEvents:UIControlEventTouchUpInside];
  } else {
    self.nextButton.text = @"next";
    [self.nextButton removeTarget:self
                           action:@selector(endButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self
                        action:@selector(nextTapped)
              forControlEvents:UIControlEventTouchUpInside];
  }

  self.questionNumLabel.text = [NSString stringWithFormat:@"Question: %i / %i",
                             (int)_practiceController.currentIndex + 1,
                             (int)_practiceController.questionArray.count];

  // Fade in and out text when we switch questions.
  [UIView animateWithDuration:0.15 animations:^{
    self.questionLabel.alpha = 0.0;
  } completion:^(BOOL finished) {
    self.questionLabel.text = question.questionText;
    [UIView animateWithDuration:0.15 animations:^{
      self.questionLabel.alpha = 1.0;
    }];
  }];

  // Clear all current buttons and add new ones
  for (UIView *b in self.answerButtonArray) {
    [b removeFromSuperview];
  }

  self.answerButtonArray = [NSMutableArray array];
  char c = 'A';
  int tag = 0;
  for (NSString *choice in question.questionChoices) {
    WZYButton *button = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors cyanColor]];
    button.tag = tag;
    if (question.choicesAreImages) {
      button.text = [NSString stringWithFormat:@"%c", c];
      button.textLabel.textAlignment = NSTextAlignmentLeft;
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageNamed:choice];
        dispatch_async(dispatch_get_main_queue(), ^{
          button.image = image;
        });
      });
    } else {
      button.text = [NSString stringWithFormat:@"%c. %@", c, choice];
      button.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    [button addTarget:self
               action:@selector(answerTapped:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.responseScrollView addSubview:button];
    [self.answerButtonArray addObject:button];
    c++;
    tag++;
  }

  // If the user has already selected a response, select that button for them.
  if (_practiceController.responses.count) {
    NSNumber *currentResponse = _practiceController.responses[_practiceController.currentIndex];
    int intResponse = [currentResponse intValue];
    if (intResponse != -1) {
      // Label red or green if we've finished test. Otherwise, do the blue.
      UIColor *bgColor = [WZYColors colorFromHexString:@"#03A9F4"];
      if (self.finishedTest) {
        if (([currentResponse integerValue] + 1) == question.questionAnswer) {
          bgColor = [WZYColors colorFromHexString:@"#4CAF50"];
        } else {
          bgColor = [WZYColors colorFromHexString:@"#F44336"];
        }
      }
      [self.answerButtonArray[intResponse] setBackgroundColor:bgColor];
    }
  }

  // Hijack the timer label and put the correct response
  if (self.finishedTest) {
    char aChar = 'A';
    char correctAnswerChar = aChar + (question.questionAnswer - 1);
    self.timerLabel.text = [NSString stringWithFormat:@"Correct answer: %c", correctAnswerChar];
  }

  // Update the extra info button based on what it contains
  if (question.questionImageName) {
    [self.extraInfoButton setTitle:@"Image" forState:UIControlStateNormal];
    self.extraInfoButton.alpha = 1.0;
  } else {
    self.extraInfoButton.alpha = 0;
  }
  [self.view setNeedsLayout];
}

- (void)showResults {
  WZYResultsViewController *resultsVC =
      [[WZYResultsViewController alloc] initWithPracticeController:self.practiceController];
  [self.navigationController pushViewController:resultsVC animated:YES];
}

#pragma mark - WZYPracticeDelegate

- (void)timerDidFire:(NSTimeInterval)currentTime {
  double hours = floor(currentTime / 3600);
  double minutes = floor(currentTime / 60.0) - (hours * 60);
  double seconds = currentTime - (minutes * 60) - (hours * 3600);
  self.timerLabel.text = [NSString stringWithFormat:@"Time:\t%02.0f:%02.0f:%02.0f", hours, minutes, seconds];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [self.practiceController finishTest];
    _finishedTest = YES;
    [self showResults];
  }
}

#pragma mark - Swipe

- (void)userSwipedRight {
  [self prevTapped];
}

- (void)userSwipedLeft {
  [self nextTapped];
}

@end
