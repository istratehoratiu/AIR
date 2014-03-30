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
#import "AEActorsManager.h"
#import "JCImageJoystick.h"
#import "Joystick.h"


@implementation AEMyScene

@synthesize arrayOfEnemyBombers             = _arrayOfEnemyBombers;
@synthesize arrayOfEnemyHunterAirplanes     = _arrayOfEnemyHunterAirplanes;
@synthesize arrayOfCurrentMissilesOnScreen  = _arrayOfCurrentMissilesOnScreen;
@synthesize positionIndicator               = _positionIndicator;
@synthesize gameIsPaused                    = _gameIsPaused;
@synthesize pauseButton                     = _pauseButton;
@synthesize numberOfMissileOnScreen         = _numberOfMissileOnScreen;
@synthesize scaleAirplane                   = _scaleAirplane;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background1.jpg"];
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
//        _screenHeight = _screenRect.size.height;
//        _screenWidth = _screenRect.size.width;
//        
        // Main Actor
        _userAirplane = [[PPMainAirplane alloc] initMainAirplane];
        _userAirplane.scale = 0.15;
        _scaleAirplane = 1.0;
        _userAirplane.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        _userAirplane.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_userAirplane.size.width * 0.5]; // 1
        _userAirplane.physicsBody.dynamic = YES; // 2
        _userAirplane.physicsBody.categoryBitMask = userAirplaneCategory; // 3
        _userAirplane.physicsBody.contactTestBitMask = missileCategory; // 4
        _userAirplane.physicsBody.collisionBitMask = 0; // 5
        
        [self addChild:_userAirplane];
        
        [_userAirplane updateOrientationVector];
        
        
        //schedule enemies
        SKAction *wait = [SKAction waitForDuration:3];
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
        [backButton setPosition:CGPointMake(self.size.width - 100, 150)];
        [backButton.title setFontName:@"Chalkduster"];
        [backButton.title setFontSize:20.0];
        [backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        backButton.zPosition = 1000;
        //[self addChild:backButton];
        
        _numberOfMissileOnScreen = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [_numberOfMissileOnScreen setPosition:CGPointMake(self.size.width - 100, 100)];
        [_numberOfMissileOnScreen.title setFontName:@"Chalkduster"];
        [_numberOfMissileOnScreen.title setFontSize:40.0];
        [_numberOfMissileOnScreen.title setText:@"0"];
        _numberOfMissileOnScreen.zPosition = 1000;
        [self addChild:_numberOfMissileOnScreen];
        
        _pauseButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"play.png" selected:@"play.png"];
        [_pauseButton setPosition:CGPointMake(self.size.width - 100, self.size.height - 100)];
        [_pauseButton.title setFontName:@"Chalkduster"];
        [_pauseButton.title setFontSize:10.0];
        [_pauseButton.title setText:@""];
        [_pauseButton setTouchUpInsideTarget:self action:@selector(pauseGame)];
        _pauseButton.zPosition = 1000;
        [self addChild:_pauseButton];
        
        _gameIsPaused = YES;
        
        //------------- Missile Speed
        minusButtonMissileSpeed = [[SKButtonNode alloc] initWithImageNamedNormal:@"minus.png" selected:@"minus.png"];
        [minusButtonMissileSpeed setPosition:CGPointMake(50, 50)];
        [minusButtonMissileSpeed.title setFontName:@"Chalkduster"];
        [minusButtonMissileSpeed.title setFontSize:20.0];
        [minusButtonMissileSpeed setTouchUpInsideTarget:self action:@selector(decreaseMissileSpeed)];
        minusButtonMissileSpeed.zPosition = 1000;
        [self addChild:minusButtonMissileSpeed];
        
        missileSpeedIndicator = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [missileSpeedIndicator setPosition:CGPointMake(100, 15)];
        [missileSpeedIndicator.title setFontName:@"Chalkduster"];
        [missileSpeedIndicator.title setFontSize:20.0];
        //[backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        missileSpeedIndicator.zPosition = 1000;
        missileSpeedIndicator.title.text = [NSString stringWithFormat:@"M Speed:%.0f",[[AEActorsManager sharedManager] missileSpeed]];
        [self addChild:missileSpeedIndicator];
        
        plusButtonMissileSpeed = [[SKButtonNode alloc] initWithImageNamedNormal:@"plus.png" selected:@"plus.png"];
        [plusButtonMissileSpeed setPosition:CGPointMake(150, 50)];
        [plusButtonMissileSpeed.title setFontName:@"Chalkduster"];
        [plusButtonMissileSpeed.title setFontSize:20.0];
        [plusButtonMissileSpeed setTouchUpInsideTarget:self action:@selector(increaseMissileSpeed)];
        plusButtonMissileSpeed.zPosition = 1000;
        [self addChild:plusButtonMissileSpeed];
        
        //------------- Missile Manevrability
        minusButtonMissileManevrability = [[SKButtonNode alloc] initWithImageNamedNormal:@"minus.png" selected:@"minus.png"];
        [minusButtonMissileManevrability setPosition:CGPointMake(250, 50)];
        [minusButtonMissileManevrability.title setFontName:@"Chalkduster"];
        [minusButtonMissileManevrability.title setFontSize:20.0];
        [minusButtonMissileManevrability setTouchUpInsideTarget:self action:@selector(decreaseMissileManevrability)];
        minusButtonMissileManevrability.zPosition = 1000;
        [self addChild:minusButtonMissileManevrability];
        
        missileManevrabilityIndicator = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [missileManevrabilityIndicator setPosition:CGPointMake(300, 15)];
        [missileManevrabilityIndicator.title setFontName:@"Chalkduster"];
        [missileManevrabilityIndicator.title setFontSize:20.0];
        //[backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        missileManevrabilityIndicator.zPosition = 1000;
        missileManevrabilityIndicator.title.text = [NSString stringWithFormat:@"M Mane:%.1f",[[AEActorsManager sharedManager] missileManevrability]];
        [self addChild:missileManevrabilityIndicator];
        
        plusButtonMissileManevrability = [[SKButtonNode alloc] initWithImageNamedNormal:@"plus.png" selected:@"plus.png"];
        [plusButtonMissileManevrability setPosition:CGPointMake(350, 50)];
        [plusButtonMissileManevrability.title setFontName:@"Chalkduster"];
        [plusButtonMissileManevrability.title setFontSize:20.0];
        [plusButtonMissileManevrability setTouchUpInsideTarget:self action:@selector(increaseMissileManevrability)];
        plusButtonMissileManevrability.zPosition = 1000;
        [self addChild:plusButtonMissileManevrability];
        
        //------------- Airplane Speed
        minusButtonAirplaneSpeed = [[SKButtonNode alloc] initWithImageNamedNormal:@"minus.png" selected:@"minus.png"];
        [minusButtonAirplaneSpeed setPosition:CGPointMake(450, 50)];
        [minusButtonAirplaneSpeed.title setFontName:@"Chalkduster"];
        [minusButtonAirplaneSpeed.title setFontSize:20.0];
        [minusButtonAirplaneSpeed setTouchUpInsideTarget:self action:@selector(decreaseAircraftSpeed)];
        minusButtonAirplaneSpeed.zPosition = 1000;
        [self addChild:minusButtonAirplaneSpeed];
        
        airplaneSpeedIndicator = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [airplaneSpeedIndicator setPosition:CGPointMake(500, 15)];
        [airplaneSpeedIndicator.title setFontName:@"Chalkduster"];
        [airplaneSpeedIndicator.title setFontSize:20.0];
        //[backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        airplaneSpeedIndicator.zPosition = 1000;
        airplaneSpeedIndicator.title.text = [NSString stringWithFormat:@"A Speed:%.0f",[[AEActorsManager sharedManager] mainAirplaneSpeed]];
        [self addChild:airplaneSpeedIndicator];
        
        plusButtonAircraftSpeed = [[SKButtonNode alloc] initWithImageNamedNormal:@"plus.png" selected:@"plus.png"];
        [plusButtonAircraftSpeed setPosition:CGPointMake(550, 50)];
        [plusButtonAircraftSpeed.title setFontName:@"Chalkduster"];
        [plusButtonAircraftSpeed.title setFontSize:20.0];
        [plusButtonAircraftSpeed setTouchUpInsideTarget:self action:@selector(increaseAircraftSpeed)];
        plusButtonAircraftSpeed.zPosition = 1000;
        [self addChild:plusButtonAircraftSpeed];
        
        //------------- Airplane Manevrability
        minusButtonAirplaneManevrability = [[SKButtonNode alloc] initWithImageNamedNormal:@"minus.png" selected:@"minus.png"];
        [minusButtonAirplaneManevrability setPosition:CGPointMake(650, 50)];
        [minusButtonAirplaneManevrability.title setFontName:@"Chalkduster"];
        [minusButtonAirplaneManevrability.title setFontSize:20.0];
        [minusButtonAirplaneManevrability setTouchUpInsideTarget:self action:@selector(decreaseAircraftManevrability)];
        minusButtonAirplaneManevrability.zPosition = 1000;
        [self addChild:minusButtonAirplaneManevrability];
        
        aicraftManevrabilityIndicator = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [aicraftManevrabilityIndicator setPosition:CGPointMake(700, 15)];
        [aicraftManevrabilityIndicator.title setFontName:@"Chalkduster"];
        [aicraftManevrabilityIndicator.title setFontSize:20.0];
        //[backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        aicraftManevrabilityIndicator.zPosition = 1000;
        aicraftManevrabilityIndicator.title.text = [NSString stringWithFormat:@"A Mane:%.1f",[[AEActorsManager sharedManager] mainAirplaneManevrability]];
        [self addChild:aicraftManevrabilityIndicator];
        
        plusButtonAircraftManevrability = [[SKButtonNode alloc] initWithImageNamedNormal:@"plus.png" selected:@"plus.png"];
        [plusButtonAircraftManevrability setPosition:CGPointMake(750, 50)];
        [plusButtonAircraftManevrability.title setFontName:@"Chalkduster"];
        [plusButtonAircraftManevrability.title setFontSize:20.0];
        [plusButtonAircraftManevrability setTouchUpInsideTarget:self action:@selector(increasedAircraftManevrability)];
        plusButtonAircraftManevrability.zPosition = 1000;
        [self addChild:plusButtonAircraftManevrability];
        //-----------------------------
        
