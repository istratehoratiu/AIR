//
//  PPHangar.h
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 22/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AEHangarScene : SKScene {
    SKNode *_airplaneScrollingStrip;
}

@property (nonatomic,assign) NSUInteger score;
@property (nonatomic,assign) NSUInteger rightMarginOFHangarScrollView;
@property (nonatomic,assign) NSUInteger leftMarginOFHangarScrollView;
@property (nonatomic, strong) NSDictionary *airplanesShopItemsDictionary;
@property (nonatomic, strong) NSDictionary *trailsShopItemsDictionary;
@property (nonatomic, strong) NSDictionary *creditsShopItemsDictionary;

@end