//
//  PPHangar.h
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 22/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PPConstants.h"
#import "AEButtonNode.h"


@interface AEHangarScene : SKScene {
    SKNode *_airplaneScrollingStrip;
}


@property (nonatomic,assign) AEHangarItems hangarItemsDisplayed;
@property (nonatomic,assign) NSUInteger score;
@property (nonatomic,assign) NSUInteger rightMarginOFHangarScrollView;
@property (nonatomic,assign) NSUInteger leftMarginOFHangarScrollView;
@property (nonatomic, strong) NSDictionary *shopItemsDictionary;
@property (nonatomic, strong) NSDictionary *trailsShopItemsDictionary;
@property (nonatomic, strong) NSDictionary *creditsShopItemsDictionary;
@property (nonatomic, strong) AEButtonNode *changeDisplayedItemsButton;
@property (nonatomic, strong) SKLabelNode *hintLabel;
@property (nonatomic, strong) AEButtonNode *backButton;
@property (nonatomic, strong) AEButtonNode *restoreButton;
@end
