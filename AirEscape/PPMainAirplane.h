//
//  PPMainAirplane.h
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 09/02/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "PPSpriteNode.h"

@interface PPMainAirplane : PPSpriteNode {
    SKEmitterNode *_smokeEmitter;
    CGFloat _lastAngle;
    CGFloat _playerAngle;
    SKShapeNode *circle;
    
    CGPoint _normalizedDirectionVector;
}

@property (nonatomic, assign) CGPoint normaliedDirectonVector;
@property (nonatomic, strong) PPSpriteNode *targetAirplane;

- (id)initMainAirplane ;

- (CGPoint)currentDirection;

@end
