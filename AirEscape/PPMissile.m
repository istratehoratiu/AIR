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

    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
    
    CGPoint destinationPoint = lineEnd;//[self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
    
    CGPoint offset = skPointsSubtract(destinationPoint, self.position);
    
    CGPoint targetVector =  normalizeVector(offset);
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

- (void)updateRotation:(CFTimeInterval)dt {

    CGPoint lineSource = [self.parent convertPoint:CGPointMake(0, 0) fromNode:self];
    CGPoint lineEnd = [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
    
    if (checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
        
        [self setZRotation:self.zRotation + ([[AEActorsManager sharedManager] missileManevrability] * dt)];
        
        
        CGPoint lineSource = [self.parent convertPoint:CGPointMake(0, 0) fromNode:self];
        CGPoint lineEnd = [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
        
        if (!checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
            
            [self setZRotation:self.zRotation - ([[AEActorsManager sharedManager] missileManevrability] * dt)];
            
            _spriteFinishedOrientationRotation = YES;
        }
    } else {
        
        [self setZRotation:self.zRotation - ([[AEActorsManager sharedManager] missileManevrability] * dt)];
        
        if (checkIfPointIsToTheLeftOfLineGivenByTwoPoints(_targetAirplane.position, lineSource, lineEnd)) {
            
            [self setZRotation:self.zRotation + ([[AEActorsManager sharedManager] missileManevrability] * dt)];
            
            _spriteFinishedOrientationRotation = YES;
        }
    }
}

- (void)startLockOnAnimation {
    
}

- (void)removeLockOn {
    
}

@end
