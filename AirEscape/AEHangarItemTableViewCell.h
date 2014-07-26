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

@property (nonatomic, retain) IBOutlet UILabel *itemNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *buyItemButton;
@property (nonatomic, retain) IBOutlet UIImageView *currentSelectionCheckMark;
@property (nonatomic, retain) IBOutlet UIImageView *itemThumbnails;


- (IBAction)buyOrUseItem:(id)sender;

@end
