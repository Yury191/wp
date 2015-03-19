//
//  WZYButton.m
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYButton.h"

static const CGFloat kImagePadding = 8;

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
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];

    _imageView = [[UIImageView alloc] init];
    _imageView.hidden = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
  }
  return self;
}

- (void)dealloc {
  _image = nil;
}

- (void)layoutSubviews {
  [self.textLabel sizeToFit];
  self.textLabel.frame = CGRectMake(16.0,
                                    0,
                                    self.frame.size.width - 32.0,
                                    self.frame.size.height);

  self.imageView.frame = CGRectMake(kImagePadding,
                                    kImagePadding,
                                    self.frame.size.width - kImagePadding * 2,
                                    self.frame.size.height - kImagePadding * 2);
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

- (void)setImage:(UIImage *)image {
  _image = image;
  if (image) {
    self.imageView.hidden = NO;
  } else {
    self.imageView.hidden = YES;
  }
  [self.imageView setImage:image];
  [self setNeedsLayout];
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  if (enabled) {
    self.alpha = 1.0;
  } else {
    self.alpha = 0.3;
  }
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

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  self.alpha = 1.0;
}

@end
