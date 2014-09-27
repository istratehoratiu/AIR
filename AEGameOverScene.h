//
//  AEGameOverScene.h
//  AirEscape
//
//  Created by Horatiu Istrate on 09/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class AEButtonNode;
@class AEGameOverStatisticsSprite;

@interface AEGameOverScene : SKScene {
    
}

@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, retain) AEButtonNode *restartButton;
@property (nonatomic, retain) AEButtonNode *hangarButton;
@property (nonatomic, retain) AEButtonNode *ratebutton;
@property (nonatomic, retain) AEGameOverStatisticsSprite *gameOverStatistic;
@property (nonatomic, retain) SKLabelNode *gameOverLabel;

-(id)initWithSize:(CGSize)size score:(NSInteger)score;

@end
