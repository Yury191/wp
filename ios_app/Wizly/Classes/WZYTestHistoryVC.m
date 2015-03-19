//
//  WZYTestHistoryVC.m
//  Wizly
//
//  Created by Bezhou Feng on 2/14/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYTestHistoryVC.h"

#import <Parse/Parse.h>

#import "WZYColors.h"
#import "WZYNavController.h"
#import "WZYPracticeController.h"
#import "WZYTestSession.h"
#import "WZYTestViewController.h"

@interface WZYTestHistoryVC ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) UITableView *tableView;
@property(nonatomic) NSArray *sessionArray;
@property(nonatomic) NSMutableDictionary *sessionGroupDict;
@property(nonatomic) NSMutableArray *orderedSessionDates;
@property(nonatomic) NSDateFormatter *dateFormatter;
@property(nonatomic) NSDateFormatter *headerFormatter;
@end

@implementation WZYTestHistoryVC

- (id)init {
  self = [super init];
  if (self) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [_dateFormatter setDateFormat:@"h:mm a"];
    _headerFormatter = [[NSDateFormatter alloc] init];
    [_headerFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [_headerFormatter setDateFormat:@"MMMM dd, YYYY"];
    _sessionGroupDict = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [WZYColors colorFromHexString:@"#E8EAF6"];
  [self.view addSubview:self.tableView];

  [self retrieveTestSessionsFromLocal];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO];
  self.navigationController.navigationBar.tintColor = [WZYColors purpleColor];
}

#pragma mark - Helper

- (void)retrieveTestSessionsFromLocal {
  PFQuery * query = [PFQuery queryWithClassName:kSessionClassName];
  [query fromLocalDatastore];
  [query orderByDescending:kSessionDateKey];
  [query whereKey:kSessionUserKey equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (error) {
      NSLog(@"error getting sessions: %@", error);
    } else {
      self.sessionArray = objects;
      [self uniqueDatesFromSessions];
      [self.tableView reloadData];
      [self retrieveTestSessionsFromRemote];
    }
  }];
}

// This method also pins all retrieved sessions to our local datastore.
- (void)retrieveTestSessionsFromRemote {
  PFQuery * query = [PFQuery queryWithClassName:kSessionClassName];
  [query orderByDescending:kSessionDateKey];
  [query whereKey:kSessionUserKey equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (error) {
      NSLog(@"error getting sessions: %@", error);
    } else {
      // TODO: figure out a better way to merge
      if (objects.count != self.sessionArray.count) {
        self.sessionArray = objects;
        [PFObject pinAllInBackground:objects];
        [self uniqueDatesFromSessions];
        [self.tableView reloadData];
      }
    }
  }];
}

- (void)uniqueDatesFromSessions {
  self.orderedSessionDates = [NSMutableArray array];
  // For every session in the history, extract just the date and not the time. Use those dates
  // as keys for a dictionary which we then use to group the sessions by in the table.
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  for (PFObject *session in self.sessionArray) {
    NSDate *date = session[kSessionDateKey];
    NSDateComponents *components = [calendar components:flags fromDate:date];
    date = [calendar dateFromComponents:components];
    if (self.sessionGroupDict[date]) {
      NSMutableArray *sessionArray = self.sessionGroupDict[date];
      [sessionArray addObject:session];
      self.sessionGroupDict[date] = sessionArray;
    } else {
      self.sessionGroupDict[date] = [@[session] mutableCopy];
      [self.orderedSessionDates addObject:date];
    }
  }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.orderedSessionDates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSDate *key = self.orderedSessionDates[section];
  return [self.sessionGroupDict[key] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSDate *key = self.orderedSessionDates[section];
  return [_headerFormatter stringFromDate:key];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"cellId";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:cellId];
    cell.backgroundColor = [WZYColors colorFromHexString:@"#E8EAF6"];
    cell.detailTextLabel.textColor = [WZYColors purpleColor];
  }

  NSDate *key = self.orderedSessionDates[indexPath.section];
  PFObject *session = [self.sessionGroupDict[key] objectAtIndex:indexPath.row];

  cell.textLabel.text = [NSString stringWithFormat:@"%@",
                            [self.dateFormatter stringFromDate:session[kSessionDateKey]]];
  int scorePercent = [session[kSessionScoreKey] floatValue] * 100;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%i%%", scorePercent];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSDate *key = self.orderedSessionDates[indexPath.section];
  PFObject *session = [self.sessionGroupDict[key] objectAtIndex:indexPath.row];
  WZYPracticeController *practice = [[WZYPracticeController alloc] initWithSession:session];
  WZYTestViewController *testVC =
      [[WZYTestViewController alloc] initWithPracticeController:practice];
  [self.navigationController pushViewController:testVC animated:YES];
}

@end
