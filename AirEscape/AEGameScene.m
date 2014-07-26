//
//  PPMyScene.m
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 09/01/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEGameScene.h"
#import "SKSpriteNode+Additions.h"
#import "PPSpriteNode.h"
#import "PPMath.h"
#import "SKButtonNode.h"
#import "PPMainAirplane.h"
#import "PPMissile.h"
#import "PPConstants.h"
#import "AEActorsManager.h"
#import "Joystick.h"
#import "AEMenuScene.h"
#import "AEGameOverScene.h"
#import "PPMissile.h"


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
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
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
        _userAirplane.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.15 : 0.09;
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
        SKAction *addMissile = [SKAction runBlock:^{
            [self addEnemyMissile];
        }];
        
        SKAction *addMissilesForever = [SKAction sequence:@[wait,addMissile]];
        [self runAction:[SKAction repeatActionForever:addMissilesForever]];
        
        // Schedule missile haywire
        SKAction *waitForMissileHaywire = [SKAction waitForDuration:10];
        SKAction *haywireMissile = [SKAction runBlock:^{
            [self missileGoesHaywire];
        }];
        
        SKAction *updateMissileStatus = [SKAction sequence:@[waitForMissileHaywire,haywireMissile]];
        
        [self runAction:[SKAction repeatActionForever:updateMissileStatus]];
        
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
        [_pauseButton setPosition:CGPointMake(self.size.width - (_pauseButton.size.width * 0.5), self.size.height - (_pauseButton.size.height * 0.5))];
        [_pauseButton.title setFontName:@"Chalkduster"];
        [_pauseButton.title setFontSize:10.0];
        [_pauseButton.title setText:@""];
        [_pauseButton setTouchUpInsideTarget:self action:@selector(pauseGame)];
        _pauseButton.zPosition = 1000;
        [self addChild:_pauseButton];
        
        
        SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
        SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];
        _joistick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
        _joistick.position = CGPointMake(jsBackdrop.size.width, jsBackdrop.size.height + 200);
        [self addChild:_joistick];
        
        _gameIsPaused = NO;
        
        SKAction *enlarge = [SKAction scaleTo:.5 duration:1];
        
        SKSpriteNode *firstNumber = [SKSpriteNode spriteNodeWithImageNamed:@"1.png"];
        [firstNumber setScale:0];
        firstNumber.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        [self addChild:firstNumber];
        
        SKSpriteNode *secondNumber = [SKSpriteNode spriteNodeWithImageNamed:@"2.png"];
        [secondNumber setScale:0];
        secondNumber.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        [self addChild:secondNumber];
        
        SKSpriteNode *thirdNumber = [SKSpriteNode spriteNodeWithImageNamed:@"3.png"];
        [thirdNumber setScale:0];
        thirdNumber.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        [self addChild:thirdNumber];
        
        
        [firstNumber runAction:enlarge completion:^{
            
            [firstNumber removeFromParent];
            
            [secondNumber runAction:enlarge completion:^{
                
                [secondNumber removeFromParent];
                
                [thirdNumber runAction:enlarge completion:^{
                    [thirdNumber removeFromParent];
                }];
                
            }];
            
        }];
    }
    return self;
}

- (void)restartScene {
    
    SKTransition *crossFade = [SKTransition fadeWithDuration:0];
    
    AEGameOverScene *gameOverScene = [[AEGameOverScene alloc] initWithSize: self.size score:[_arrayOfCurrentMissilesOnScreen count]];
    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene:gameOverScene transition: crossFade];
    
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

    [_userAirplane updateOrientationVector];
    [_userAirplane updateMove:_deltaTime];

    if (_gameIsPaused) {
        return;
    }

    [self checkWithMarginsOfScreenActor:_userAirplane];
    
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
            [_userAirplane removeFromParent];
            [self performSelector:@selector(restartScene) withObject:nil afterDelay:2];
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
        
        self.joistick.position = location;
        
        [self.joistick touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.joistick touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        _userAirplane.flightDirection = kPPFlyStraight;
}


#pragma mark -
#pragma mark Helper Methods

- (void)missileGoesHaywire {
    for (PPMissile *missile in _arrayOfCurrentMissilesOnScreen) {
        if (!missile.missileHasGoneHaywire) {
            [missile setMissileHasGoneHaywire:YES];
            return;
        }
    }
}

- (void)addEnemyMissile {
    
    if (_gameIsPaused) {
        return;
    }
    
    CGPoint missileStartingPosition = CGPointZero;
    CGPoint missileAlertPosition = CGPointZero;
    
    // Get the wall from witch the missile will launch
    switch (getRandomNumberBetween(0, 3)) {
            // Left Wall
        case 0: {
            missileStartingPosition = CGPointMake(0, getRandomNumberBetween(0, self.size.height));
            missileAlertPosition = CGPointMake(50, missileStartingPosition.y);
            
            break;
        }
            // Top Wall
        case 1: {
            missileStartingPosition = CGPointMake(getRandomNumberBetween(0, self.size.width), self.size.height);
            missileAlertPosition = CGPointMake(missileStartingPosition.x, 50);
            break;
        }
            // Right Wall
        case 2: {
            missileStartingPosition = CGPointMake(self.size.width, getRandomNumberBetween(0, self.size.height));
            missileAlertPosition = CGPointMake(self.size.width - 50, missileStartingPosition.y);;
            break;
        }
            // Bottom Wall
        case 3: {
            missileStartingPosition = CGPointMake(getRandomNumberBetween(0, self.size.width), self.size.height);
            missileAlertPosition = CGPointMake(missileStartingPosition.x, self.size.height - 50);
            break;
        }
        default:
            break;
    }
    
    SKSpriteNode *alertSprite = [SKSpriteNode spriteNodeWithImageNamed:@"alert.png"];
    alertSprite.position = missileAlertPosition;
    [self addChild:alertSprite];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.1];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.1];
    
    SKAction *fadeInFadeOut = [SKAction sequence:@[fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut]];
    
    [alertSprite runAction:fadeInFadeOut completion:^{
        
        [alertSprite removeFromParent];
        
        PPMissile *missile = [[PPMissile alloc] initMissileNode];
        missile.targetAirplane = _userAirplane;
        missile.scale = 0.1;
        
        missile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missile.frame.size]; // 1
        missile.physicsBody.dynamic = YES; // 2
        missile.physicsBody.categoryBitMask = enemyMissileCategory; // 3
        missile.physicsBody.contactTestBitMask = userAirplaneCategory; // 4
        missile.physicsBody.collisionBitMask = 0; // 5
        missile.position = missileStartingPosition;
        
        
        [self addChild:missile];
        [_arrayOfCurrentMissilesOnScreen addObject:missile];
        
        [_numberOfMissileOnScreen.title setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_arrayOfCurrentMissilesOnScreen count]]];
        
        [missile updateOrientationVector];
    }];
    

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


