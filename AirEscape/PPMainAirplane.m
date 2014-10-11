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
#import "AEGameScene.h"
#import "NSObject+Additions.h"
#import "AEAppDelegate.h"
#import "AEGameManager.h"
#import "Joystick.h"
#import "SKShapeNode+Additions.h"

@implementation PPMainAirplane


@synthesize targetAirplane  = _targetAirplane;
@synthesize normaliedDirectonVector = _normalizedDirectionVector;


- (id)initMainAirplaneOfType:(AEAirplaneType)airplaneType {
    self = [super initWithTexture:[PPMainAirplane textureForMainAirplaneOfType:airplaneType]];
    
    if (self) {
        
        self.health = 1;
        self.damage = 10;
        
        self.zPosition = 1;
        
        _shadow = [[SKSpriteNode alloc] initWithTexture:[PPMainAirplane textureForMainAirplaneShadowOfType:airplaneType]];
        
        _flightDirection = kPPFlyStraight;
    }
    
    return self;
}

- (id)initMainAirplane {
    self = [super initWithTexture:[AEGameManager sharedManager].straighFlightTexture];
    
    if (self) {
        
        self.health = 1;
        self.damage = 10;

        self.zPosition = 1;
        
        _shadow = [[SKSpriteNode alloc] initWithTexture:[AEGameManager sharedManager].shadowTexture];
        
        _flightDirection = kPPFlyStraight;
    }

    return self;
}

- (void)removeFromParent {
    [_shadow removeFromParent];
    [super removeFromParent];
}

- (void)setHealth:(CGFloat)health {
    
    _health = health;
    
    if (_health <= 0) {
        [self addExplosionEmitter];
        [_smokeEmitter removeFromParent];
    } else {
        [self addBulletHitEmitter];
    }
    
}

- (void)updateMove:(CFTimeInterval)dt {
    
    if (!_shadow.parent) {
        
        _shadow.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.15 : 0.09;
        _shadow.zPosition = 0;
        [self.parent addChild:_shadow];
    }
    
    if (!_smokeEmitter.parent) {
        _smokeEmitter = [SKEmitterNode emitterNamed:@"DamageSmoke"];
        _smokeEmitter.position = CGPointMake(0, 70);
        [_smokeEmitter setParticleColor:[SKColor blackColor]];
        [self.parent addChild:_smokeEmitter];
        _smokeEmitter.targetNode = self.parent;
    }
    
    _shadow.position = CGPointMake(self.position.x + 20, self.position.y + 20);
    
    if (_smokeEmitter.parent) {
        _smokeEmitter.position = self.position;
    }
    
    CGPoint destinationPoint = [self.parent convertPoint:CGPointMake(0, 30) fromNode:self];
    
    CGPoint offset = skPointsSubtract(destinationPoint, self.position);
    
    CGPoint targetVector =  normalizeVector(offset);
    
    _normalizedDirectionVector = targetVector;
    
    CGPoint targetPerSecond = skPointsMultiply(targetVector, [[AEGameManager sharedManager] getMainAirplaneSpeed]);

    CGPoint actualTarget = skPointsAdd(self.position, skPointsMultiply(targetPerSecond, dt));
    
    self.position = actualTarget;
    
}

- (void)rotateToLeftIfAllowedOrGoStraight:(CFTimeInterval)dt {
    [self setZRotation:self.zRotation + ([[AEGameManager sharedManager] mainAirplaneManevrability] * dt)];
    
//    self.texture = [AEGameManager sharedManager].leftFlightTexture;
    
    _shadow.zRotation = self.zRotation;
}

- (void)rotateToRightIfAllowedOrGoStraight:(CFTimeInterval)dt {
    
    [self setZRotation:self.zRotation - ([[AEGameManager sharedManager] mainAirplaneManevrability] * dt)];
    
//    self.texture = [AEGameManager sharedManager].rightFlightTexture;
    
    _shadow.zRotation = self.zRotation;
}

