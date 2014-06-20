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
#import "AEActorsManager.h"


@implementation PPMissile

@synthesize targetAirplane  = _targetAirplane;

- (id)initMissileNode {
    
    self = [super initWithImageNamed:@"missile.png"];
    
    if (self) {
        
        NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"sks"];
        self.smokeTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
    }
    
    return self;
}

- (void)updateMove:(CFTimeInterval)dt {

    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(0, self.size.height) fromNode:self];
    
    CGPoint destinationPoint = lineEnd;//[self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
    
    CGPoint offset = skPointsSubtract(destinationPoint, self.position);
    
    CGPoint targetVector =  normalizeVector(offset);
    
//    if (_lastOrientation != self.zRotation) {
//        NSLog(@">>>>>>>>>>>>>");
//        [AEActorsManager sharedManager].missileSpeed -= kAEMissileAcceleration * dt;
//        
//        if ([AEActorsManager sharedManager].missileSpeed < kAEMinimumMissileSpeed) {
//            [AEActorsManager sharedManager].missileSpeed = kAEMinimumMissileSpeed;
//        }
//        
//        
//    } else {
//        NSLog(@"<<<<<<<<<<");
//        [AEActorsManager sharedManager].missileSpeed += kAEMissileAcceleration * dt;
//        
//        if ([AEActorsManager sharedManager].missileSpeed > kAEMaxMissileSpeed) {
//            [AEActorsManager sharedManager].missileSpeed = kAEMinimumMissileSpeed;
//        }
//    }
    
    _lastOrientation = self.zRotation;
    // 5
    //float POINTS_PER_SECOND = 150;
    CGPoint targetPerSecond = skPointsMultiply(targetVector, [[AEActorsManager sharedManager] missileSpeed]);
    // 6
    //CGPoint actualTarget = ccpAdd(self.position, ccpMult(targetPerSecond, dt));
    CGPoint actualTarget = skPointsAdd(self.position, skPointsMultiply(targetPerSecond, dt));
    
    self.position = actualTarget;
    
    if (![_smokeTrail parent]) {
        [self.parent addChild:_smokeTrail];
        _smokeTrail.targetNode = self.parent;
    }
    _smokeTrail.position = actualTarget;
    

}

- (void)removeFromParent {
    [_smokeTrail removeFromParent];
    [super removeFromParent];
}

- (void)rotateToLeftIfAllowedOrGoStraight:(CFTimeInterval)dt {
    
    [self setZRotation:self.zRotation + ([[AEActorsManager sharedManager] missileManevrability] * dt)];
    
    
    CGPoint lineSource = [self.parent convertPoint:CGPointMake(0, 0) fromNode:self];
    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(0, self.size.height) fromNode:self];
    
    if (!checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
        
        [self setZRotation:self.zRotation - ([[AEActorsManager sharedManager] missileManevrability] * dt)];
        
        _spriteFinishedOrientationRotation = YES;
    }
}

- (void)rotateToRightIfAllowedOrGoStraight:(CFTimeInterval)dt {
    
    CGPoint lineSource = [self.parent convertPoint:CGPointMake(0, 0) fromNode:self];
    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(0, self.size.height) fromNode:self];
    
    [self setZRotation:self.zRotation - ([[AEActorsManager sharedManager] missileManevrability] * dt)];
    
    if (checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
        
        [self setZRotation:self.zRotation + ([[AEActorsManager sharedManager] missileManevrability] * dt)];
        
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
    
    
}

- (void)startLockOnAnimation {
    
}

- (void)removeLockOn {
    
}

@end
