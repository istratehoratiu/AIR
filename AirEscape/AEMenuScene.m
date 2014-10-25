//
//  AEMenuScene.m
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEMenuScene.h"
#import "AEGameScene.h"
#import "AEButtonNode.h"
#import "PPMainAirplane.h"
#import "PPMath.h"
#import "AEButtonNode+Additions.h"
#import "AEGameOverScene.h"
#import "AEGameScene.h"
#import "AEHangarScene.h"
#import "Appirater.h"
#import "AEGameManager.h"
#import "ShadowLabelNode.h"
#import "NSObject+Additions.h"

#define kNumberOfDecorAirplanes 9

@implementation AEMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [[AEGameManager sharedManager] setCurrentScene:AESceneMenu];
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        background.blendMode = SKBlendModeReplace;
        [self addChild:background];
        
        _arrayOfDecorAirplanes = [NSMutableArray array];
        
        for (int i = 0; i < kNumberOfDecorAirplanes; i++) {
            PPMainAirplane *decorAirplane = [[PPMainAirplane alloc] initMainAirplaneOfType:(AEAirplaneType)getRandomNumberBetween(0, 8)];
            decorAirplane.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.2 : 0.1;
            decorAirplane.position = [self getDummyAirplaneStartingPosition];
            decorAirplane.zRotation = getRandomNumberBetween(0, 3);
            //decorAirplane.isDecorActor = YES;
            decorAirplane.isAutopilotON = YES;
            
            [_arrayOfDecorAirplanes addObject:decorAirplane];
            
            [self addChild:decorAirplane];
        }

        gameNameLabel = [[ShadowLabelNode alloc] initWithFontNamed:@"If"];
        gameNameLabel.text = @"Air Evasion";
        gameNameLabel.fontSize = 100;
        gameNameLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        gameNameLabel.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 100);
        gameNameLabel.zPosition = 1000;
        gameNameLabel.offset = CGPointMake(5, -5);
        [self addChild:gameNameLabel];
        
        AEButtonNode *playButton = [AEButtonNode getPlayButton];
        [playButton setPosition:CGPointMake(self.size.width / 2.0, self.size.height / 2.0 - 150.0)];
        [playButton setTouchUpInsideTarget:self action:@selector(startGame)];
        
        AEButtonNode *rateButton = [AEButtonNode getRateButton];
        [rateButton setPosition:CGPointMake(playButton.position.x - 250.0, playButton.position.y)];
        [rateButton setTouchUpInsideTarget:self action:@selector(rateGame)];
        
        AEButtonNode *hangarButton = [AEButtonNode getHangarButton];
        [hangarButton setPosition:CGPointMake(playButton.position.x + 250.0, playButton.position.y)];
        [hangarButton setTouchUpInsideTarget:self action:@selector(goToHangar)];
        
        [self addChild:playButton];
        [self addChild:hangarButton];
        [self addChild:rateButton];
    
        SKAction *fadeIn = [SKAction fadeInWithDuration: 1.0];
        
        [playButton runAction:fadeIn];
        [hangarButton runAction:fadeIn];
        [rateButton runAction:fadeIn];
        
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"AEMenuScene DEALLOC");
}


#pragma mark -
#pragma mark Handle touches

- (void)startGame {

    SKTransition *crossFade = [SKTransition fadeWithDuration:1];
    
    AEGameScene *newScene = [[AEGameScene alloc] initWithSize: self.size];
    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: newScene transition: crossFade];
}

- (void)goToHangar {
    
    if (self.appDelegate.internetIsReachable) {
        SKTransition *crossFade = [SKTransition fadeWithDuration:1];
        
        AEHangarScene *newScene = [[AEHangarScene alloc] initWithSize: self.size];
        //  Optionally, insert code to configure the new scene.
        [self.scene.view presentScene: newScene transition: crossFade];
    } else {
        UIAlertView *internetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet!" message:@"Please enable Internet access." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [internetAlert show];
    }
}

- (void)rateGame {
    [Appirater rateApp];
}

#pragma mark -
#pragma mark Update scene

-(void)update:(CFTimeInterval)currentTime {
    for (PPMainAirplane *airplane in _arrayOfDecorAirplanes) {
        [airplane updateRotation:_deltaTime];
        [airplane updateMove:_deltaTime];
        [self checkWithMarginsOfScreenActor:airplane];
    }
    if (_lastUpdateTime) {
        _deltaTime = currentTime - _lastUpdateTime;
    } else {
        _deltaTime = 0;
    }
    _lastUpdateTime = currentTime;
    
    
}

- (void)checkWithMarginsOfScreenActor:(PPSpriteNode *)actor {
    
    static NSInteger airplaneOffset = 15;
    
    // Check with X
    if (actor.position.x < -airplaneOffset) {
        actor.position = CGPointMake(self.size.width + airplaneOffset , actor.position.y);
        return;
    }
    // Check with X + Width
    if (actor.position.x > self.size.width + airplaneOffset) {
        actor.position = CGPointMake(-airplaneOffset, actor.position.y);
        return;
    }
    // Check with Y
    if (actor.position.y < -airplaneOffset) {
        actor.position = CGPointMake(actor.position.x, self.size.height + airplaneOffset);
        return;
    }
    //Check with Y + Height
    if (actor.position.y > self.size.height + airplaneOffset) {
        actor.position = CGPointMake(actor.position.x, -airplaneOffset);
        return;
    }
}

- (CGPoint)getDummyAirplaneStartingPosition {
    
    CGPoint airplaneSource = CGPointZero;
    
    switch (getRandomNumberBetween(0, 3)) {
            // Left Wall
        case 0: {
            airplaneSource = CGPointMake(0, getRandomNumberBetween(0, self.size.height));
            break;
        }
            // Top Wall
        case 1: {
            airplaneSource = CGPointMake(getRandomNumberBetween(0, self.size.width), self.size.height);
            break;
        }
            // Right Wall
        case 2: {
            airplaneSource = CGPointMake(self.size.width, getRandomNumberBetween(0, self.size.height));
            break;
        }
            // Bottom Wall
        case 3: {
            airplaneSource = CGPointMake(getRandomNumberBetween(0, self.size.width), self.size.height);
            break;
        }
        default:
            break;
    }
    
    return airplaneSource;
}

@end
