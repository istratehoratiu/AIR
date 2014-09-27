//
//  AEMenuScene.h
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@class AEButtonNode;
@class PPMainAirplane;
@class SKBlade;
@class ShadowLabelNode;

@interface AEMenuScene : SKScene {

    SKSpriteNode *background;
    ShadowLabelNode *gameNameLabel;
    
    CFTimeInterval _lastUpdateTime;
    CFTimeInterval _deltaTime;
    
    NSMutableArray *_arrayOfDecorAirplanes;
}

@end
