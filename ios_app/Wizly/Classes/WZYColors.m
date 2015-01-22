//
//  WZYColors.m
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYColors.h"

@implementation WZYColors

#pragma mark - Values

+ (UIColor *)mainBackgroundColor {
  return [WZYColors colorFromHexString:@"#04053C"];
}

+ (UIColor *)mainButtonColor {
  return [WZYColors colorFromHexString:@"#00ACC1"];
}

#pragma mark - Helpers

+ (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                         green:((rgbValue & 0xFF00) >> 8)/255.0
                          blue:(rgbValue & 0xFF)/255.0
                         alpha:1.0];
}
@end
