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
    AEButtonNode *playButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"playButton" selected:@"playButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    [playButton.title setFontName:@"Chalkduster"];
    [playButton.title setFontSize:40.0];
    //[playButton.title setText:@"Play"];
    playButton.zPosition = 1000;
    playButton.scale = 0.7;
    return playButton;
}

+ (AEButtonNode *)getHangarButton {
    AEButtonNode *hangarButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"hangarButton" selected:@"hangarButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    [hangarButton.title setFontName:@"Chalkduster"];
    [hangarButton.title setFontSize:40.0];
    //[playButton.title setText:@"Hangar"];
    hangarButton.zPosition = 1000;
    hangarButton.scale = 0.7;
    return hangarButton;
}

+ (AEButtonNode *)getRateButton {
    AEButtonNode *rateButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"rateButton" selected:@"rateButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    [rateButton.title setFontName:@"Chalkduster"];
    [rateButton.title setFontSize:40.0];
    //[playButton.title setText:@"Rate"];
    rateButton.zPosition = 1000;
    rateButton.scale = 0.7;
    return rateButton;
}

@end
