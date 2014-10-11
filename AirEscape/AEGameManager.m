//
//  AEActorsManager.m
//  AirEscape
//
//  Created by Horatiu Istrate on 25/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEGameManager.h"
#import "PPConstants.h"
#import "NSObject+Additions.h"


static AEGameManager *sharedMyManager = nil;

@implementation AEGameManager

@synthesize straighFlightTexture        = _straighFlightTexture;
@synthesize leftFlightTexture           = _leftFlightTexture;
@synthesize rightFlightTexture          = _rightFlightTexture;
@synthesize mainAirplaneManevrability   = _mainAirplaneManevrability;
@synthesize mainAirplaneSpeed           = _mainAirplaneSpeed;
@synthesize missileManevrability        = _missileManevrability;
@synthesize missileSpeed                = _missileSpeed;
@synthesize missileAcceleration         = _missileAcceleration;
@synthesize mainAirplaneAcceleration    = _mainAirplaneAcceleration;


#pragma mark Singleton Methods


+ (AEGameManager *)sharedManager {
    static AEGameManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        [self setActorsDefaultProprietiesValues];
        self.currentScene = AESceneMenu;
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

- (void)updateMainAirplaneImages {
    
    NSMutableDictionary *_airplanesShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[self appDelegate] airplanePListPath]];
    
    NSArray *keyArray = [_airplanesShopItemsDictionary allKeys];
    
    for (NSString *key in keyArray) {
        
        NSMutableDictionary *currentDictionary = [_airplanesShopItemsDictionary valueForKey:key];
        
        if ([[currentDictionary valueForKey:@"isUsed"] boolValue]) {
            
            NSString *nameOfStraightFlyTexture  = [currentDictionary valueForKey:@"straightFlyImage"];
            NSString *nameOfLeftFlyTexture      = [currentDictionary valueForKey:@"leftFlyImage"];
            NSString *nameOfRightFlyTexture     = [currentDictionary valueForKey:@"rightFlyImage"];
            NSString *nameOfShadowTexture       = [currentDictionary valueForKey:@"shadow"];
            
            _straighFlightTexture   = [[[self appDelegate] atlas] textureNamed:nameOfStraightFlyTexture];
            _leftFlightTexture      = [[[self appDelegate] atlas] textureNamed:nameOfLeftFlyTexture];
            _rightFlightTexture     = [[[self appDelegate] atlas] textureNamed:nameOfRightFlyTexture];
            _shadowTexture          = [[[self appDelegate] atlas] textureNamed:nameOfShadowTexture];
            
            return;
        }
    }
}

@end
