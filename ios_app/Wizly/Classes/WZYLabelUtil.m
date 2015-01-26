//
//  WZYLabelUtil.m
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYLabelUtil.h"

@implementation WZYLabelUtil

+ (UILabel *)defaultLabelWithSize:(CGFloat)fontSize {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
  label.textColor = [UIColor whiteColor];
  return label;
}

+ (UILabel *)ultraLightLabelWithSize:(CGFloat)fontSize {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
  label.textColor = [UIColor whiteColor];
  return label;
}

+ (UILabel *)boldLabelWithSize:(CGFloat)fontSize {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
  label.textColor = [UIColor whiteColor];
  return label;
}

@end
