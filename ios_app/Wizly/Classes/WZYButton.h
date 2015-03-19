//
//  WZYButton.h
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZYButton : UIControl

@property(nonatomic) NSString *text;
@property(nonatomic) UIColor *color;
@property(nonatomic) UIImage *image;

/** Image displayed on button. Will display above any text. **/
@property(nonatomic, readonly) UIImageView *imageView;

/** Text displayed by the button. Default text color is white. **/
@property(nonatomic, readonly) UILabel *textLabel;

/** Designated initializer **/
- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end
