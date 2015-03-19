//
//  WZYDashboardViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYDashboardViewController.h"

#import <Parse/Parse.h>

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYContactVC.h"
#import "WZYDashboardPerfView.h"
#import "WZYLabelUtil.h"
#import "WZYScoreCalculator.h"
#import "WZYTestConfigVC.h"
#import "WZYTestHistoryVC.h"
#import "WZYTestSelectionController.h"
#import "WZYTestSession.h"
#import "WZYQuestionStore.h"

static const CGFloat kMarginTop = 36;

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
  self.settingsButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
  //[self.settingsButton setTitle:@"\u2699" forState:UIControlStateNormal];
  [self.settingsButton setTitle:@"sign out" forState:UIControlStateNormal];
  [self.settingsButton setTitleColor:[WZYColors mainButtonColor] forState:UIControlStateNormal];
  [self.settingsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [self.settingsButton addTarget:self
                          action:@selector(settingsTapped)
                forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.settingsButton];

  self.greetingLabel = [WZYLabelUtil defaultLabelWithSize:18.0];
  self.greetingLabel.text = [self welcomeMessageWithDate];
  //[self.view addSubview:self.greetingLabel];

  self.titleLabel = [WZYLabelUtil defaultLabelWithSize:40.0];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.text = @"Your Progress";
  [self.view addSubview:self.titleLabel];

  self.performanceView = [[WZYDashboardPerfView alloc] initWithFrame:CGRectZero user:nil];
  [self.view addSubview:self.performanceView];

  self.lessonButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                                 color:[WZYColors cyanColor]];
  self.lessonButton.text = @"free lesson";
  [self.lessonButton addTarget:self
                        action:@selector(lessonTapped)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.lessonButton];

  self.practiceButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                                 color:[WZYColors mainButtonColor]];
  self.practiceButton.text = @"practice";
  [self.practiceButton addTarget:self
                          action:@selector(practiceTapped)
                forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.practiceButton];

  self.reviewButton = [[WZYButton alloc] initWithFrame:CGRectZero
                                                 color:[WZYColors purpleColor]];
  self.reviewButton.text = @"review past questions";
  [self.reviewButton addTarget:self
                          action:@selector(reviewTapped)
                forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.reviewButton];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
  self.navigationController.navigationBar.tintColor = [WZYColors mainButtonColor];
  [self calculatePerformance];
}

