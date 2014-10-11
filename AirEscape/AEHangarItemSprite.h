//
//  AEHangarItemSprite.h
//  AirEscape
//
//  Created by Horatiu Istrate on 02/08/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PPConstants.h"

@class AEShopItem;
@class AEButtonNode;

@interface AEHangarItemSprite : SKSpriteNode {

}

@property (nonatomic, strong) AEShopItem *shopItem;
@property (nonatomic, assign) AEHangarItems shopItemType;
@property (nonatomic, retain) SKLabelNode *itemNameLabel;
@property (nonatomic, retain) AEButtonNode *buyItemButton;
@property (nonatomic, retain) SKLabelNode *selectedItemLabel;
@property (nonatomic, retain) SKSpriteNode *backgroundSprite;
@property (nonatomic, retain) SKSpriteNode *itemThumbnailSprite;
@property (nonatomic, retain) SKSpriteNode *selectedAirplaneCheckmarkSprite;
@property (nonatomic, retain) SKLabelNode *itemPriceLabel;
@property (nonatomic, retain) SKSpriteNode *missileSprite;
@end
