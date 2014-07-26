//
//  AEGameOverScene.h
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SKButtonNode;
@class AEGameOverStatisticsSprite;

@interface AEGameOverScene : SKScene {
    
}

@property (nonatomic, retain) SKButtonNode *restartButton;
@property (nonatomic, retain) SKButtonNode *hangarButton;
@property (nonatomic, retain) SKButtonNode *ratebutton;
@property (nonatomic, retain) AEGameOverStatisticsSprite *gameOverStatistic;
@property (nonatomic, retain) SKLabelNode *gameOverLabel;

-(id)initWithSize:(CGSize)size score:(NSInteger)score;

@end
