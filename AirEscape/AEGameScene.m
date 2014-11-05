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
#import "AEButtonNode.h"
#import "PPMainAirplane.h"
#import "PPMissile.h"
#import "PPConstants.h"
#import "AEGameManager.h"
#import "Joystick.h"
#import "AEMenuScene.h"
#import "AEGameOverScene.h"
#import "PPMissile.h"


@implementation AEGameScene

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
        
        self.isPlayingMissileSound = NO;
        
        [[AEGameManager sharedManager] setCurrentScene:AESceneGame];
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
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
        _scaleAirplane = 1.0;
        _userAirplane.position = CGPointMake(self.size.width / 2, self.size.height - 100);
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
        
        _numberOfMissileOnScreen = [[AEButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
        [_numberOfMissileOnScreen setPosition:CGPointMake(self.size.width - 100, 100)];
        [_numberOfMissileOnScreen.title setFontName:@"if"];
        [_numberOfMissileOnScreen.title setFontSize:40.0];
        [_numberOfMissileOnScreen.title setText:@"0"];
        [self addChild:_numberOfMissileOnScreen];
        
        
        SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
        SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];
        _joistick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
        _joistick.position = CGPointMake(jsBackdrop.size.width, jsBackdrop.size.height + 200);
        [self addChild:_joistick];
        
        _gameIsPaused = NO;
        
        SKAction *enlarge = [SKAction scaleTo:1 duration:1];
        
        SKLabelNode *firstNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"if"];
        [firstNumberLabel setText:@"1"];
        [firstNumberLabel setFontSize:150];
        [firstNumberLabel setPosition:CGPointMake(self.size.width / 2, self.size.height / 2)];
        [firstNumberLabel setScale:0];
        firstNumberLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [self addChild:firstNumberLabel];
        
        SKLabelNode *secondNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"if"];
        [secondNumberLabel setText:@"2"];
        [secondNumberLabel setFontSize:150];
        [secondNumberLabel setPosition:CGPointMake(self.size.width / 2, self.size.height / 2)];
        [secondNumberLabel setScale:0];
        secondNumberLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [self addChild:secondNumberLabel];
        
        SKLabelNode *thirdNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"if"];
        [thirdNumberLabel setText:@"3"];
        [thirdNumberLabel setFontSize:150];
        [thirdNumberLabel setPosition:CGPointMake(self.size.width / 2, self.size.height / 2)];
        [thirdNumberLabel setScale:0];
        thirdNumberLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [self addChild:thirdNumberLabel];
        
        
        [firstNumberLabel runAction:enlarge completion:^{
            
            [firstNumberLabel removeFromParent];
            
            [secondNumberLabel runAction:enlarge completion:^{
                
                [secondNumberLabel removeFromParent];
                
                [thirdNumberLabel runAction:enlarge completion:^{
                    [thirdNumberLabel removeFromParent];
                }];
                
            }];
            
        }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    for (PPMissile *missile in _arrayOfCurrentMissilesOnScreen) {
        [missile updateMove:_deltaTime];
        [missile updateRotation:_deltaTime];
        [missile setTargetPoint:_userAirplane.position];
        [missile updateOrientationVector];
        [self checkWithMarginsOfScreenActor:missile];
    
        if (missile.missileHasGoneHaywire) {
            CGFloat distanceFormMainAirplane = distanceBetweenPoint(missile.position, self.userAirplane.position);
        
            if (distanceFormMainAirplane < 100 && !self.isPlayingMissileSound && self.userAirplane.health > 0) {
                
                self.isPlayingMissileSound = YES;
                
                [self runAction:[SKAction playSoundFileNamed:@"missile01.mp3" waitForCompletion:YES] completion:^{
                    self.isPlayingMissileSound = NO;
                }];
            }
        }
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
            [firstNode removeFromParent];
        } else {
            [secondNode removeFromParent];
        }
        
        [_userAirplane setHealth:_userAirplane.health - 50];
        
        if ([_userAirplane health] <= 0) {
            [self runAction:[SKAction playSoundFileNamed:@"explosion.mp3" waitForCompletion:NO]];

            
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
            missileAlertPosition = CGPointMake(25, missileStartingPosition.y);
            
            break;
        }
            // Top Wall
        case 1: {
            missileStartingPosition = CGPointMake(getRandomNumberBetween(0, self.size.width), self.size.height);
            missileAlertPosition = CGPointMake(missileStartingPosition.x, missileStartingPosition.y - 25);
            break;
        }
            // Right Wall
        case 2: {
            missileStartingPosition = CGPointMake(self.size.width, getRandomNumberBetween(0, self.size.height));
            missileAlertPosition = CGPointMake(self.size.width - 25, missileStartingPosition.y);;
            break;
        }
            // Bottom Wall
        case 3: {
            missileStartingPosition = CGPointMake(getRandomNumberBetween(0, self.size.width), 0);
            missileAlertPosition = CGPointMake(missileStartingPosition.x, 25);
            break;
        }
        default:
            break;
    }
    
    //[self runAction:[SKAction playSoundFileNamed:@"Alert.mp3" waitForCompletion:NO]];
    
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
        
        missile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missile.frame.size]; // 1
        missile.physicsBody.dynamic = YES; // 2
        missile.physicsBody.categoryBitMask = enemyMissileCategory; // 3
        missile.physicsBody.contactTestBitMask = userAirplaneCategory; // 4
        missile.physicsBody.collisionBitMask = 0; // 5
        missile.position = missileStartingPosition;

        [self addChild:missile];
        [self rotateNode:missile toFaceNode:missile.targetAirplane];
        
        [_arrayOfCurrentMissilesOnScreen addObject:missile];
        
        [_numberOfMissileOnScreen.title setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_arrayOfCurrentMissilesOnScreen count]]];
    }];
}


- (void)rotateNode:(SKNode *)nodeA toFaceNode:(SKNode *)nodeB {
    
    float deltaX = nodeB.position.x - nodeA.position.x;
    float deltaY = nodeB.position.y - nodeA.position.y;
    
    float angle = atan2f(deltaY, deltaX);
    
    [nodeA setZRotation:angle - M_PI_2];
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


