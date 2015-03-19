//
//  WZYScoreCalculator.m
//  Wizly
//
//  Created by Bezhou Feng on 2/16/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "WZYScoreCalculator.h"

@implementation WZYScoreCalculator

+ (int)mathScoreForCorrect:(float)correct {
  NSDictionary *mathTable = @{
                               @1.00 : @800,
                               @0.98 : @800,
                               @0.96 : @770,
                               @0.94 : @750,
                               @0.93 : @730,
                               @0.91 : @710,
                               @0.89 : @700,
                               @0.87 : @690,
                               @0.85 : @680,
                               @0.83 : @670,
                               @0.81 : @660,
                               @0.80 : @660,
                               @0.78 : @650,
                               @0.76 : @640,
                               @0.74 : @630,
                               @0.72 : @620,
                               @0.70 : @610,
                               @0.69 : @600,
                               @0.67 : @590,
                               @0.65 : @580,
                               @0.63 : @570,
                               @0.61 : @560,
                               @0.59 : @550,
                               @0.57 : @540,
                               @0.56 : @540,
                               @0.54 : @530,
                               @0.52 : @520,
                               @0.50 : @510,
                               @0.48 : @500,
                               @0.46 : @490,
                               @0.44 : @490,
                               @0.43 : @480,
                               @0.41 : @470,
                               @0.39 : @460,
                               @0.37 : @450,
                               @0.35 : @450,
                               @0.33 : @440,
                               @0.31 : @430,
                               @0.30 : @420,
                               @0.28 : @410,
                               @0.26 : @400,
                               @0.24 : @390,
                               @0.22 : @380,
                               @0.20 : @370,
                               @0.19 : @360,
                               @0.17 : @350,
                               @0.15 : @340,
                               @0.13 : @330,
                               @0.11 : @310,
                               @0.09 : @300,
                               @0.07 : @290,
                               @0.06 : @270,
                               @0.04 : @250,
                               @0.02 : @240,
                               @0.00 : @220,
                               @-0.02 : @210,
                               @-0.04 : @200,
                               @-0.06 : @200,
                            };
  return [[[self class] closestNumberInDictionary:mathTable forFloat:correct] intValue];
}

+ (int)readingScoreForCorrect:(float)correct {

  NSDictionary *readingTable = @{
                                 @1.00 : @800,
                                 @0.99 : @800,
                                 @0.97 : @800,
                                 @0.96 : @790,
                                 @0.94 : @770,
                                 @0.93 : @750,
                                 @0.91 : @740,
                                 @0.90 : @720,
                                 @0.88 : @710,
                                 @0.87 : @700,
                                 @0.85 : @690,
                                 @0.84 : @680,
                                 @0.82 : @670,
                                 @0.81 : @660,
                                 @0.79 : @650,
                                 @0.78 : @650,
                                 @0.76 : @640,
                                 @0.75 : @630,
                                 @0.73 : @620,
                                 @0.72 : @620,
                                 @0.70 : @610,
                                 @0.69 : @600,
                                 @0.67 : @590,
                                 @0.66 : @590,
                                 @0.64 : @580,
                                 @0.63 : @570,
                                 @0.61 : @570,
                                 @0.60 : @560,
                                 @0.58 : @550,
                                 @0.57 : @550,
                                 @0.55 : @540,
                                 @0.54 : @540,
                                 @0.52 : @530,
                                 @0.51 : @520,
                                 @0.49 : @520,
                                 @0.48 : @510,
                                 @0.46 : @510,
                                 @0.45 : @500,
                                 @0.43 : @490,
                                 @0.42 : @490,
                                 @0.40 : @480,
                                 @0.39 : @470,
                                 @0.37 : @470,
                                 @0.36 : @460,
                                 @0.34 : @460,
                                 @0.33 : @450,
                                 @0.31 : @440,
                                 @0.30 : @440,
                                 @0.28 : @430,
                                 @0.27 : @420,
                                 @0.25 : @410,
                                 @0.24 : @400,
                                 @0.22 : @400,
                                 @0.21 : @390,
                                 @0.19 : @380,
                                 @0.18 : @380,
                                 @0.16 : @370,
                                 @0.15 : @360,
                                 @0.13 : @350,
                                 @0.12 : @340,
                                 @0.10 : @330,
                                 @0.09 : @320,
                                 @0.07 : @310,
                                 @0.06 : @300,
                                 @0.04 : @280,
                                 @0.03 : @270,
                                 @0.01 : @250,
                                 @0.00 : @230,
                                 @-0.01 : @210,
                                 @-0.03 : @200,
                                 @-0.04 : @200,
                                 };

  return [[[self class] closestNumberInDictionary:readingTable forFloat:correct] intValue];
}

+ (int)writingScoreForCorrect:(float)correct {
  NSDictionary *writingTable = @{
                                 @1 : @800,
                                 @0.9875 : @770,
                                 @0.975 : @740,
                                 @0.9625 : @720,
                                 @0.95 : @700,
                                 @0.9375 : @680,
                                 @0.925 : @670,
                                 @0.9125 : @650,
                                 @0.9 : @640,
                                 @0.8875 : @630,
                                 @0.875 : @620,
                                 @0.8625 : @610,
                                 @0.85 : @590,
                                 @0.8375 : @580,
                                 @0.825 : @570,
                                 @0.8125 : @560,
                                 @0.8 : @550,
                                 @0.7875 : @550,
                                 @0.775 : @540,
                                 @0.7625 : @530,
                                 @0.75 : @520,
                                 @0.7375 : @510,
                                 @0.725 : @500,
                                 @0.7125 : @490,
                                 @0.7 : @480,
                                 @0.6875 : @470,
                                 @0.675 : @470,
                                 @0.6625 : @460,
                                 @0.65 : @450,
                                 @0.6375 : @440,
                                 @0.625 : @430,
                                 @0.6125 : @420,
                                 @0.6 : @410,
                                 @0.5875 : @400,
                                 @0.575 : @390,
                                 @0.5625 : @380,
                                 @0.55 : @370,
                                 @0.5375 : @370,
                                 @0.525 : @360,
                                 @0.5125 : @350,
                                 @0.5 : @340,
                                 @0.4875 : @330,
                                 @0.475 : @320,
                                 @0.4625 : @310,
                                 @0.45 : @300,
                                 @0.4375 : @280,
                                 @0.425 : @270,
                                 @0.4125 : @250,
                                 @0.4 : @230,
                                 @0.3875 : @210,
                                 @0.375 : @200,
                                 @0.3625 : @200,
                                 @0.35 : @200,
                                 };
  return [[[self class] closestNumberInDictionary:writingTable forFloat:correct] intValue];
}

+ (NSNumber *)closestNumberInDictionary:(NSDictionary *)dict forFloat:(float)keyNumber {
  NSArray *keyArray = dict.allKeys;
  keyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];

  float candidateFloat = [keyArray[0] intValue];
  NSNumber *candidateNum = keyArray[0];
  // Find the closest key to our keynumber
  for (NSNumber *n in keyArray) {
    float next = [n floatValue];
    if (fabsf(keyNumber - next) < fabsf(keyNumber - candidateFloat)) {
      candidateFloat = next;
      candidateNum = n;
    }
  }
  return dict[candidateNum];
}

@end