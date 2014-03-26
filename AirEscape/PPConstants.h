//
//  PPConstants.h
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 08/02/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


#define kAEMainAirplaneManevrability    6
#define kAEMainAirplaneSpeed            520
#define kAEMissileManevrability         2
#define kAEMissileSpeed                 435

static const NSUInteger userAirplaneCategory              =  4;
static const NSUInteger missileCategory                   =  5;
static const NSUInteger enemyMissileCategory              =  7;

typedef enum {
    kPPTurnLeft,
    kPPTurnRight,
    kPPFlyStraight
} PPFlightDirection;