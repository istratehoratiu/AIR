//
//  PPMyScene.h
//  PaperPlane Fighting
//

//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class PPSpriteNode;
@class PPMainAirplane;
@class PPMainBase;
@class PPHunterAirplane;
@class PPPositionIndicator;
@class SKButtonNode;
@class JCImageJoystick;
@class Joystick;

@interface AEGameScene : SKScene {
    
    SKSpriteNode *background;
    PPMainAirplane *_userAirplane;
    CGFloat _scaleAirplane;
    PPMainBase *_mainBase;
    //PPHunterAirplane *_hunterAirplane;
    
    CFTimeInterval _lastUpdateTime;
    CFTimeInterval _deltaTime;
    
    CGRect _screenRect;
    CGFloat _screenHeight;
    CGFloat _screenWidth;
    
    NSMutableArray *_arrayOfCurrentMissilesOnScreen;
    
    PPPositionIndicator *_positionIndicator;
    BOOL _gameIsPaused;
    SKButtonNode *_pauseButton;
    SKButtonNode *_numberOfMissileOnScreen;
    
    Joystick *_joistick;
}
@property (nonatomic, assign) CGFloat scaleAirplane;
@property (nonatomic, retain)SKButtonNode* numberOfMissileOnScreen;
@property (nonatomic, retain)SKButtonNode* pauseButton;
@property (nonatomic, retain)SKButtonNode* playButton;
@property (nonatomic, assign) BOOL gameIsPaused;
@property (nonatomic, retain) PPPositionIndicator *positionIndicator;
@property (nonatomic, retain) PPMainAirplane *userAirplane;
@property (nonatomic, retain) PPMainBase *mainBase;
@property (nonatomic, assign) CGRect screenRect;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CFTimeInterval lastUpdateTime;
@property (nonatomic, assign) CFTimeInterval deltaTime;
@property (nonatomic, retain) NSMutableArray *arrayOfCurrentMissilesOnScreen;
@property (nonatomic, retain) NSMutableArray *arrayOfEnemyHunterAirplanes;
@property (nonatomic, retain) NSMutableArray *arrayOfEnemyBombers;
@property (nonatomic, retain) NSMutableArray *cloudsTextures;
@property (nonatomic, retain) NSMutableArray *explosionTextures;
@property (strong, nonatomic) JCImageJoystick *imageJoystick;
@property (strong, nonatomic) Joystick *joistick;

@end