//        self.imageJoystick = [[JCImageJoystick alloc]initWithJoystickImage:(@"redStick.png") baseImage:@"stickbase.png"];
//        [self.imageJoystick setPosition:CGPointMake(100, 200)];
//        [self addChild:self.imageJoystick];

        SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
        SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];
        _joistick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
        _joistick.position = CGPointMake(jsBackdrop.size.width, jsBackdrop.size.height);
        //[self addChild:_joistick];
        
        //------------- Scale Main Airplane
        minusScaleAirplane = [[SKButtonNode alloc] initWithImageNamedNormal:@"minus.png" selected:@"minus.png"];
        [minusScaleAirplane setPosition:CGPointMake(100, 100)];
        [minusScaleAirplane.title setFontName:@"Chalkduster"];
        [minusScaleAirplane.title setFontSize:15.0];
        [minusScaleAirplane setTouchUpInsideTarget:self action:@selector(minusAirplaneScale)];
        minusScaleAirplane.zPosition = 1000;
        [self addChild:minusScaleAirplane];
        
        mainAircraftScaleIndicator = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [mainAircraftScaleIndicator setPosition:CGPointMake(200, 100)];
        [mainAircraftScaleIndicator.title setFontName:@"Chalkduster"];
        [mainAircraftScaleIndicator.title setFontSize:15.0];
        //[backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        mainAircraftScaleIndicator.zPosition = 1000;
        mainAircraftScaleIndicator.title.text = [NSString stringWithFormat:@"Scale:%.2f", _scaleAirplane];
        [self addChild:mainAircraftScaleIndicator];
        
        plusScaleAirplane = [[SKButtonNode alloc] initWithImageNamedNormal:@"plus.png" selected:@"plus.png"];
        [plusScaleAirplane setPosition:CGPointMake(300, 100)];
        [plusScaleAirplane.title setFontName:@"Chalkduster"];
        [plusScaleAirplane.title setFontSize:15.0];
        [plusScaleAirplane setTouchUpInsideTarget:self action:@selector(plusAirplaneScale)];
        plusScaleAirplane.zPosition = 1000;
        [self addChild:plusScaleAirplane];
        
        aicraftWidthSize = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [aicraftWidthSize setPosition:CGPointMake(400, 100)];
        [aicraftWidthSize.title setFontName:@"Chalkduster"];
        [aicraftWidthSize.title setFontSize:15.0];
        //[backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        aicraftWidthSize.zPosition = 1000;
        aicraftWidthSize.title.text = [NSString stringWithFormat:@"Width:%.1f",_userAirplane.size.width];
        [self addChild:aicraftWidthSize];
        
        aicraftHeightSize = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [aicraftHeightSize setPosition:CGPointMake(500, 100)];
        [aicraftHeightSize.title setFontName:@"Chalkduster"];
        [aicraftHeightSize.title setFontSize:15.0];
        //[backButton setTouchUpInsideTarget:self action:@selector(restartScene)];
        aicraftHeightSize.zPosition = 1000;
        aicraftHeightSize.title.text = [NSString stringWithFormat:@"Height:%.1f",_userAirplane.size.height];
        [self addChild:aicraftHeightSize];
        
    }
    return self;
}

