//
//  AEHangarItemTableViewCell.h
//  AirEscape
//
//  Created by Horatiu Istrate on 12/07/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AEShopItem;

@interface AEHangarItemTableViewCell : UITableViewCell {

}

@property (nonatomic, strong) AEShopItem *shopItem;

@property (nonatomic, retain) UILabel *itemNameLabel;
@property (nonatomic, retain) UIButton *buyItemButton;
@property (nonatomic, retain) UIImageView *currentSelectionCheckMark;
@property (nonatomic, retain) UIImageView *itemThumbnails;


- (void)buyOrUseItem:(id)sender;

@end
