//
//  WZYDashboardPerfView.m
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYDashboardPerfView.h"

#import "WZYColors.h"
#import "WZYLabelUtil.h"

const NSString *kPerfNumKey = @"kPerfNumKey";
const NSString *kPerfScoreKey = @"kPerfScoreKey";
const NSString *kMathScoreKey = @"kMathScoreKey";
const NSString *kReadingScoreKey = @"kReadingScoreKey";
const NSString *kWritingScoreKey = @"kWritingScoreKey";
const NSString *kScienceScoreKey = @"kScienceScoreKey";

static const CGFloat kSideMargin = 16.0;

@interface WZYDashboardPerfView ()
@property(nonatomic) NSDictionary *questionDict;

@property(nonatomic) UISegmentedControl *testControl;
@property(nonatomic) UILabel *questionsCompletedTitleLabel;
@property(nonatomic) UILabel *questionsCompletedNumberLabel;
@property(nonatomic) UILabel *scoreTitleLabel;
@property(nonatomic) UILabel *scoreNumberLabel;

@property(nonatomic) UILabel *mathLabel;
@property(nonatomic) UILabel *readingLabel;
@property(nonatomic) UILabel *writingLabel;
@property(nonatomic) UILabel *scienceLabel;

@property(nonatomic) UILabel *mathScoreLabel;
@property(nonatomic) UILabel *readScoreLabel;
@property(nonatomic) UILabel *writeScoreLabel;
@property(nonatomic) UILabel *scienceScoreLabel;

@property(nonatomic) WZYUser *user;

@end

@implementation WZYDashboardPerfView

- (id)initWithFrame:(CGRect)frame user:(WZYUser *)user {
  self = [super initWithFrame:frame];
  if (self) {
    _user = user;

    _testControl = [[UISegmentedControl alloc] initWithItems:@[@"SAT"]];
    _testControl.tintColor = [WZYColors mainButtonColor];
    _testControl.selectedSegmentIndex = 0;
    [self addSubview:_testControl];

    _questionsCompletedTitleLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _questionsCompletedTitleLabel.text = @"questions completed";
    [self addSubview:_questionsCompletedTitleLabel];

    _questionsCompletedNumberLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _questionsCompletedNumberLabel.text = @"n/a";
    [self addSubview:_questionsCompletedNumberLabel];

    _scoreTitleLabel = [WZYLabelUtil boldLabelWithSize:18.0];
    _scoreTitleLabel.text = @"Your score estimate";
    [self addSubview:_scoreTitleLabel];

    _scoreNumberLabel = [WZYLabelUtil defaultLabelWithSize:24.0];
    _scoreNumberLabel.text = @"n/a";
    [self addSubview:_scoreNumberLabel];

    // Subsection Titles ------------------------------------

    _mathLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _mathLabel.text = @"math";
    [self addSubview:_mathLabel];

    _readingLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _readingLabel.text = @"reading";
    [self addSubview:_readingLabel];

    _writingLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _writingLabel.text = @"writing";
    [self addSubview:_writingLabel];

    _scienceLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _scienceLabel.text = @"science";
    _scienceLabel.hidden = YES;
    [self addSubview:_scienceLabel];

    // Subsection Numbers -----------------------------------

    _mathScoreLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _mathScoreLabel.text = @"n/a";
    [self addSubview:_mathScoreLabel];

    _readScoreLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _readScoreLabel.text = @"n/a";
    [self addSubview:_readScoreLabel];

    _writeScoreLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _writeScoreLabel.text = @"n/a";
    [self addSubview:_writeScoreLabel];

    _scienceScoreLabel = [WZYLabelUtil defaultLabelWithSize:16.0];
    _scienceScoreLabel.text = @"n/a";
    _scienceScoreLabel.hidden = YES;
    [self addSubview:_scienceScoreLabel];
  }
  return self;
}

