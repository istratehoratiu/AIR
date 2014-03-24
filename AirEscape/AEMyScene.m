//
//  PPMyScene.m
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 09/01/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEMyScene.h"
#import "SKSpriteNode+Additions.h"
#import "PPSpriteNode.h"
#import "PPMath.h"
#import "SKButtonNode.h"
#import "PPMainAirplane.h"
#import "PPMissile.h"
#import "PPConstants.h"

#define MAGNITUDE 100.0
// Aceasta valoate trebuie sa ia o valoare de la 0 la 1. 0 fiind cea mai peformanta
#define TURN_ANGLE_PERFORMANCE 1

@implementation AEMyScene

@synthesize arrayOfEnemyBombers             = _arrayOfEnemyBombers;
@synthesize arrayOfEnemyHunterAirplanes     = _arrayOfEnemyHunterAirplanes;
@synthesize arrayOfCurrentMissilesOnScreen  = _arrayOfCurrentMissilesOnScreen;
@synthesize positionIndicator               = _positionIndicator;
@synthesize gameIsPaused                    = _gameIsPaused;
@synthesize pauseButton                     = _pauseButton;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"airPlanesBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        background.blendMode = SKBlendModeReplace;
        [self addChild:background];
        
        
        self.arrayOfCurrentMissilesOnScreen = [NSMutableArray array];
        self.arrayOfEnemyHunterAirplanes = [NSMutableArray array];
        self.arrayOfEnemyBombers = [NSMutableArray array];
        
        /* Setup your scene here */
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        //init several sizes used in all scene
        _screenRect = [[UIScreen mainScreen] bounds];
        _screenHeight = _screenRect.size.height;
        _screenWidth = _screenRect.size.width;
        
        // Main Actor
        _userAirplane = [[PPMainAirplane alloc] initMainAirplane];
        _userAirplane.scale = 0.15;
        _userAirplane.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        _userAirplane.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_userAirplane.size.width * 0.5]; // 1
        _userAirplane.physicsBody.dynamic = YES; // 2
        _userAirplane.physicsBody.categoryBitMask = userAirplaneCategory; // 3
        _userAirplane.physicsBody.contactTestBitMask = missileCategory; // 4
        _userAirplane.physicsBody.collisionBitMask = 0; // 5
        
        [self addChild:_userAirplane];
        
        [_userAirplane updateOrientationVector];
        
        
        //schedule enemies
        SKAction *wait = [SKAction waitForDuration:2];
        SKAction *callClouds = [SKAction runBlock:^{
            [self addEnemyMissile];
        }];
        
        SKAction *updateClouds = [SKAction sequence:@[wait,callClouds]];
        [self runAction:[SKAction repeatActionForever:updateClouds]];
        
        //load explosions
        SKTextureAtlas *explosionAtlas = [SKTextureAtlas atlasNamed:@"EXPLOSION"];
        NSArray *textureNames = [explosionAtlas textureNames];
        _explosionTextures = [NSMutableArray new];
        for (NSString *name in textureNames) {
            SKTexture *texture = [explosionAtlas textureNamed:name];
            [_explosionTextures addObject:texture];
        }
        
        SKButtonNode *backButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"restart.png" selected:@"restart_down.png"];
        [backButton setPosition:CGPointMake(100, 100)];
        [backButton.title setFontName:@"Chalkduster"];
        [backButton.title setFontSize:20.0];
        [backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        backButton.zPosition = 1000;
        [self addChild:backButton];
        
        SKButtonNode *launchMissile = [[SKButtonNode alloc] initWithImageNamedNormal:@"glossy_red_button.png" selected:@"glossy_red_button.png"];
        [launchMissile setPosition:CGPointMake(100, 500)];
        [launchMissile.title setFontName:@"Chalkduster"];
        [launchMissile.title setFontSize:10.0];
        [launchMissile.title setText:@""];
        [launchMissile setTouchUpInsideTarget:self action:@selector(launchMissileFromMainAicraft)];
        launchMissile.zPosition = 1000;
        [self addChild:launchMissile];
        
        _pauseButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"play.png" selected:@"play.png"];
        [_pauseButton setPosition:CGPointMake(self.size.width - 100, self.size.height - 100)];
        [_pauseButton.title setFontName:@"Chalkduster"];
        [_pauseButton.title setFontSize:10.0];
        [_pauseButton.title setText:@"PAUSE"];
        [_pauseButton setTouchUpInsideTarget:self action:@selector(pauseGame)];
        _pauseButton.zPosition = 1000;
        [self addChild:_pauseButton];
        
        //_gameIsPaused = YES;
    }
    return self;
}

