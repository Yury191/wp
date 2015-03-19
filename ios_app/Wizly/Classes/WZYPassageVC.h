//
//  WZYPassageVC.h
//  Wizly
//
//  Created by Bezhou Feng on 2/15/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZYPassageVC : UIViewController

// To display just an image.
- (id)initWithImageName:(NSString *)imageName;

// To display a full passage.
- (id)initWithPassageText:(NSString *)passageText;

@end
