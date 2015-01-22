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

/** Text displayed by the button. Default text color is white. **/
@property(nonatomic, readonly) UILabel *textLabel;

/** Designated initializer **/
- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end
