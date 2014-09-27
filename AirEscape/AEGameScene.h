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
@class AEButtonNode;
@class JCImageJoystick;
@class Joystick;

@interface AEGameScene : SKScene {
    
    SKSpriteNode *background;
    
    Joystick *_joistick;
}

@property (nonatomic, assign) CGFloat airplaneWidth;
@property (nonatomic, assign) CGFloat scaleAirplane;
@property (nonatomic, retain)AEButtonNode* numberOfMissileOnScreen;
@property (nonatomic, retain)AEButtonNode* pauseButton;
@property (nonatomic, retain)AEButtonNode* playButton;
@property (nonatomic, assign) BOOL gameIsPaused;
@property (nonatomic, retain) PPPositionIndicator *positionIndicator;
@property (nonatomic, retain) PPMainAirplane *userAirplane;
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
