//
//  AEMenuScene.m
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEMenuScene.h"
#import "AEMyScene.h"
#import "SKButtonNode.h"
#import "PPMainAirplane.h"


@implementation AEMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background1.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        background.blendMode = SKBlendModeReplace;
        [self addChild:background];
    }
    
    startGame = [[SKButtonNode alloc] initWithImageNamedNormal:nil selected:nil];
    [startGame setPosition:CGPointMake(self.size.width / 2, self.size.height / 2)];
    [startGame.title setFontName:@"Chalkduster"];
    [startGame.title setFontSize:20.0];
    startGame.title.text = @"Tap to start";
    startGame.zPosition = 1000;
    [self addChild:startGame];
    
    decorAirplane = [[PPMainAirplane alloc] initMainAirplane];
    decorAirplane.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.15 : 0.09;
    decorAirplane.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    decorAirplane.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:decorAirplane.size.width * 0.5]; // 1
    decorAirplane.physicsBody.dynamic = YES; // 2
    decorAirplane.physicsBody.categoryBitMask = userAirplaneCategory; // 3
    decorAirplane.physicsBody.contactTestBitMask = missileCategory; // 4
    decorAirplane.physicsBody.collisionBitMask = 0; // 5
    decorAirplane.isDecorActor = YES;
    
    [self addChild:decorAirplane];
    
    return self;
}


#pragma mark -
#pragma mark Handle touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    SKTransition *crossFade = [SKTransition fadeWithDuration:0];
    
    AEMyScene *newScene = [[AEMyScene alloc] initWithSize: self.size];
    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: newScene transition: crossFade];
}

-(void)update:(CFTimeInterval)currentTime {
    
    [decorAirplane updateRotation:_deltaTime];
    
    if (_lastUpdateTime) {
        _deltaTime = currentTime - _lastUpdateTime;
    } else {
        _deltaTime = 0;
    }
    _lastUpdateTime = currentTime;
    
    [decorAirplane updateMove:_deltaTime];
    [self checkWithMarginsOfScreenActor:decorAirplane];
    
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
