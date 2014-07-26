//
//  SKButtonNode+Additions.m
//  AirEscape
//
//  Created by Horatiu Istrate on 24/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "SKButtonNode+Additions.h"

@implementation SKButtonNode (Additions)

+ (SKButtonNode *)getPlayButton {
    SKButtonNode *playButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    [playButton.title setFontName:@"Chalkduster"];
    [playButton.title setFontSize:40.0];
    [playButton.title setText:@"Play"];
    playButton.zPosition = 1000;
    
    return playButton;
}

+ (SKButtonNode *)getHangarButton {
    SKButtonNode *playButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    [playButton.title setFontName:@"Chalkduster"];
    [playButton.title setFontSize:40.0];
    [playButton.title setText:@"Hangar"];
    playButton.zPosition = 1000;
    
    return playButton;
}

+ (SKButtonNode *)getRateButton {
    SKButtonNode *playButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    [playButton.title setFontName:@"Chalkduster"];
    [playButton.title setFontSize:40.0];
    [playButton.title setText:@"Rate"];
    playButton.zPosition = 1000;
    
    return playButton;
}

@end
