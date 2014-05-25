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
        
        _shadow.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.15 : 0.09;
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
    
    // Uncomment following comments in order to change speed depending on joystic position
    //AEMyScene *airplaneParent = (AEMyScene *)self.parent;
    CGPoint targetPerSecond = skPointsMultiply(targetVector, [[AEActorsManager sharedManager] mainAirplaneSpeed]);// + (4 * magnitude(airplaneParent.joistick.velocity)));

    CGPoint actualTarget = skPointsAdd(self.position, skPointsMultiply(targetPerSecond, dt));
    
    self.position = actualTarget;
    
}

- (void)rotateToLeftIfAllowedOrGoStraight:(CFTimeInterval)dt {
    AEMyScene *airplaneParent = (AEMyScene *)self.parent;
    
    [self setZRotation:self.zRotation + ([[AEActorsManager sharedManager] mainAirplaneManevrability] * dt)];
    
    self.texture = [[[self appDelegate] atlas] textureNamed:@"plane_L.png"];
    
    if (self.zRotation == airplaneParent.joistick.angularVelocity) {
        self.zRotation = airplaneParent.joistick.angularVelocity;
        self.texture = [[[self appDelegate] atlas] textureNamed:@"plane_N.png"];
    }
}


- (void)rotateToRightIfAllowedOrGoStraight:(CFTimeInterval)dt {
    
    AEMyScene *airplaneParent = (AEMyScene *)self.parent;
    
    [self setZRotation:self.zRotation - ([[AEActorsManager sharedManager] mainAirplaneManevrability] * dt)];
    
    self.texture = [[[self appDelegate] atlas] textureNamed:@"plane_R.png"];
    
    if (self.zRotation == airplaneParent.joistick.angularVelocity) {
        self.zRotation = airplaneParent.joistick.angularVelocity;
        self.texture = [[[self appDelegate] atlas] textureNamed:@"plane_N.png"];
    }
}

- (void)updateRotation:(CFTimeInterval)dt {

    AEMyScene *airplaneParent = (AEMyScene *)self.parent;
    
    if (airplaneParent.joistick.velocity.x != 0 || airplaneParent.joistick.velocity.y != 0) {
        
        if ((self.zRotation > 0 && airplaneParent.joistick.angularVelocity > 0 ) || (self.zRotation < 0 && airplaneParent.joistick.angularVelocity < 0 )) {
                
            if (self.zRotation < airplaneParent.joistick.angularVelocity) {
                [self rotateToLeftIfAllowedOrGoStraight:dt];
            } else if (self.zRotation > airplaneParent.joistick.angularVelocity) {
                [self rotateToRightIfAllowedOrGoStraight:dt];
            }
            
        } else {
            
            CGFloat distance = fabsf(self.zRotation) + fabsf(airplaneParent.joistick.angularVelocity);
            
            if (distance > M_PI) {
                if (self.zRotation < 0) {
                    [self rotateToRightIfAllowedOrGoStraight:dt];
                    
                } else {
                    [self rotateToLeftIfAllowedOrGoStraight:dt];
                }
            } else {
                if (self.zRotation < 0) {
                    [self rotateToLeftIfAllowedOrGoStraight:dt];
                } else {
                    [self rotateToRightIfAllowedOrGoStraight:dt];
                }
            }
        }
    }
    
    _shadow.zRotation = self.zRotation;
}

- (CGPoint)currentDirection {
    return [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
}

@end
