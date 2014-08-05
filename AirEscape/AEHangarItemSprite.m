//
//  AEHangarItemSprite.m
//  AirEscape
//
//  Created by Horatiu Istrate on 02/08/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEHangarItemSprite.h"
#import "SKButtonNode.h"
#import "AEShopItem.h"
#import "AEAppDelegate.h"
#import "NSObject+Additions.h"


@implementation AEHangarItemSprite

- (id)init {
    self = [super initWithImageNamed:@"shopItemBackground.png"];
    
    if (self) {
        _itemNameLabel = [[SKLabelNode alloc] init];
        [_itemNameLabel setFontSize:40];
        [_itemNameLabel setPosition:CGPointMake(0, self.size.height *  0.5 - 60)];
        
        _buyItemButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton"];
        [_buyItemButton setTouchUpInsideTarget:self action:@selector(buyOrSelectShopItem)];
        [_buyItemButton.title setFontName:@"Chalkduster"];
        [_buyItemButton.title setFontSize:40.0];
        [_buyItemButton.title setText:@"Buy"];
        [_buyItemButton setPosition:CGPointMake(0, 60 - (self.size.height *  0.5))];
        
        _selectItemButton = [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton"];
        [_selectItemButton setTouchUpInsideTarget:self action:@selector(buyOrSelectShopItem)];
        [_selectItemButton.title setFontName:@"Chalkduster"];
        [_selectItemButton.title setFontSize:40.0];
        [_selectItemButton.title setText:@"Select"];
        [_selectItemButton setPosition:CGPointMake(0, 60 - (self.size.height *  0.5))];
        
        _selectedItemLabel = [[SKLabelNode alloc] init];
        [_selectedItemLabel setFontSize:40];
        [_selectedItemLabel setText:@"Selected"];
        [_selectedItemLabel setPosition:CGPointMake(0, 60 - (self.size.height *  0.5))];
        
        [self addChild:_selectedItemLabel];
        [self addChild:_itemNameLabel];
        [self addChild:_buyItemButton];
        [self addChild:_selectItemButton];
    }
    
    return self;
}


#pragma mark - Setter/Getter Methods -

- (void)setShopItem:(AEShopItem *)shopItem {
    
    _shopItem = shopItem;
    
    [_itemNameLabel setText:_shopItem.title];
    
    [_buyItemButton setHidden:_shopItem.isBought];
    
    [_selectItemButton setHidden:!(!_shopItem.isUsed && _shopItem.isBought)];
    
    [_selectedItemLabel setHidden:!_shopItem.isUsed];
    
    
    if (_shopItem.thumbnails) {
        _itemThumbnailSprite = [[SKSpriteNode alloc] initWithImageNamed:_shopItem.thumbnails];
        [self addChild:_itemThumbnailSprite];
    }
}


#pragma mark - Button Methods -

- (void)buyOrSelectShopItem {

    if (!_shopItem.isBought) {
        NSMutableDictionary *_airplanesShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[self appDelegate] airplanePListPath]];
        
        NSMutableDictionary *updatedDictionary = [NSMutableDictionary dictionaryWithDictionary:_shopItem.representedDictionary];
        [updatedDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"isBought"];
        
        [_airplanesShopItemsDictionary setValue:updatedDictionary forKey:_shopItem.keyValue];
        
        [_airplanesShopItemsDictionary writeToFile:[[self appDelegate] airplanePListPath] atomically:NO];
    
    } else {
    
        NSMutableDictionary *_airplanesShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[self appDelegate] airplanePListPath]];
        
        NSArray *keyArray = [_airplanesShopItemsDictionary allKeys];
        
        for (NSString *key in keyArray) {
            
            NSMutableDictionary *currentDictionary = [_airplanesShopItemsDictionary valueForKey:key];
            
            if ([key isEqualToString:_shopItem.keyValue]) {
                [currentDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"isUsed"];
            } else {
                [currentDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"isUsed"];
            }
            
            [_airplanesShopItemsDictionary setValue:currentDictionary forKey:key];
        }
        
        [_airplanesShopItemsDictionary writeToFile:[[self appDelegate] airplanePListPath] atomically:NO];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSGUpdateHangarScreenNotification object:nil];
}

@end