#pragma mark - 
#pragma mark Button Methods

- (void)minusAirplaneScale {
    _scaleAirplane = _scaleAirplane - 0.05;
    _userAirplane.scale = _scaleAirplane;
    mainAircraftScaleIndicator.title.text = [NSString stringWithFormat:@"Scale:%.2f", _scaleAirplane];
    aicraftWidthSize.title.text = [NSString stringWithFormat:@"Width:%.1f",_userAirplane.size.width];
    aicraftHeightSize.title.text = [NSString stringWithFormat:@"Height:%.1f",_userAirplane.size.height];
}

- (void)plusAirplaneScale {

    _scaleAirplane = _scaleAirplane + 0.05;
    _userAirplane.scale = _scaleAirplane;
    mainAircraftScaleIndicator.title.text = [NSString stringWithFormat:@"Scale:%.2f", _scaleAirplane];
    aicraftWidthSize.title.text = [NSString stringWithFormat:@"Width:%.1f",_userAirplane.size.width];
    aicraftHeightSize.title.text = [NSString stringWithFormat:@"Height:%.1f",_userAirplane.size.height];
}

- (void)decreaseMissileSpeed {
    [[AEActorsManager sharedManager] setMissileSpeed:[[AEActorsManager sharedManager] missileSpeed] - 5];
    missileSpeedIndicator.title.text = [NSString stringWithFormat:@"M Speed:%.0f",[[AEActorsManager sharedManager] missileSpeed]];
}

