//
//  AEScene.m
//  AirEscape
//
//  Created by Horatiu Istrate on 12/10/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEScene.h"
#import "AEButtonNode.h"
#import "NSObject+Additions.h"
#import "PPConstants.h"


@implementation AEScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        BOOL shouldPlayMusic = [[[NSUserDefaults standardUserDefaults] valueForKey:kAESoundIsEnabledKey] boolValue];
        NSString *soundButtonImage = shouldPlayMusic ? @"soundON" : @"soundOFF";
        
        
        _soundButton = [[AEButtonNode alloc] initWithImageNamedNormal:soundButtonImage selected:soundButtonImage];
        [_soundButton setPosition:CGPointMake(size.width - 50, size.height - 50)];
        [_soundButton setTouchUpInsideTarget:self action:@selector(soundButtonPressed)];
        [_soundButton setZPosition:1000];
        
        [self addChild:_soundButton];

    }
    return self;
}


- (void)soundButtonPressed {
    if ([self appDelegate].backgroundMusicPlayer.isPlaying) {
        [[self appDelegate].backgroundMusicPlayer pause];
        [_soundButton setNormalTexture:[SKTexture textureWithImageNamed:@"soundOFF"]];
        [_soundButton setSelectedTexture:[SKTexture textureWithImageNamed:@"soundOFF"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:kAESoundIsEnabledKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[self appDelegate].backgroundMusicPlayer play];
        [_soundButton setNormalTexture:[SKTexture textureWithImageNamed:@"soundON"]];
        [_soundButton setSelectedTexture:[SKTexture textureWithImageNamed:@"soundON"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kAESoundIsEnabledKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
