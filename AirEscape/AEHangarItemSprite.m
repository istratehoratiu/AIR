//
//  AEHangarItemSprite.m
//  AirEscape
//
//  Created by Horatiu Istrate on 02/08/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEHangarItemSprite.h"
#import "AEButtonNode.h"
#import "AEShopItem.h"
#import "AEAppDelegate.h"
#import "NSObject+Additions.h"
#import "AEGameManager.h"


@implementation AEHangarItemSprite

- (id)init {
    self = [super initWithImageNamed:@"shopItemBackground.png"];
    
    if (self) {
        _itemNameLabel = [[SKLabelNode alloc] initWithFontNamed:@"If"];
        [_itemNameLabel setFontSize:40];
        [_itemNameLabel setPosition:CGPointMake(0, self.size.height *  0.5 - 60)];
        _itemNameLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        
        _buyItemButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"missileBackgroundButton" selected:@"missileBackgroundButton"];
        [_buyItemButton setTouchUpInsideTarget:self action:@selector(buyOrSelectShopItem)];
        [_buyItemButton.title setFontName:@"Chalkduster"];
        //[_buyItemButton.title setFontColor:[UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1]];
        [_buyItemButton.title setFontColor:[UIColor darkGrayColor]];
        [_buyItemButton.title setFontSize:40.0];
        [_buyItemButton.title setText:@"Buy"];
        [_buyItemButton setPosition:CGPointMake(0, 60 - (self.size.height *  0.5))];
        
        _selectItemButton = [[AEButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton"];
        [_selectItemButton setTouchUpInsideTarget:self action:@selector(buyOrSelectShopItem)];
        [_selectItemButton.title setFontName:@"Chalkduster"];
        [_selectItemButton.title setFontSize:40.0];
        [_selectItemButton.title setText:@"Select"];
        [_selectItemButton setPosition:CGPointMake(0, 60 - (self.size.height *  0.5))];
        
        _selectedItemLabel = [[SKLabelNode alloc] init];
        [_selectedItemLabel setFontName:@"Chalkduster"];
        [_selectedItemLabel setFontSize:40];
        [_selectedItemLabel setText:@"Selected"];
        [_selectedItemLabel setPosition:CGPointMake(0, 60 - (self.size.height *  0.5))];
        
        _missileSprite = [[SKSpriteNode alloc] initWithImageNamed:@"priceIndicator"];
        [_missileSprite setPosition:CGPointMake(_buyItemButton.position.x, _buyItemButton.position.y)];
        
        [self addChild:_selectedItemLabel];
        [self addChild:_itemNameLabel];
        [self addChild:_buyItemButton];
        [self addChild:_selectItemButton];
        //[self addChild:_missileSprite];
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
    [_buyItemButton.title setText:[_shopItem.price stringValue]];
    [_missileSprite setHidden:_shopItem.isBought];
    
    CGFloat offesetForMissileIndicator = _buyItemButton.title.text.length * 22;
    [_missileSprite setPosition:CGPointMake(_buyItemButton.position.x + offesetForMissileIndicator, _buyItemButton.position.y)];
    
    if (_shopItem.thumbnails) {
        _itemThumbnailSprite = [[SKSpriteNode alloc] initWithImageNamed:_shopItem.thumbnails];
        [self addChild:_itemThumbnailSprite];
    }
}


#pragma mark - Button Methods -

- (void)buyOrSelectShopItem {

    if (_shopItemType == AEHangarItemsAirplanes) {
        if (!_shopItem.isBought) {
            
            NSNumber *totalCredits = [[NSUserDefaults standardUserDefaults] valueForKey:kAETotalScoreKey];
            NSInteger totalCreditsInteger = [totalCredits integerValue];
            NSInteger priceInteger = [_shopItem.price integerValue];
            
            if (priceInteger < totalCreditsInteger) {
                
                NSMutableDictionary *_airplanesShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[self appDelegate] airplanePListPath]];
                
                NSMutableDictionary *updatedDictionary = [NSMutableDictionary dictionaryWithDictionary:_shopItem.representedDictionary];
                [updatedDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"isBought"];
                
                [_airplanesShopItemsDictionary setValue:updatedDictionary forKey:_shopItem.keyValue];
                
                [_airplanesShopItemsDictionary writeToFile:[[self appDelegate] airplanePListPath] atomically:NO];
                
                [_missileSprite setHidden:YES];
                
                
                NSNumber *remainingMissiles = [NSNumber numberWithInteger:(totalCreditsInteger - priceInteger)];
                [[NSUserDefaults standardUserDefaults] setValue:remainingMissiles forKey:kAETotalScoreKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                UIAlertView *notEnoughtCreaditsAlert = [[UIAlertView alloc] initWithTitle:@"Not Enought Missiles" message:@"Get more missiles?" delegate:self.appDelegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Get Credits", nil];
                [notEnoughtCreaditsAlert show];
            }
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
            
            [[AEGameManager sharedManager] updateMainAirplaneImages];
        }
    } else {
    
    
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSGUpdateHangarScreenNotification object:nil];
}

@end
