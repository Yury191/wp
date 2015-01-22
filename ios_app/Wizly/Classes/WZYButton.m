//
//  WZYButton.m
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYButton.h"

@interface WZYButton ()
@end

@implementation WZYButton

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
  self = [super initWithFrame:frame];
  if (self) {
    self.color = color;

    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    [self addSubview:self.textLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [self.textLabel sizeToFit];
  CGSize labelSize = self.textLabel.frame.size;
  self.textLabel.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - labelSize.width / 2,
                                    CGRectGetHeight(self.frame) / 2 - labelSize.height / 2,
                                    labelSize.width,
                                    labelSize.height);
}

- (void)setColor:(UIColor *)color {
  _color = color;
  self.backgroundColor = color;
}

- (void)setText:(NSString *)text {
  _text = text;
  self.textLabel.text = text;
  [self setNeedsLayout];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  self.alpha = 0.5;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  self.alpha = 1.0;
}

@end