- (void)increaseMissileSpeed {
    [[AEActorsManager sharedManager] setMissileSpeed:[[AEActorsManager sharedManager] missileSpeed] + 5];
    missileSpeedIndicator.title.text = [NSString stringWithFormat:@"M Speed:%.0f",[[AEActorsManager sharedManager] missileSpeed]];
}

- (void)decreaseMissileManevrability {
    [[AEActorsManager sharedManager] setMissileManevrability:[[AEActorsManager sharedManager] missileManevrability] - .1];
    missileManevrabilityIndicator.title.text = [NSString stringWithFormat:@"M Mane:%.1f",[[AEActorsManager sharedManager] missileManevrability]];
}

- (void)increaseMissileManevrability {
    [[AEActorsManager sharedManager] setMissileManevrability:[[AEActorsManager sharedManager] missileManevrability] + .1];
    missileManevrabilityIndicator.title.text = [NSString stringWithFormat:@"M Mane:%.1f",[[AEActorsManager sharedManager] missileManevrability]];
}

- (void)decreaseAircraftSpeed {
    [[AEActorsManager sharedManager] setMainAirplaneSpeed:[[AEActorsManager sharedManager] mainAirplaneSpeed] - 5];
    airplaneSpeedIndicator.title.text = [NSString stringWithFormat:@"A Speed:%.0f",[[AEActorsManager sharedManager] mainAirplaneSpeed]];
}

- (void)increaseAircraftSpeed {
    [[AEActorsManager sharedManager] setMainAirplaneSpeed:[[AEActorsManager sharedManager] mainAirplaneSpeed] + 5];
    airplaneSpeedIndicator.title.text = [NSString stringWithFormat:@"A Speed:%.0f",[[AEActorsManager sharedManager] mainAirplaneSpeed]];
}

