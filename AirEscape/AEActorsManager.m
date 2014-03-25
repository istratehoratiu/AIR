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

#pragma mark Singleton Methods


+ (id)sharedManager {
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
}

@end
