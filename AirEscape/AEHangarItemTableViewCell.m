//
//  AEHangarItemTableViewCell.m
//  AirEscape
//
//  Created by Horatiu Istrate on 12/07/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEHangarItemTableViewCell.h"
#import "AEShopItem.h"


@implementation AEHangarItemTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _itemNameLabel              = [[UILabel alloc] init];
        _buyItemButton              = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buyItemButton setBackgroundColor:[UIColor whiteColor]];
        [self.buyItemButton setTitle:@"Buy" forState:UIControlStateNormal];
        
        [_buyItemButton addTarget:self action:@selector(buyOrUseItem:) forControlEvents:UIControlEventTouchUpInside];
        _currentSelectionCheckMark  = [[UIImageView alloc] init];
        [self.currentSelectionCheckMark setImage:[UIImage imageNamed:@"checkMark.jpeg"]];
        _itemThumbnails             = [[UIImageView alloc] init];
        
        [self addSubview:_itemNameLabel];
        [self addSubview:_buyItemButton];
        [self addSubview:_currentSelectionCheckMark];
        [self addSubview:_itemThumbnails];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


- (void)setShopItem:(AEShopItem *)shopItem {
    
    _shopItem = shopItem;
    self.itemNameLabel.text = _shopItem.title;
    [self.buyItemButton setHidden:!_shopItem.isBought];
    [self.currentSelectionCheckMark setHidden:!_shopItem.isUsed];
    [self.itemThumbnails setImage:[UIImage imageNamed:_shopItem.thumbnails]];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_itemThumbnails setFrame:CGRectMake(14, 0, 98, 100)];
    [_itemNameLabel setFrame:CGRectMake(138, 25, 149, 50)];
    [_buyItemButton setFrame:CGRectMake(642, 15, 107, 69)];
    [_currentSelectionCheckMark setFrame:CGRectMake(657, 15, 77, 69)];
    
}

- (void)buyOrUseItem:(id)sender {

}

@end
