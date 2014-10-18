//
//  AEAppDelegate.h
//  AirEscape
//
//  Created by Horatiu Istrate on 24/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <StoreKit/StoreKit.h>

@import AVFoundation;

@interface AEAppDelegate : UIResponder <UIApplicationDelegate, SKProductsRequestDelegate> {

    SKTextureAtlas* _atlas;
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SKTextureAtlas* atlas;
@property (nonatomic, strong) NSString *airplanePListPath;
@property (nonatomic, strong) NSString *creditsPlistPath;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@end
