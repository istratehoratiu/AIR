//
//  PPConstants.h
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 08/02/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

// Shop
typedef enum {
    AEShopItemBuyRockets,
    AEShopItemBuyLowRocket,
    AEShopItemBuyMediumRocket,
    AEShopItemBuyHighRocket,
    AEShopItemBuyLowSmoke,
    AEShopItemBuyMediumSmoke,
    AEShopItemBuyHighSmoke,
    AEShopItemBuyLowAirplane,
    AEShopItemBuyMediumAirplane,
    AEShopItemBuyHighAirplane
} AEShopItem;

// Gameplay
static const CGFloat kAEMainAirplaneManevrability    = 1.5;
static const CGFloat kAEMaxMainAirplaneManevrability = 3.5;

static const CGFloat kAEMissileManevrability        = 2;
static const CGFloat kAEMaxMissileManevrability     = 3;

static const CGFloat kAEMainAirplaneSpeed           = 200;
static const CGFloat kAEMaxMainAirplaneSpeed        = 375;

static const CGFloat kAEMissileSpeed                = 250;
static const CGFloat kAEMaxMissileSpeed             = 425;

static const CGFloat kAEMissileAcceleration         = 75;
static const CGFloat kAEMainAirplaneAcceleration    = 75;

static const CGFloat kAEMinimumMissileSpeed         = 100;
static const CGFloat kAEMinimumMainAirplaneSpeed    = 100;

static const CGFloat kAEMissileHaywireSpeed         = 400;
static const CGFloat kAEMissileHaywireManevrability = 0.4;

#define kAEParllaxDeviationValue        80

static const NSUInteger userAirplaneCategory              =  4;
static const NSUInteger missileCategory                   =  5;
static const NSUInteger enemyMissileCategory              =  7;

typedef enum {
    kPPTurnLeft,
    kPPTurnRight,
    kPPFlyStraight
} PPFlightDirection;

extern NSString *const kSGBestScoreKey;