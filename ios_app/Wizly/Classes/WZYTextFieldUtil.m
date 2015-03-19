//
//  WZYTestFieldUtil.m
//  Wizly
//
//  Created by Bezhou Feng on 2/7/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYTextFieldUtil.h"

#import "WZYColors.h"

@implementation WZYInsetTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
  CGFloat padding = 10;
  return CGRectMake(bounds.origin.x + padding,
                    bounds.origin.y,
                    bounds.size.width - padding * 2,
                    bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return [self textRectForBounds:bounds];
}

@end

@implementation WZYTextFieldUtil

+ (UITextField *)defaultTextFieldWithPlaceholder:(NSString *)placeholder {
  WZYInsetTextField *textField = [[WZYInsetTextField alloc] init];
  textField.textColor = [UIColor whiteColor];
  textField.backgroundColor = [WZYColors mainButtonColor];
  textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
  NSAttributedString *attributedPlaceholder =
      [[NSAttributedString alloc] initWithString:placeholder
                                      attributes:@{ NSForegroundColorAttributeName :
                                                      [UIColor colorWithWhite:1.0 alpha:0.6]
                                                  }];
  textField.attributedPlaceholder = attributedPlaceholder;
  return textField;
}

@end
