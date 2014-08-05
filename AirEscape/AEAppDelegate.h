//
//  AEAppDelegate.h
//  AirEscape
//
//  Created by Horatiu Istrate on 24/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface AEAppDelegate : UIResponder <UIApplicationDelegate> {

    SKTextureAtlas* _atlas;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SKTextureAtlas* atlas;
@property (nonatomic, strong) NSString *airplanePListPath;

@end