- (void)layoutSubviews {
  CGSize segmentSize = self.testControl.frame.size;
  self.testControl.frame = CGRectMake(round(self.frame.size.width / 2 - segmentSize.width / 2),
                                      0,
                                      round(self.frame.size.width * 0.8),
                                      segmentSize.height);

  [self.questionsCompletedTitleLabel sizeToFit];
  self.questionsCompletedTitleLabel.frame =
      CGRectMake(kSideMargin,
                 CGRectGetMaxY(self.testControl.frame) + 16.0,
                 self.questionsCompletedTitleLabel.frame.size.width,
                 self.questionsCompletedTitleLabel.frame.size.height);

  [self.questionsCompletedNumberLabel sizeToFit];
  self.questionsCompletedNumberLabel.frame =
      CGRectMake(self.frame.size.width - self.questionsCompletedNumberLabel.frame.size.width - kSideMargin,
                 self.questionsCompletedTitleLabel.frame.origin.y,
                 self.questionsCompletedNumberLabel.frame.size.width,
                 self.questionsCompletedNumberLabel.frame.size.height);

  // Score ---------------------

  [self.scoreTitleLabel sizeToFit];
  self.scoreTitleLabel.frame = CGRectMake(kSideMargin,
                                          CGRectGetMaxY(self.questionsCompletedTitleLabel.frame) + 8.0,
                                          self.scoreTitleLabel.frame.size.width,
                                          self.scoreTitleLabel.frame.size.height);
  [self addSubview:self.scoreTitleLabel];

  [self.scoreNumberLabel sizeToFit];
  self.scoreNumberLabel.frame =
      CGRectMake(self.frame.size.width - self.scoreNumberLabel.frame.size.width - kSideMargin,
                 self.scoreTitleLabel.frame.origin.y,
                 self.scoreNumberLabel.frame.size.width,
                 self.scoreNumberLabel.frame.size.height);

  // Break down ------------------

  [self.mathLabel sizeToFit];
  self.mathLabel.frame = CGRectMake(kSideMargin * 2,
                                    CGRectGetMaxY(self.scoreNumberLabel.frame) + 8.0,
                                    self.mathLabel.frame.size.width,
                                    self.mathLabel.frame.size.height);
  [self addSubview:self.mathLabel];

  [self.mathScoreLabel sizeToFit];
  self.mathScoreLabel.frame =
  CGRectMake(self.frame.size.width - self.mathScoreLabel.frame.size.width - kSideMargin,
             self.mathLabel.frame.origin.y,
             self.mathScoreLabel.frame.size.width,
             self.mathScoreLabel.frame.size.height);

  [self.readingLabel sizeToFit];
  self.readingLabel.frame = CGRectMake(kSideMargin * 2,
                                       CGRectGetMaxY(self.mathLabel.frame) + 8.0,
                                       self.readingLabel.frame.size.width,
                                       self.readingLabel.frame.size.height);
  [self addSubview:self.readingLabel];

  [self.readScoreLabel sizeToFit];
  self.readScoreLabel.frame =
      CGRectMake(self.frame.size.width - self.readScoreLabel.frame.size.width - kSideMargin,
                 self.readingLabel.frame.origin.y,
                 self.readScoreLabel.frame.size.width,
                 self.readScoreLabel.frame.size.height);

  [self.writingLabel sizeToFit];
  self.writingLabel.frame = CGRectMake(kSideMargin * 2,
                                       CGRectGetMaxY(self.readingLabel.frame) + 8.0,
                                       self.writingLabel.frame.size.width,
                                       self.writingLabel.frame.size.height);
  [self addSubview:self.writingLabel];

  [self.writeScoreLabel sizeToFit];
  self.writeScoreLabel.frame =
      CGRectMake(self.frame.size.width - self.writeScoreLabel.frame.size.width - kSideMargin,
                 self.writingLabel.frame.origin.y,
                 self.writeScoreLabel.frame.size.width,
                 self.writeScoreLabel.frame.size.height);

  [self.scienceLabel sizeToFit];
  self.scienceLabel.frame = CGRectMake(kSideMargin * 2,
                                       CGRectGetMaxY(self.writingLabel.frame) + 8.0,
                                       self.scienceLabel.frame.size.width,
                                       self.scienceLabel.frame.size.height);
  [self addSubview:self.scienceLabel];

  [self.scienceScoreLabel sizeToFit];
  self.scienceScoreLabel.frame =
  CGRectMake(self.frame.size.width - self.scienceScoreLabel.frame.size.width - kSideMargin,
             self.scienceLabel.frame.origin.y,
             self.scienceScoreLabel.frame.size.width,
             self.scienceScoreLabel.frame.size.height);
}

#pragma mark - Public

- (void)updateWithQuestionDict:(NSDictionary *)questionDict {
  self.questionDict = questionDict;

  NSString *dictKey;
  switch (self.testControl.selectedSegmentIndex) {
    // SAT
    case 0: {
      dictKey = @"kSatKey";
      break;
    }
    // ACT
    case 1:
      dictKey = @"kActKey";
      break;
    default:
      dictKey = @"";
      break;
  }

  NSDictionary *dict = questionDict[dictKey];

  self.questionsCompletedNumberLabel.text =
      [NSString stringWithFormat:@"%i", [dict[kPerfNumKey] intValue]];
  
  [self updateLabel:self.scoreNumberLabel withScore:[dict[kPerfScoreKey] intValue]];
  [self updateLabel:self.mathScoreLabel withScore:[dict[kMathScoreKey] intValue]];
  [self updateLabel:self.readScoreLabel withScore:[dict[kReadingScoreKey] intValue]];
  [self updateLabel:self.writeScoreLabel withScore:[dict[kWritingScoreKey] intValue]];
  [self updateLabel:self.scienceScoreLabel withScore:[dict[kScienceScoreKey] intValue]];

  if ([dict[kMathScoreKey] intValue] < 0) {

  }

  [self setNeedsLayout];
}

- (void)updateLabel:(UILabel *)label withScore:(int)score {
  if (score >= 0) {
    label.text = [NSString stringWithFormat:@"%i", score];
  } else {
    if (label == self.scoreNumberLabel) {
      label.text = @"n/a";
    } else {
      label.text = @"pending";
    }
  }
}

@end
