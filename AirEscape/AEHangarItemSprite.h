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
@class SKButtonNode;

@interface AEHangarItemSprite : SKSpriteNode {

}

@property (nonatomic, strong) AEShopItem *shopItem;


@property (nonatomic, retain) SKLabelNode *itemNameLabel;
@property (nonatomic, retain) SKButtonNode *buyItemButton;
@property (nonatomic, retain) SKButtonNode *selectItemButton;
@property (nonatomic, retain) SKLabelNode *selectedItemLabel;
@property (nonatomic, retain) SKSpriteNode *backgroundSprite;
@property (nonatomic, retain) SKSpriteNode *itemThumbnailSprite;

@end