- (void)updateRotation:(CFTimeInterval)dt {

    [super updateRotation:dt];
    
    AEGameScene *airplaneParent = (AEGameScene *)self.parent;
    
    if (_isAutopilotON) {
        return;
    }
    
    if (airplaneParent.joistick.velocity.x != 0 || airplaneParent.joistick.velocity.y != 0) {
        
        if ((self.zRotation > 0 && airplaneParent.joistick.angularVelocity > 0 ) || (self.zRotation < 0 && airplaneParent.joistick.angularVelocity < 0 )) {
                
            if (self.zRotation < airplaneParent.joistick.angularVelocity) {
                [self rotateToLeftIfAllowedOrGoStraight:dt];
                
                if (self.zRotation >= airplaneParent.joistick.angularVelocity) {
                    self.zRotation = airplaneParent.joistick.angularVelocity;
                    self.texture = [AEGameManager sharedManager].straighFlightTexture;
                }
                
            } else if (self.zRotation > airplaneParent.joistick.angularVelocity) {
                [self rotateToRightIfAllowedOrGoStraight:dt];
                
                if (self.zRotation <= airplaneParent.joistick.angularVelocity) {
                    self.zRotation = airplaneParent.joistick.angularVelocity;
                    self.texture = [AEGameManager sharedManager].straighFlightTexture;
                }
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
    
    CGFloat differenceBetweenCurrentAndLastAngle = fabsf(fabsf(self.lastOrientation) - fabsf(self.zRotation));
    
    if (differenceBetweenCurrentAndLastAngle > 0.02) {
        if (differenceBetweenCurrentAndLastAngle > 1) {
            differenceBetweenCurrentAndLastAngle = 1;
        }
        
        [[AEGameManager sharedManager] setMainAirplaneAcceleration: (kAEMainAirplaneAcceleration * dt)];
        [[AEGameManager sharedManager] setMainAirplaneManevrability: [AEGameManager sharedManager].mainAirplaneManevrability + (kAEMainAirplaneManevrability * (0.3 * dt))];
    } else {
        [[AEGameManager sharedManager] setMainAirplaneAcceleration: -(kAEMainAirplaneAcceleration * 1.5 * dt)];
        [[AEGameManager sharedManager] setMainAirplaneManevrability:[AEGameManager sharedManager].mainAirplaneManevrability -(kAEMainAirplaneManevrability * 1.5 * dt)];
    }
    
    _lastOrientation = self.zRotation;
}

- (CGPoint)currentDirection {
    return [self.parent convertPoint:CGPointMake(self.size.width, 0) fromNode:self];
}

+ (SKTexture *)textureForMainAirplaneOfType:(AEAirplaneType)airplaneType {
    
    SKTexture *mainAirplaneTexture = nil;
    
    switch (airplaneType) {
        case AEAirplaneTypeAlbatros: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"plane_1_N.png"];
            break;
        }
        case AEAirplaneTypeSpitfire: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"plane_2_N.png"];
            break;
        }
        case AEAirplaneTypeF22: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"plane_3_N.png"];
            break;
        }
        case AEAirplaneTypeZero: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"plane_4_N.png"];
            break;
        }
        case AEAirplaneTypeMeserchmit: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"plane_5_N.png"];
            break;
        }
        case AEAirplaneTypeBlackbird: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"plane_6_N.png"];
            break;
        }
        case AEAirplaneTypeF117: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"plane_7_N.png"];
            break;
        }
        default:
            break;
    }
    
    return mainAirplaneTexture;
}

+ (SKTexture *)textureForMainAirplaneShadowOfType:(AEAirplaneType)airplaneType {
    
    SKTexture *mainAirplaneTexture = nil;
    
    switch (airplaneType) {
        case AEAirplaneTypeAlbatros: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"shadow1.png"];
            break;
        }
        case AEAirplaneTypeSpitfire: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"shadow2.png"];
            break;
        }
        case AEAirplaneTypeF22: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"shadow3.png"];
            break;
        }
        case AEAirplaneTypeZero: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"shadow4.png"];
            break;
        }
        case AEAirplaneTypeMeserchmit: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"shadow5.png"];
            break;
        }
        case AEAirplaneTypeBlackbird: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"shadow6.png"];
            break;
        }
        case AEAirplaneTypeF117: {
            mainAirplaneTexture = [[[self appDelegate] atlas] textureNamed:@"shadow7.png"];
            break;
        }
        default:
            break;
    }
    
    return mainAirplaneTexture;
}


@end
