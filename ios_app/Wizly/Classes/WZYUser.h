//
//  WZYUser.h
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kParseFirstNameKey;
extern NSString *kParseLastNameKey;
extern NSString *kParseHSNameKey;
extern NSString *kParseHSYearKey;
extern NSString *kParsePhoneKey;

@interface WZYUser : NSObject

// Personal details
@property(nonatomic) NSString *firstName;
@property(nonatomic) NSString *lastName;
@property(nonatomic) NSString *email;
@property(nonatomic) NSString *phoneNumber;

@property(nonatomic) NSNumber *tutoringCredits;

@end