- (void)restartScene {
    
    _gameIsPaused = YES;
    
    [_userAirplane stopFiring];
    _userAirplane.health = kPPUserAirplaneHealth;
    _userAirplane.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    for (PPSpriteNode *item in _arrayOfCurrentMissilesOnScreen) {
        [item removeFromParent];
    }
    for (PPSpriteNode *item in _arrayOfEnemyBombers) {
        [item removeFromParent];
    }
    for (PPSpriteNode *item in _arrayOfEnemyHunterAirplanes) {
        [item removeFromParent];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdateTime) {
        _deltaTime = currentTime - _lastUpdateTime;
    } else {
        _deltaTime = 0;
    }
    _lastUpdateTime = currentTime;
    
    if (_gameIsPaused) {
        return;
    }
    
    [_userAirplane updateOrientationVector];
    [_userAirplane updateMove:_deltaTime];
    [_userAirplane updateRotation:_deltaTime];

    for (PPSpriteNode *missile in _arrayOfCurrentMissilesOnScreen) {
        [missile updateMove:_deltaTime];
        [missile updateRotation:_deltaTime];
        [missile setTargetPoint:_userAirplane.position];
        [missile updateOrientationVector];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    
    NSLog(@" %d --- %d", contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask);
    
    if (((contact.bodyA.categoryBitMask ==  enemyMissileCategory) && (contact.bodyB.categoryBitMask == userAirplaneCategory)) ||
        ((contact.bodyA.categoryBitMask ==  userAirplaneCategory) && (contact.bodyB.categoryBitMask == enemyMissileCategory))) {
        // Remove bullet from scene.
        if (contact.bodyA.categoryBitMask ==  enemyMissileCategory) {
            [_arrayOfCurrentMissilesOnScreen removeObject:firstNode];
            [firstNode removeFromParent];
        } else {
            [_arrayOfCurrentMissilesOnScreen removeObject:secondNode];
            [secondNode removeFromParent];
        }
        
        [_userAirplane setHealth:_userAirplane.health - 50];
        
        if ([_userAirplane health] <= 0) {
            [self restartScene];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    // 1
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        if (location.x < self.size.width * 0.5) {
            _userAirplane.flightDirection = kPPTurnLeft;
        } else {
            _userAirplane.flightDirection = kPPTurnRight;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        _userAirplane.flightDirection = kPPFlyStraight;
    }
}
#pragma mark -
#pragma mark Helper Methods

- (void)addEnemyMissile {
    PPMissile *missile = [[PPMissile alloc] initMissileNode];
    missile.position = CGPointMake(getRandomNumberBetween(0, self.size.width), getRandomNumberBetween(0, self.size.height));
    missile.targetAirplane = _userAirplane;
    missile.scale = 0.1;
    
    missile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missile.frame.size]; // 1
    missile.physicsBody.dynamic = YES; // 2
    missile.physicsBody.categoryBitMask = enemyMissileCategory; // 3
    missile.physicsBody.contactTestBitMask = userAirplaneCategory; // 4
    missile.physicsBody.collisionBitMask = 0; // 5
    
    [self addChild:missile];
    
    [_arrayOfCurrentMissilesOnScreen addObject:missile];
    [missile updateOrientationVector];
}

- (void)pauseGame {
    _gameIsPaused = !_gameIsPaused;
    
    if (!_gameIsPaused) {
        _pauseButton.normalTexture = [SKTexture textureWithImageNamed:@"pause.png"];
        _pauseButton.selectedTexture = [SKTexture textureWithImageNamed:@"pause.png"];
    } else {
        _pauseButton.normalTexture = [SKTexture textureWithImageNamed:@"play.png"];
        _pauseButton.selectedTexture = [SKTexture textureWithImageNamed:@"play.png"];
    }
}

@end