- (void)decreaseAircraftManevrability {
    [[AEActorsManager sharedManager] setMainAirplaneManevrability:[[AEActorsManager sharedManager] mainAirplaneManevrability] - .1];
    aicraftManevrabilityIndicator.title.text = [NSString stringWithFormat:@"A Mane:%.1f",[[AEActorsManager sharedManager] mainAirplaneManevrability]];
}

- (void)increasedAircraftManevrability {
    [[AEActorsManager sharedManager] setMainAirplaneManevrability:[[AEActorsManager sharedManager] mainAirplaneManevrability] + .1];
    aicraftManevrabilityIndicator.title.text = [NSString stringWithFormat:@"A Mane:%.1f",[[AEActorsManager sharedManager] mainAirplaneManevrability]];
}

- (void)restartScene {
    
    [self pauseGame];
    
    _userAirplane.health = 100;
    
    _userAirplane.position = CGPointMake(self.size.width / 2, self.size.height / 2);

    for (PPSpriteNode *item in _arrayOfCurrentMissilesOnScreen) {
        [item removeFromParent];
    }
    
    [_arrayOfCurrentMissilesOnScreen removeAllObjects];
    
    
    [[AEActorsManager sharedManager] setActorsDefaultProprietiesValues];
    
//    missileSpeedIndicator.title.text = [NSString stringWithFormat:@"M Speed:%.0f",[[AEActorsManager sharedManager] missileSpeed]];
//    missileManevrabilityIndicator.title.text = [NSString stringWithFormat:@"M Mane:%.1f",[[AEActorsManager sharedManager] missileManevrability]];
//    airplaneSpeedIndicator.title.text = [NSString stringWithFormat:@"A Speed:%.0f",[[AEActorsManager sharedManager] mainAirplaneSpeed]];
//    aicraftManevrabilityIndicator.title.text = [NSString stringWithFormat:@"A Mane:%.1f",[[AEActorsManager sharedManager] mainAirplaneManevrability]];
}

- (void)pauseGame {
    _gameIsPaused = !_gameIsPaused;
    
    [minusButtonMissileSpeed setHidden:!_gameIsPaused];
    [missileSpeedIndicator setHidden:!_gameIsPaused];
    [plusButtonMissileSpeed setHidden:!_gameIsPaused];
    [minusButtonMissileManevrability setHidden:!_gameIsPaused];
    [missileManevrabilityIndicator setHidden:!_gameIsPaused];
    [plusButtonMissileManevrability setHidden:!_gameIsPaused];
    [minusButtonAirplaneSpeed setHidden:!_gameIsPaused];
    [airplaneSpeedIndicator setHidden:!_gameIsPaused];
    [plusButtonAircraftSpeed setHidden:!_gameIsPaused];
    [minusButtonAirplaneManevrability setHidden:!_gameIsPaused];
    [aicraftManevrabilityIndicator setHidden:!_gameIsPaused];
    [plusButtonAircraftManevrability setHidden:!_gameIsPaused];
    [minusScaleAirplane setHidden:!_gameIsPaused];
    [mainAircraftScaleIndicator setHidden:!_gameIsPaused];
    [plusScaleAirplane setHidden:!_gameIsPaused];
    [aicraftWidthSize setHidden:!_gameIsPaused];
    [aicraftHeightSize setHidden:!_gameIsPaused];
    
    if (!_gameIsPaused) {
        _pauseButton.normalTexture = [SKTexture textureWithImageNamed:@"pause.png"];
        _pauseButton.selectedTexture = [SKTexture textureWithImageNamed:@"pause.png"];
    } else {
        _pauseButton.normalTexture = [SKTexture textureWithImageNamed:@"play.png"];
        _pauseButton.selectedTexture = [SKTexture textureWithImageNamed:@"play.png"];
    }
}


#pragma mark -
#pragma mark Update Screen 

