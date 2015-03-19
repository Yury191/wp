//
//  WZYPassageVC.m
//  Wizly
//
//  Created by Bezhou Feng on 2/15/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYPassageVC.h"

#import "WZYColors.h"

@interface WZYPassageVC ()
@property(nonatomic) UIButton *backButton;
@property(nonatomic) UIImage *image;
@property(nonatomic) UIImageView *imageView;
@end

@implementation WZYPassageVC

- (id)initWithImageName:(NSString *)imageName {
  self = [super init];
  if (self) {
    _image = [UIImage imageNamed:imageName];
  }
  return self;
}

- (id)initWithPassageText:(NSString *)passageText {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [WZYColors mainBackgroundColor];

  self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
  [self.backButton setTitleColor:[WZYColors mainButtonColor] forState:UIControlStateNormal];
  [self.backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [self.backButton addTarget:self
                      action:@selector(backTapped)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.backButton];

  if (self.image) {
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
  }
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.backButton.frame = CGRectMake(16, 32, 44, 44);
  self.imageView.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Button

- (void)backTapped {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
