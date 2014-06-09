//
//  AEMenuScene.h
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@class SKButtonNode;
@class PPMainAirplane;

@interface AEMenuScene : SKScene {

    SKSpriteNode *background;
    SKButtonNode *startGame;
    
    PPMainAirplane *decorAirplane;
    CFTimeInterval _lastUpdateTime;
    CFTimeInterval _deltaTime;
}

@end
