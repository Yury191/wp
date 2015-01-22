//
//  WZYUser.h
//  Wizly
//
//  Created by Bezhou Feng on 1/19/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import <Foundation/Foundation.h>

// SAT dictionary keys
const NSString *kSATMathKey = @"kSATMathKey";
const NSString *kSATVerbalKey = @"kSATVerbalKey";
const NSString *kSATWritingKey = @"kSATWritingKey";

@interface WZYUser : NSObject

// Personal details
@property(nonatomic) NSString *firstName;
@property(nonatomic) NSString *lastName;
@property(nonatomic) NSString *email;
@property(nonatomic) NSString *phoneNumber;

@property(nonatomic) NSNumber *tutoringCredits;

/** Returns an NSDictionary of NSNumbers keyed to the SAT section **/
- (NSDictionary *)satScoreEstimate;

/** Returns an NSDictionary of NSNumbers keyed to the ACT section **/
- (NSDictionary *)actScoreEstimate;

@end
