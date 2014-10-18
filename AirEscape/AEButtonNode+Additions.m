//
//  SKButtonNode+Additions.m
//  AirEscape
//
//  Created by Horatiu Istrate on 24/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEButtonNode+Additions.h"

@implementation AEButtonNode (Additions)

+ (AEButtonNode *)getPlayButton {
    AEButtonNode *playButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"playButton" selected:@"playButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    playButton.zPosition = 1000;
    [playButton setAlpha:0.0];
    return playButton;
}

+ (AEButtonNode *)getHangarButton {
    AEButtonNode *hangarButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"hangarButton" selected:@"hangarButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    hangarButton.zPosition = 1000;
    [hangarButton setAlpha:0.0];
    return hangarButton;
}

+ (AEButtonNode *)getRateButton {
    AEButtonNode *rateButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"rateButton" selected:@"rateButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    rateButton.zPosition = 1000;
    [rateButton setAlpha:0.0];
    return rateButton;
}

@end
