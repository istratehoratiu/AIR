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
#import "NSObject+Additions.h"
#import "AEAppDelegate.h"
#import "AEActorsManager.h"
#import "Joystick.h"
#import "SKShapeNode+Additions.h"


@implementation PPMainAirplane


@synthesize targetAirplane  = _targetAirplane;
@synthesize normaliedDirectonVector = _normalizedDirectionVector;


- (id)initMainAirplane {
    self = [super initWithTexture:[[[self appDelegate] atlas] textureNamed:@"plane_N.png"]];
    
    if (self) {
        
        self.health = 90;
        self.damage = 10;
        self.rateOfFire = .2;
        self.numberOfRockets = 10;
        
        SKSpriteNode *_propeller = [SKSpriteNode spriteNodeWithImageNamed:@"plane_propeller_1.png"];
        _propeller.scale = 0.2;
        _propeller.position = CGPointMake(self.position.x + 105, self.position.y );
        
        SKTexture *propeller1 = [[[self appDelegate] atlas] textureNamed:@"plane_propeller_1.png"];
        SKTexture *propeller2 = [[[self appDelegate] atlas] textureNamed:@"plane_propeller_2.png"];
        
        SKAction *spin = [SKAction animateWithTextures:@[propeller1,propeller2] timePerFrame:0.1];
        SKAction *spinForever = [SKAction repeatActionForever:spin];
        [_propeller runAction:spinForever];
        
        _isFiringBullets = NO;
        
        [self addChild:_propeller];

        self.zPosition = 1;
        
        _shadow = [[SKSpriteNode alloc] initWithTexture:[[[self appDelegate] atlas] textureNamed:@"plane_shadow.png"]];
        
        _flightDirection = kPPFlyStraight;
        
        circle = [[SKShapeNode alloc] init];
        [self addChild:circle];
        circle.physicsBody.dynamic = NO;
        [circle drawCircleAtPoint:CGPointZero withRadius:10];
    }

    return self;
}

- (void)setHealth:(CGFloat)health {
    if (health <= _health * 0.5) {
        if (!_smokeEmitter.parent) {
            _smokeEmitter = [SKEmitterNode emitterNamed:@"DamageSmoke"];
            _smokeEmitter.position = CGPointMake(0, 30);
            [_smokeEmitter setParticleColor:[SKColor whiteColor]];
            //_smokeEmitter.particleSpeed = self.zRotation;
            [self.parent addChild:_smokeEmitter];
            _smokeEmitter.targetNode = self.parent;
        }
    }
    
    _health = health;
    
    if (_health <= 0) {
        [self addExplosionEmitter];
        [_smokeEmitter removeFromParent];
    } else {
        [self addBulletHitEmitter];
    }
    
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
    
    if (_smokeEmitter.parent) {
        _smokeEmitter.position = self.position;
        _smokeEmitter.particleSpeed = self.zRotation;
    }
    
    CGPoint destinationPoint = [self.parent convertPoint:CGPointMake(0, 30) fromNode:self];
    
    CGPoint offset = skPointsSubtract(destinationPoint, self.position);
    
    CGPoint targetVector =  normalizeVector(offset);
    
    _normalizedDirectionVector = targetVector;
    
    AEMyScene *airplaneParent = (AEMyScene *)self.parent;
    
    CGPoint targetPerSecond = skPointsMultiply(targetVector, [[AEActorsManager sharedManager] mainAirplaneSpeed] + (4 * magnitude(airplaneParent.joistick.velocity)));

    CGPoint actualTarget = skPointsAdd(self.position, skPointsMultiply(targetPerSecond, dt));
    
    self.position = actualTarget;
    
}

- (void)updateRotation:(CFTimeInterval)dt {

    AEMyScene *airplaneParent = (AEMyScene *)self.parent;
    
    if (_flightDirection == kPPFlyStraight) {
        
        self.texture = [[[self appDelegate] atlas] textureNamed:@"plane_N.png"];
        
    } else if (_flightDirection == kPPTurnLeft) {

            [self setZRotation:self.zRotation + ([[AEActorsManager sharedManager] mainAirplaneManevrability] * dt)];
            
            self.texture = [[[self appDelegate] atlas] textureNamed:@"plane_L.png"];
            
        } else if (_flightDirection == kPPTurnRight) {
            [self setZRotation:self.zRotation - ([[AEActorsManager sharedManager] mainAirplaneManevrability] * dt)];
            
            self.texture = [[[self appDelegate] atlas] textureNamed:@"plane_R.png"];
        }
    
    _shadow.zRotation = self.zRotation;
}

- (CGPoint)currentDirection {
    return [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
}

@end
