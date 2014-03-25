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
    
}

@property (nonatomic, strong) PPSpriteNode *targetAirplane;

- (id)initMainAirplane ;

- (CGPoint)currentDirection;

@end
