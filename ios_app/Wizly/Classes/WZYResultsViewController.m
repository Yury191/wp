//
//  WZYResultsViewController.m
//  Wizly
//
//  Created by Bezhou Feng on 1/31/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYResultsViewController.h"

#import "WZYButton.h"
#import "WZYColors.h"
#import "WZYLabelUtil.h"
#import "WZYPracticeController.h"
#import "WZYTestHistoryVC.h"

@interface WZYResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UIButton *doneButton;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *percentLabel;
@property(nonatomic) UILabel *accuracyLabel;
@property(nonatomic) UILabel *timeLabel;
@property(nonatomic) WZYButton *reviewButton;
@property(nonatomic, readonly) WZYPracticeController *practiceController;

@property(nonatomic) UITableView *tableView;

@end

@implementation WZYResultsViewController

- (id)initWithPracticeController:(WZYPracticeController *)practiceController {
  self = [super init];
  if (self) {
    _practiceController = practiceController;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
  [self.doneButton setTitleColor:[WZYColors mainButtonColor] forState:UIControlStateNormal];
  [self.doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [self.doneButton addTarget:self
                      action:@selector(doneTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.doneButton];

  self.titleLabel = [WZYLabelUtil boldLabelWithSize:32.0];
  self.titleLabel.text = @"Practice Complete";
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:self.titleLabel];

  self.percentLabel = [WZYLabelUtil boldLabelWithSize:44.0];
  self.percentLabel.text = @"85%";
  self.percentLabel.textAlignment = NSTextAlignmentCenter;
  self.percentLabel.textColor = [WZYColors colorFromHexString:@"#FFCA4F"];
  [self.view addSubview:self.percentLabel];

  self.accuracyLabel = [WZYLabelUtil defaultLabelWithSize:22.0];
  self.accuracyLabel.text = @"Answered\nCorrectly";
  self.accuracyLabel.numberOfLines = 2;
  [self.view addSubview:self.accuracyLabel];

  self.timeLabel = [WZYLabelUtil defaultLabelWithSize:18.0];
  self.timeLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:self.timeLabel];

  self.reviewButton = [[WZYButton alloc] initWithFrame:CGRectZero color:[WZYColors cyanColor]];
  self.reviewButton.text = @"review questions";
  [self.reviewButton addTarget:self
                        action:@selector(reviewTapped)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.reviewButton];

  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [WZYColors mainBackgroundColor];
  [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateViewForResults];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGSize viewSize = self.view.frame.size;

  self.doneButton.frame = CGRectMake(viewSize.width - 88, 30, 88, 44);

  [self.titleLabel sizeToFit];
  self.titleLabel.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.doneButton.frame),
                                     viewSize.width,
                                     self.titleLabel.frame.size.height);

  [self.percentLabel sizeToFit];
  CGFloat leftMargin = round(viewSize.width / 5);
  self.percentLabel.frame = CGRectMake(leftMargin,
                                       CGRectGetMaxY(self.titleLabel.frame) + 8.0,
                                       round(viewSize.width / 2.5),
                                       self.percentLabel.frame.size.height);

  self.accuracyLabel.frame = CGRectMake(CGRectGetMaxX(self.percentLabel.frame),
                                        self.percentLabel.frame.origin.y,
                                        self.percentLabel.frame.size.width,
                                        self.percentLabel.frame.size.height);

  self.timeLabel.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.percentLabel.frame) + 8.0,
                                    viewSize.width,
                                    44);

  self.reviewButton.frame = CGRectMake(0, viewSize.height - 66, viewSize.width, 66);

  self.tableView.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.timeLabel.frame),
                                    viewSize.width,
                                    self.reviewButton.frame.origin.y - CGRectGetMaxY(self.timeLabel.frame));
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button

- (void)doneTapped {
  // TODO: ugly hack to pop back to the test history instead of the dashboard
  for (UIViewController *vc in self.navigationController.viewControllers) {
    if ([vc isKindOfClass:[WZYTestHistoryVC class]]) {
      [self.navigationController popToViewController:vc animated:YES];
      return;
    }
  }
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)reviewTapped {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper

- (void)updateViewForResults {
  if (!self.practiceController) return;

  NSArray *questionsCorrectArray = [self.practiceController questionsAnsweredCorrectly];
  float percentCorrect =
      (float)questionsCorrectArray.count / (float)self.practiceController.questionArray.count;
  percentCorrect = percentCorrect * 100;
  self.percentLabel.text = [NSString stringWithFormat:@"%.0f%%", percentCorrect];

  self.timeLabel.text = [NSString stringWithFormat:@"Average time per question: %i seconds",
                         [self.practiceController averageTimePerQuestion]];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.practiceController.questionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"cellId";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:cellId];
    cell.backgroundColor = [WZYColors mainBackgroundColor];
    cell.textLabel.textColor = [UIColor whiteColor];
  }

  cell.textLabel.text = [NSString stringWithFormat:@"Question %i", (int)indexPath.row + 1];

  WZYQuestion *q = self.practiceController.questionArray[indexPath.row];
  if (q.questionAnswer == [self.practiceController.responses[indexPath.row] intValue] + 1) {
    cell.detailTextLabel.text = @"\u2713";
    cell.detailTextLabel.textColor = [UIColor greenColor];
  } else {
    cell.detailTextLabel.text = @"\u2717";
    cell.detailTextLabel.textColor = [UIColor redColor];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.practiceController skipToIndex:indexPath.row];
  [self.navigationController popViewControllerAnimated:YES];
}


@end
