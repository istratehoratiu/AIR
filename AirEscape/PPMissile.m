//
//  PPMissile.m
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 09/02/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "PPMissile.h"
#import "SKSpriteNode+Additions.h"
#import "PPMath.h"
#import "PPConstants.h"
#import "AEGameManager.h"


@implementation PPMissile

@synthesize targetAirplane  = _targetAirplane;
@synthesize missileHasGoneHaywire = _missileHasGoneHaywire;

- (id)initMissileNode {
    
    self = [super initWithImageNamed:@"missile_small.png"];
    
    if (self) {
        
        NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"sks"];
        self.smokeTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
    }
    
    return self;
}

- (void)updateMove:(CFTimeInterval)dt {

    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(0, self.size.height) fromNode:self];
    
    CGPoint destinationPoint = lineEnd;
    
    CGPoint offset = skPointsSubtract(destinationPoint, self.position);
    
    CGPoint targetVector =  normalizeVector(offset);
    
    CGFloat missileSpeed = _missileHasGoneHaywire ? kAEMissileHaywireSpeed : [[AEGameManager sharedManager] getMissileSpeed];
    
    CGPoint targetPerSecond = skPointsMultiply(targetVector, missileSpeed);

    CGPoint actualTarget = skPointsAdd(self.position, skPointsMultiply(targetPerSecond, dt));
    
    self.position = actualTarget;
    
    if (![_smokeTrail parent]) {
        [self.parent addChild:_smokeTrail];
        _smokeTrail.targetNode = self.parent;
        [_smokeTrail setParticleColorBlendFactor:1];
        _smokeTrail.particleColorSequence = nil;
        [_smokeTrail setParticleColor:[UIColor whiteColor]];
    }
    _smokeTrail.position = actualTarget;

}

- (void)removeFromParent {
    [_smokeTrail removeFromParent];
    [super removeFromParent];
}

- (void)rotateToLeftIfAllowedOrGoStraight:(CFTimeInterval)dt {
    
    CGFloat missileManevrability = _missileHasGoneHaywire ? kAEMissileHaywireManevrability : [[AEGameManager sharedManager] missileManevrability];
    
    [self setZRotation:self.zRotation + (missileManevrability * dt)];
    
    CGPoint lineSource = [self.parent convertPoint:CGPointMake(0, 0) fromNode:self];
    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(0, self.size.height) fromNode:self];
    
    if (!checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
        
        [self setZRotation:self.zRotation - (missileManevrability * dt)];
        
        _spriteFinishedOrientationRotation = YES;
    }
}

- (void)rotateToRightIfAllowedOrGoStraight:(CFTimeInterval)dt {
    
    CGFloat missileManevrability = _missileHasGoneHaywire ? kAEMissileHaywireManevrability : [[AEGameManager sharedManager] missileManevrability];
    
    CGPoint lineSource = [self.parent convertPoint:CGPointMake(0, 0) fromNode:self];
    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(0, self.size.height) fromNode:self];
    
    [self setZRotation:self.zRotation - (missileManevrability * dt)];
    
    if (checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
        
        [self setZRotation:self.zRotation + (missileManevrability * dt)];
        
        _spriteFinishedOrientationRotation = YES;
    }
}

- (void)updateRotation:(CFTimeInterval)dt {

    [super updateRotation:dt];
    
    CGPoint lineSource = [self.parent convertPoint:CGPointMake(0, 0) fromNode:self];
    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(0, self.size.height) fromNode:self];
    
    if (checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
        [self rotateToLeftIfAllowedOrGoStraight:dt];
    } else {
        [self rotateToRightIfAllowedOrGoStraight:dt];
    }

    if (!_missileHasGoneHaywire) {
    
        CGFloat differenceBetweenCurrentAndLastAngle = fabsf(fabsf(self.lastOrientation) - fabsf(self.zRotation));
        
        if (differenceBetweenCurrentAndLastAngle > 0.02) {
            if (differenceBetweenCurrentAndLastAngle > 1) {
                differenceBetweenCurrentAndLastAngle = 1;
            }
            
            [[AEGameManager sharedManager] setMissileAcceleration: -(kAEMissileAcceleration * dt)];
            [[AEGameManager sharedManager] setMissileManevrability: [AEGameManager sharedManager].missileManevrability + (kAEMissileManevrability * (0.3 * dt))];
        } else {
            [[AEGameManager sharedManager] setMissileAcceleration: +(kAEMissileAcceleration * dt)];
            [[AEGameManager sharedManager] setMissileManevrability:[AEGameManager sharedManager].missileManevrability -(kAEMissileManevrability * 1.5 * dt)];
        }

        _lastOrientation = self.zRotation;
    }
}

- (void)startLockOnAnimation {
    
}

- (void)removeLockOn {
    
}

- (void)setMissileHasGoneHaywire:(BOOL)missileHasGoneHaywire {
    _missileHasGoneHaywire = missileHasGoneHaywire;
    
     [_smokeTrail setParticleColor:[UIColor redColor]];
}

@end
