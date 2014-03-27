//
//  AEActorsManager.h
//  AirEscape
//
//  Created by Horatiu Istrate on 25/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AEActorsManager : NSObject {

    CGFloat _missileSpeed;
    CGFloat _missileManevrability;
    CGFloat _mainAirplaneSpeed;
    CGFloat _mainAirplaneManevrability;
}

@property (nonatomic, assign) CGFloat missileSpeed;
@property (nonatomic, assign) CGFloat missileManevrability;
@property (nonatomic, assign) CGFloat mainAirplaneSpeed;
@property (nonatomic, assign) CGFloat mainAirplaneManevrability;

+ (AEActorsManager *)sharedManager;
- (void)setActorsDefaultProprietiesValues;

@end