-(void)update:(CFTimeInterval)currentTime {
    
        [_userAirplane updateRotation:_deltaTime];
    
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

    CGPoint bgVelocity = skPointsMultiply(_userAirplane.normaliedDirectonVector,-10);//CGPointMake(-50.0, 0);
    
    CGPoint amountToMove = skPointsMultiply(bgVelocity,_deltaTime);
    background.position = skPointsAdd(background.position,amountToMove);

    [self checkWithMarginsOfScreenActor:_userAirplane];
    
    if (background.position.x > CGRectGetMidX(self.frame) + 40) {
        background.position = CGPointMake(CGRectGetMidX(self.frame) + 40, background.position.y);
    }
    
    if (background.position.x < CGRectGetMidX(self.frame) - 40) {
        background.position = CGPointMake(CGRectGetMidX(self.frame) - 40, background.position.y);
    }

    if (background.position.y > CGRectGetMidY(self.frame) + 40) {
        background.position = CGPointMake(background.position.x, CGRectGetMidY(self.frame) + 40);
    }
    
    if (background.position.y < CGRectGetMidY(self.frame) - 40) {
        background.position = CGPointMake(background.position.x, CGRectGetMidY(self.frame) - 40);
    }
    
    
    
    for (PPSpriteNode *missile in _arrayOfCurrentMissilesOnScreen) {
        [missile updateMove:_deltaTime];
        [missile updateRotation:_deltaTime];
        [missile setTargetPoint:_userAirplane.position];
        [missile updateOrientationVector];
        [self checkWithMarginsOfScreenActor:missile];
    }
}


#pragma mark -
#pragma mark Collision detection

- (void)didBeginContact:(SKPhysicsContact *)contact {

    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
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

- (void)didEndContact:(SKPhysicsContact *)contact {
}


#pragma mark -
#pragma mark  User Interaction

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

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        _userAirplane.flightDirection = kPPFlyStraight;
}


#pragma mark -
#pragma mark Helper Methods

- (void)addEnemyMissile {
    
    if (_gameIsPaused) {
        return;
    }
    
    //NSLog(@">>>>>> %f --  %f", [AEActorsManager sharedManager].mainAirplaneSpeed, [AEActorsManager sharedManager].missileSpeed);
    [[AEActorsManager sharedManager] setMainAirplaneSpeed:[AEActorsManager sharedManager].mainAirplaneSpeed * 1.02];
    [[AEActorsManager sharedManager] setMissileSpeed:[AEActorsManager sharedManager].missileSpeed * 1.01];
    //NSLog(@"<<<<<< %f --  %f", [AEActorsManager sharedManager].mainAirplaneSpeed, [AEActorsManager sharedManager].missileSpeed);
    
    PPMissile *missile = [[PPMissile alloc] initMissileNode];
    missile.targetAirplane = _userAirplane;
    missile.scale = 0.1;
    
    missile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missile.frame.size]; // 1
    missile.physicsBody.dynamic = YES; // 2
    missile.physicsBody.categoryBitMask = enemyMissileCategory; // 3
    missile.physicsBody.contactTestBitMask = userAirplaneCategory; // 4
    missile.physicsBody.collisionBitMask = 0; // 5
    

    
    // Get the wall from witch the missile will launch
    switch (getRandomNumberBetween(0, 3)) {
        // Left Wall
        case 0: {
            missile.position = CGPointMake(0, getRandomNumberBetween(0, self.size.height));
            break;
        }
        // Top Wall
        case 1: {
            missile.position = CGPointMake(getRandomNumberBetween(0, self.size.width), self.size.height);
            break;
        }
        // Right Wall
        case 2: {
            missile.position = CGPointMake(self.size.width, getRandomNumberBetween(0, self.size.height));
            break;
        }
        // Bottom Wall
        case 3: {
            missile.position = CGPointMake(getRandomNumberBetween(0, self.size.width), 0);
            break;
        }
        default:
            break;
    }
    
    [self addChild:missile];
    [_arrayOfCurrentMissilesOnScreen addObject:missile];
    
    [_numberOfMissileOnScreen.title setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_arrayOfCurrentMissilesOnScreen count]]];
    
    [missile updateOrientationVector];
}

- (void)checkWithMarginsOfScreenActor:(PPSpriteNode *)actor {
    // Check with X
    if (actor.position.x < 0) {
        actor.position = CGPointMake(self.size.width - 10 , actor.position.y);
        return;
    }
    // Check with X + Width
    if (actor.position.x > self.size.width) {
        actor.position = CGPointMake(10.0, actor.position.y);
        return;
    }
    // Check with Y
    if (actor.position.y < 0) {
        actor.position = CGPointMake(actor.position.x, self.size.height - 10);
        return;
    }
    //Check with Y + Height
    if (actor.position.y > self.size.height) {
        actor.position = CGPointMake(actor.position.x, 10);
        return;
    }
}

@end


