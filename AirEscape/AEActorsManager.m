//
//  AEActorsManager.m
//  AirEscape
//
//  Created by Horatiu Istrate on 25/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEActorsManager.h"
#import "PPConstants.h"


static AEActorsManager *sharedMyManager = nil;

@implementation AEActorsManager

@synthesize mainAirplaneManevrability   = _mainAirplaneManevrability;
@synthesize mainAirplaneSpeed           = _mainAirplaneSpeed;
@synthesize missileManevrability        = _missileManevrability;
@synthesize missileSpeed                = _missileSpeed;
@synthesize missileAcceleration         = _missileAcceleration;
@synthesize mainAirplaneAcceleration    = _mainAirplaneAcceleration;


#pragma mark Singleton Methods


+ (AEActorsManager *)sharedManager {
    static AEActorsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        [self setActorsDefaultProprietiesValues];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void)setActorsDefaultProprietiesValues {
    _mainAirplaneManevrability  = kAEMainAirplaneManevrability;
    _mainAirplaneSpeed          = kAEMainAirplaneSpeed;
    _missileManevrability       = kAEMissileManevrability;
    _missileSpeed               = kAEMissileSpeed;
    _mainAirplaneAcceleration   = 0.0;
    _missileAcceleration        = 0.0;
}

- (CGFloat)getMainAirplaneSpeed {
    _mainAirplaneSpeed += _mainAirplaneAcceleration;
    
    if (_mainAirplaneSpeed > kAEMaxMainAirplaneSpeed) {
        _mainAirplaneSpeed = kAEMaxMainAirplaneSpeed;
    } else if (_mainAirplaneSpeed < kAEMainAirplaneSpeed) {
        _mainAirplaneSpeed = kAEMainAirplaneSpeed;
    }
    
    return _mainAirplaneSpeed;
}

- (CGFloat)getMissileSpeed {
    _missileSpeed += _missileAcceleration;
    
    if (_missileSpeed > kAEMaxMissileSpeed) {
        _missileSpeed = kAEMaxMissileSpeed;
    } else if (_missileSpeed < kAEMissileSpeed) {
        _missileSpeed = kAEMissileSpeed;
    }
    
    return _missileSpeed;
}

- (void)setMainAirplaneManevrability:(CGFloat)mainAirplaneManevrability {
    if (mainAirplaneManevrability > kAEMaxMainAirplaneManevrability) {
        _mainAirplaneManevrability = kAEMaxMainAirplaneManevrability;
    } else if (mainAirplaneManevrability < kAEMainAirplaneManevrability) {
        _mainAirplaneManevrability = kAEMainAirplaneManevrability;
    } else {
        _mainAirplaneManevrability = mainAirplaneManevrability;
    }
}

- (void)setMissileManevrability:(CGFloat)missileManevrability {
    if (_missileManevrability > kAEMaxMissileManevrability) {
        _missileManevrability = kAEMaxMissileManevrability;
    } else if (_missileManevrability < kAEMissileManevrability) {
        _missileManevrability = kAEMissileManevrability;
    } else {
        _missileManevrability = missileManevrability;
    }
}

@end
