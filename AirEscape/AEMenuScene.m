//
//  AEMenuScene.m
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEMenuScene.h"
#import "AEGameScene.h"
#import "SKButtonNode.h"
#import "PPMainAirplane.h"
#import "PPMath.h"
#import "SKButtonNode+Additions.h"
#import "AEHangarViewController.h"
#import "AEGameOverScene.h"
#import "AEGameScene.h"

#define kNumberOfDecorAirplanes 5

@implementation AEMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        background.blendMode = SKBlendModeReplace;
        [self addChild:background];
    }
    
    
    _arrayOfDecorAirplanes = [NSMutableArray array];
    
    startGame = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
    [startGame setPosition:CGPointMake(self.size.width / 2, self.size.height / 2 + 200)];
    [startGame.title setFontName:@"Chalkduster"];
    [startGame.title setFontSize:45.0];
    startGame.title.text = @"Missile Evasion";
    startGame.zPosition = 1;
    [self addChild:startGame];

    for (int i = 0; i < kNumberOfDecorAirplanes; i++) {
        PPMainAirplane *decorAirplane = [[PPMainAirplane alloc] initMainAirplane];
        decorAirplane.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.15 : 0.09;
        decorAirplane.position = CGPointMake(getRandomNumberBetween(0, self.size.width), getRandomNumberBetween(0, self.size.height));
        decorAirplane.zRotation = getRandomNumberBetween(0, 3);
        //decorAirplane.isDecorActor = YES;
        decorAirplane.isAutopilotON = YES;
        
        [_arrayOfDecorAirplanes addObject:decorAirplane];
        
        [self addChild:decorAirplane];
    }
    
    SKButtonNode *playButton = [SKButtonNode getPlayButton];
    [playButton setPosition:CGPointMake(self.size.width / 2, self.size.height / 2 - 100)];
    [playButton setTouchUpInsideTarget:self action:@selector(startGame)];
    
    [self addChild:playButton];
    
    return self;
}


#pragma mark -
#pragma mark Handle touches

- (void)startGame {

    SKTransition *crossFade = [SKTransition fadeWithDuration:1];
    
    AEMyScene *newScene = [[AEMyScene alloc] initWithSize: self.size];
    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: newScene transition: crossFade];
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
    // Check with X
    if (actor.position.x < 45) {
        actor.position = CGPointMake(self.size.width - 55 , actor.position.y);
        return;
    }
    // Check with X + Width
    if (actor.position.x > self.size.width - 45) {
        actor.position = CGPointMake(110.0, actor.position.y);
        return;
    }
    // Check with Y
    if (actor.position.y < 45) {
        actor.position = CGPointMake(actor.position.x, self.size.height - 55);
        return;
    }
    //Check with Y + Height
    if (actor.position.y > self.size.height - 45) {
        actor.position = CGPointMake(actor.position.x, 55);
        return;
    }
}

@end
