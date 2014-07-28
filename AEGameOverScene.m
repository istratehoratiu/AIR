//
//  AEGameOverScene.m
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEGameOverScene.h"
#import "SKButtonNode+Additions.h"
#import "AEGameOverStatisticsSprite.h"
#import "AEGameScene.h"
#import "Appirater.h"
#import "AEHangarViewController.h"


#define kAEDurationOfGameOverLabelAnimation 1

@implementation AEGameOverScene

//@synthesize restartButton = _restartButton;
//@synthesize rankingsButton = _rankingsButton;
//@synthesize ratebutton = _ratebutton;
//@synthesize gameOverStatistic = _gameOverStatistic;
//@synthesize gameOverLabel = _gameOverLabel;

-(id)initWithSize:(CGSize)size score:(NSInteger)score {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        background.blendMode = SKBlendModeReplace;
        [self addChild:background];
    }
    
    _ratebutton = [SKButtonNode getRateButton];
    [_ratebutton setPosition:CGPointMake(self.size.width / 2 - 200, self.size.height / 2 - 200)];
    [_ratebutton setAlpha:0.0];
    [_ratebutton setTouchUpInsideTarget:self action:@selector(rateGame)];
    [self addChild:_ratebutton];
    [_ratebutton runAction:[SKAction fadeInWithDuration:1]];
    
    _restartButton = [SKButtonNode getPlayButton];
    [_restartButton setPosition:CGPointMake(self.size.width / 2, self.size.height / 2 - 200)];
    [_restartButton setAlpha:0.0];
    [_restartButton setTouchUpInsideTarget:self action:@selector(restartGame)];
    [self addChild:_restartButton];
    [_restartButton runAction:[SKAction fadeInWithDuration:1]];
    
    _hangarButton = [SKButtonNode getHangarButton];
    [_hangarButton setPosition:CGPointMake(self.size.width / 2 + 200, self.size.height / 2 - 200)];
    [_hangarButton setAlpha:0.0];
    [_hangarButton setTouchUpInsideTarget:self action:@selector(showHangar)];
    [self addChild:_hangarButton];
    [_hangarButton runAction:[SKAction fadeInWithDuration:1]];

    //--------
    _gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [_gameOverLabel setFontSize:40];
    [_gameOverLabel setText:@"Game Over"];
    [_gameOverLabel setPosition:CGPointMake(self.size.width / 2, self.size.height)];
    [self addChild:_gameOverLabel];
    
    
    //schedule game over label;
    SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *moveToPosition =[SKAction moveTo:CGPointMake(self.size.width / 2, 600 ) duration:kAEDurationOfGameOverLabelAnimation];
    SKAction *moveGameOverLabelAfterWaiting = [SKAction sequence:@[wait,moveToPosition]];
    
    [_gameOverLabel runAction:moveGameOverLabelAfterWaiting];
    
    //--------
    _gameOverStatistic = [[AEGameOverStatisticsSprite alloc] initGameOverSceneWithScore:score];
    [_gameOverStatistic setPosition:CGPointMake(self.size.width / 2, -200)];
    [self addChild:_gameOverStatistic];
    
    SKAction *moveStatisticsToPosition =[SKAction moveTo:CGPointMake(self.size.width / 2, self.size.height /2 ) duration:kAEDurationOfGameOverLabelAnimation];
    SKAction *moveStatiscticsAfterWaiting = [SKAction sequence:@[wait,moveStatisticsToPosition]];
    
    [_gameOverStatistic runAction:moveStatiscticsAfterWaiting];
    
    
    return self;
}

#pragma mark Handle touches

- (void)showHangar {
    AEHangarViewController *_hangarViewController = [[AEHangarViewController alloc] init];
    
    [self.view.window.rootViewController presentViewController:_hangarViewController animated:YES completion:nil];
}

- (void)restartGame {
    SKTransition *crossFade = [SKTransition fadeWithDuration:1];
    
    AEMyScene *newScene = [[AEMyScene alloc] initWithSize: self.size];
    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: newScene transition: crossFade];
}

- (void)rateGame {
    [Appirater rateApp];
}

@end
