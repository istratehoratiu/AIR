//
//  AEActorsManager.h
//  AirEscape
//
//  Created by Horatiu Istrate on 25/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "PPConstants.h"


@interface AEGameManager : NSObject {

    CGFloat _missileSpeed;
    CGFloat _missileManevrability;
    CGFloat _missileAcceleration;
    
    CGFloat _mainAirplaneSpeed;
    CGFloat _mainAirplaneManevrability;
    CGFloat _mainAirplaneAcceleration;
    
}

@property (nonatomic, assign) AEScene currentScene;

@property (nonatomic, retain) SKTexture *straighFlightTexture;
@property (nonatomic, retain) SKTexture *leftFlightTexture;
@property (nonatomic, retain) SKTexture *rightFlightTexture;
@property (nonatomic, retain) SKTexture *shadowTexture;

@property (nonatomic, assign) CGFloat mainAirplaneAcceleration;
@property (nonatomic, assign) CGFloat missileAcceleration;
@property (nonatomic, assign) CGFloat missileSpeed;
@property (nonatomic, assign) CGFloat missileManevrability;
@property (nonatomic, assign) CGFloat mainAirplaneSpeed;
@property (nonatomic, assign) CGFloat mainAirplaneManevrability;

+ (AEGameManager *)sharedManager;
- (void)setActorsDefaultProprietiesValues;
- (CGFloat)getMainAirplaneSpeed;
- (CGFloat)getMissileSpeed;
- (void)updateMainAirplaneImages;


@end
