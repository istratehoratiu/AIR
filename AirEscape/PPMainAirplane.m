//
//  PPMainAirplane.m
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 09/02/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "PPMainAirplane.h"
#import "SKSpriteNode+Additions.h"
#import "SKEmitterNode+Utilities.h"
#import "PPMath.h"
#import "PPConstants.h"
#import "PPMissile.h"
#import "AEMyScene.h"

#define kPPMainAirplaneRotationSpeed 1.5
#define kPPMissileRotationSpeed 1.5


@implementation PPMainAirplane


@synthesize targetAirplane = _targetAirplane;

- (id)initMainAirplane {
    self = [super initWithImageNamed:@"PLANE 8 N.png"];
    
    if (self) {
        
        self.health = kPPUserAirplaneHealth;
        self.speed =
        self.manevrability = kPPMainAirplaneRotationSpeed;
        self.damage = 10;
        self.rateOfFire = .2;
        self.numberOfRockets = 10;
        
        SKSpriteNode *_propeller = [SKSpriteNode spriteNodeWithImageNamed:@"PLANE PROPELLER 1.png"];
        _propeller.scale = 0.2;
        _propeller.position = CGPointMake(self.position.x + 105, self.position.y );
        
        SKTexture *propeller1 = [SKTexture textureWithImageNamed:@"PLANE PROPELLER 1.png"];
        SKTexture *propeller2 = [SKTexture textureWithImageNamed:@"PLANE PROPELLER 2.png"];
        
        SKAction *spin = [SKAction animateWithTextures:@[propeller1,propeller2] timePerFrame:0.1];
        SKAction *spinForever = [SKAction repeatActionForever:spin];
        [_propeller runAction:spinForever];
        
        _isFiringBullets = NO;
        
        [self addChild:_propeller];
        
        
        // Bring aircraft to foreground
        self.zPosition = 1;
        
        _shadow = [[SKSpriteNode alloc] initWithImageNamed:@"PLANE 8 SHADOW.png"];
        
        _smokeEmitter = [SKEmitterNode emitterNamed:@"DamageSmoke"];
        _smokeEmitter.position = CGPointMake(0, 30);
        [_smokeEmitter setParticleAlpha:1.0];
        [_smokeEmitter setParticleColor:[SKColor whiteColor]];
        _smokeEmitter.particleSpeed = self.zRotation;
        
        _fireEmitter = [SKEmitterNode emitterNamed:@"Fire"];
        _fireEmitter.position = CGPointMake(0, 15);
        [_fireEmitter setParticleAlpha:1.0];
        
        _fireEmitter.particleSpeed = self.zRotation;
        
    }
    
    return self;
}

- (void)setHealth:(CGFloat)health {
    [super setHealth:health];
    
    _health = health;
}

- (void)stopFiring {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fireBullet) object:nil];
    _isFiringBullets = NO;
}

- (void)updateMove:(CFTimeInterval)dt {
    
    if (!_shadow.parent) {
        
        _shadow.scale = .15;
        _shadow.zPosition = 0;
        [self.parent addChild:_shadow];
    }
    
    _shadow.position = CGPointMake(self.position.x + 10, self.position.y + 10);
    
//    if (!_smokeTrail.parent && _health < kPPUserAirplaneHealth) {
//        
//        NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"trail" ofType:@"sks"];
//        _smokeTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
//        _smokeTrail.position = CGPointMake(0.0, 0.0);
//        _smokeTrail.targetNode = self.parent;
//        
//        [self.parent addChild:_smokeTrail];
//    } else if (_smokeTrail.parent && _health == kPPUserAirplaneHealth) {
//        [_smokeTrail removeFromParent];
//    }

    _smokeEmitter.position = self.position;
    
    _fireEmitter.position = self.position;
    _smokeEmitter.particleSpeed = self.zRotation;
    _fireEmitter.particleSpeed = self.zRotation;
    
    [self updateEffectsFromHealth];
    
//    _smokeTrail.position = self.position;
//    _smokeTrail.particleColorSequence = nil;
//    _smokeTrail.particleColorBlendFactor = 1.0;
//    
//    if (_health < kPPUserAirplaneHealth * 0.3) {
//        _smokeTrail.particleColor = [SKColor colorWithRed:1 green:0.0 blue:0.0 alpha:1.0];
//    } else if (_health < kPPUserAirplaneHealth * 0.6) {
//        _smokeTrail.particleColor = [SKColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0];
//    }
//    
    CGPoint destinationPoint = [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
    
    CGPoint offset = skPointsSubtract(destinationPoint, self.position);
    
    CGPoint targetVector =  normalizeVector(offset);
    // 5
    float POINTS_PER_SECOND = 100;
    CGPoint targetPerSecond = skPointsMultiply(targetVector, POINTS_PER_SECOND);
    // 6
    //CGPoint actualTarget = ccpAdd(self.position, ccpMult(targetPerSecond, dt));
    CGPoint actualTarget = skPointsAdd(self.position, skPointsMultiply(targetPerSecond, dt));
    
    self.position = actualTarget;
    
}

- (void)updateRotation:(CFTimeInterval)dt {
    
    if (_flightDirection == kPPFlyStraight) {
        self.texture = [SKTexture textureWithImageNamed:@"PLANE 8 N.png"];
        return;
    }
    
    if (_flightDirection == kPPTurnLeft) {
        
        [self setZRotation:self.zRotation + (kPPMainAirplaneRotationSpeed * dt)];
        self.texture = [SKTexture textureWithImageNamed:@"PLANE 8 L.png"];
        
    } else {
        
        [self setZRotation:self.zRotation - (kPPMainAirplaneRotationSpeed * dt)];
        self.texture = [SKTexture textureWithImageNamed:@"PLANE 8 R.png"];
    }
    
    _shadow.zRotation = self.zRotation;
}

- (CGPoint)currentDirection {
    return [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
}

-(void)updateEffectsFromHealth {
    //[_smokeEmitter setParticleAlpha:kPPUserAirplaneHealth / (kPPUserAirplaneHealth - self.health)];
    //[_smokeEmitter setParticleColor:[SKColor colorWithWhite:kPPUserAirplaneHealth / (kPPUserAirplaneHealth - self.health) alpha:1.0]];
    
    if(self.health < kPPUserAirplaneHealth) {
        if (!_smokeEmitter.parent) {
            [self.parent addChild:_smokeEmitter];
            _smokeEmitter.targetNode = self.parent;
        }
        
        [_smokeEmitter setParticleAlpha:1.0];
    }
    
    if(self.health < kPPUserAirplaneHealth * 0.5) {
        if (!_fireEmitter.parent) {
            [self.parent addChild:_fireEmitter];
            _fireEmitter.targetNode = self.parent;
        }
        
        [_fireEmitter setParticleAlpha:1.0];
    }
}

@end