- (void)calculatePerformance {
  // calculate the score and pass it to our perf view
  __weak __typeof(self) weakSelf = self;

  PFQuery * query = [PFQuery queryWithClassName:kSessionClassName];
  [query fromLocalDatastore];
  [query orderByDescending:kSessionDateKey];
  [query whereKey:kSessionUserKey equalTo:[PFUser currentUser]];
  // Limit the number of sessions we consider to the previous 10
  query.limit = 10;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (error) {
      NSLog(@"error getting sessions: %@", error);
    } else {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *satDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *actDict = [NSMutableDictionary dictionary];

        NSDictionary *questionDict = [WZYQuestionStore sharedStore].questionDict;

        // Split SAT and ACT questions out into two arrays
        NSMutableArray *satMathArray = [NSMutableArray array];
        NSMutableArray *satReadingArray = [NSMutableArray array];
        NSMutableArray *satWritingArray = [NSMutableArray array];

        NSMutableArray *actMathArray = [NSMutableArray array];
        NSMutableArray *actReadingArray = [NSMutableArray array];
        NSMutableArray *actWritingArray = [NSMutableArray array];
        NSMutableArray *actScienceArray = [NSMutableArray array];

        // Search through every question asked in every test taken
        // TODO: Find a much less hacky way of doing this.
        int satMathCorrect = 0;
        int satReadingCorrect = 0;
        int satWritingCorrect = 0;
        int actMathCorrect = 0;
        int actReadingCorrect = 0;
        int actWritingCorrect = 0;
        int actScienceCorrect = 0;
        for (PFObject *session in objects) {
          NSDictionary *sessionDictionary = session[kSessionAskedKey];
          NSArray *sessionQuestions = sessionDictionary.allKeys;
          for (NSString *qId in sessionQuestions) {
            WZYQuestion *q = questionDict[qId];

            // Add one to the response because we store responses 0-indexed on the backend.
            int response = [sessionDictionary[qId] intValue] + 1;
            BOOL correct = response == q.questionAnswer;

            // Bucket the question into the appropriate array
            if (q.isSAT) {
              switch (q.questionType) {
                case WZYQuestionTypeMath: {
                  [satMathArray addObject:q];
                  if (correct) satMathCorrect++;
                  break;
                }
                case WZYQuestionTypeReading: {
                  [satReadingArray addObject:q];
                  if (correct) satReadingCorrect++;
                  break;
                }
                case WZYQuestionTypeWriting: {
                  [satWritingArray addObject:q];
                  if (correct) satWritingCorrect++;
                  break;
                }
                default:
                  NSLog(@"Warning: unrecognized SAT question type");
                  break;
              }
            } else {
              switch (q.questionType) {
                case WZYQuestionTypeMath: {
                  [actMathArray addObject:q];
                  if (correct) actMathCorrect++;
                  break;
                }
                case WZYQuestionTypeReading: {
                  [actReadingArray addObject:q];
                  if (correct) actReadingCorrect++;
                  break;
                }
                case WZYQuestionTypeWriting: {
                  [actWritingArray addObject:q];
                  if (correct) actWritingCorrect++;
                  break;
                }
                case WZYQuestionTypeScience: {
                  [actScienceArray addObject:q];
                  if (correct) actScienceCorrect++;
                }
                default:
                  NSLog(@"Warning: unrecognized ACT question type");
                  break;
              }
            }
          }
        }

        // Score calculations for SAT
        int satNumAsked = (int)satMathArray.count + (int)satReadingArray.count + (int)satWritingArray.count;

        float satMathAccuracy = -1;
        int satMathScore = -1;
        if (satMathArray.count >= 10) {
          satMathAccuracy = (float)satMathCorrect / (float)satMathArray.count;
          satMathScore = [WZYScoreCalculator mathScoreForCorrect:satMathAccuracy];
        }

        float satReadAccuracy = -1;
        int satReadScore = -1;
        if (satReadingArray.count >= 10) {
          satReadAccuracy = (float)satReadingCorrect / (float)satReadingArray.count;
          satReadScore = [WZYScoreCalculator readingScoreForCorrect:satReadAccuracy];
        }

        float satWriteAccuracy = -1;
        int satWriteScore = -1;
        if (satWritingArray.count >= 10) {
          satWriteAccuracy = (float)satReadingCorrect / (float)satWritingArray.count;
          satWriteScore = [WZYScoreCalculator writingScoreForCorrect:satWriteAccuracy];
        }

        // Make sure we have enough data for every single section.
        int satTotalScore = -1;
        if (satMathScore >= 0 && satReadScore >= 0 && satWriteScore >= 0) {
          satTotalScore = satMathScore + satReadScore + satWriteScore;
        }

        // Score calculations for ACT
        int actNumAsked = (int)actMathArray.count + (int)actReadingArray.count + (int)actWritingArray.count + (int)actScienceArray.count;
        int actMathScore = -1;
        int actReadScore = -1;
        int actWriteScore = -1;
        int actScienceScore = -1;
        int actTotalScore = -1;

        // Accumulate all data
        satDict[kPerfNumKey] = [NSNumber numberWithInteger:satNumAsked];
        satDict[kPerfScoreKey] = [NSNumber numberWithInteger:satTotalScore];
        satDict[kPerfScoreKey] =
            [NSNumber numberWithInteger:(satMathScore + satReadScore + satWriteScore)];
        satDict[kMathScoreKey] = [NSNumber numberWithInteger:satMathScore];
        satDict[kReadingScoreKey] = [NSNumber numberWithInteger:satReadScore];
        satDict[kWritingScoreKey] = [NSNumber numberWithInteger:satWriteScore];

        actDict[kPerfNumKey] = [NSNumber numberWithInteger:actNumAsked];
        actDict[kPerfScoreKey] = [NSNumber numberWithInteger:actTotalScore];
        actDict[kMathScoreKey] = [NSNumber numberWithInteger:actMathScore];
        actDict[kReadingScoreKey] = [NSNumber numberWithInteger:actReadScore];
        actDict[kWritingScoreKey] = [NSNumber numberWithInteger:actWriteScore];
        actDict[kScienceScoreKey] = [NSNumber numberWithInteger:actScienceScore];
        
        // Calculate scores for ACT
        NSMutableDictionary *perfDict = [NSMutableDictionary dictionary];
        perfDict[@"kSatKey"] = satDict;
        perfDict[@"kActKey"] = actDict;

        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.performanceView updateWithQuestionDict:perfDict];
        });
      });
    }
  }];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  CGSize viewSize = self.view.frame.size;

  self.settingsButton.frame = CGRectMake(8, 20, 66, 44);

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
                                          CGRectGetMaxY(self.titleLabel.frame) + 8.0,
                                          viewSize.width,
                                          round(self.view.frame.size.height / 2.5));

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

- (void)settingsTapped {
  // TODO: is it safe to call this on the main thread?
  [PFUser logOut];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)lessonTapped {
  WZYContactVC *contactVC = [[WZYContactVC alloc] init];
  [self presentViewController:contactVC animated:YES completion:nil];
}

- (void)practiceTapped {
  //WZYTestSelectionController *testVC = [[WZYTestSelectionController alloc] init];
  WZYTestConfigVC *testVC = [[WZYTestConfigVC alloc] init];
  testVC.testType = WZYTestSAT;
  [self.navigationController pushViewController:testVC animated:YES];
}

- (void)reviewTapped {
  WZYTestHistoryVC *historyVC = [[WZYTestHistoryVC alloc] init];
  [self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark - Helpers

- (NSString *)welcomeMessageWithDate {
  NSString *welcomeString;
  PFUser *user = [PFUser currentUser];
  NSString *name = user[kParseFirstNameKey];

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
