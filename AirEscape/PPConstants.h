//
//  PPConstants.h
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 08/02/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    kPPTurnLeft,
    kPPTurnRight,
    kPPFlyStraight
} PPFlightDirection;


typedef enum {
    AESceneMenu,
    AESceneGame,
    AESceneGameOver,
    AESceneHangar
} AESceneType;

// Shop Items
typedef enum {
    AEShopItemBuyCredits1,
    AEShopItemBuyAirplane1,
    AEShopItemBuyTrails1,
} AEShopItemType;

// Shop Page
typedef enum {
    AEHangarItemsAirplanes,
    AEHangarItemsCredits,
} AEHangarItems;

typedef enum {
    AEAirplaneTypeAlbatros = 0,
    AEAirplaneTypeSpitfire,
    AEAirplaneTypeF22,
    AEAirplaneTypeZero,
    AEAirplaneTypeMeserchmit,
    AEAirplaneTypeF117,
    AEAirplaneTypeBlackbird
} AEAirplaneType;

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

extern NSString *const kSGBestScoreKey;
extern NSString *const kAETotalScoreKey;
extern NSString *const kAEUserBuyedSomethingKey;
extern NSString *const kAESoundIsEnabledKey;

extern NSString *const kSGPurchaseDonedNotification;
extern NSString *const kAEBoughtItemIdentifierKey;
extern NSString *const kSGItemBoughtNotification;
extern NSString *const kSGStartPurchaseNotification;
extern NSString *const kSGUpdateHangarScreenNotification;




