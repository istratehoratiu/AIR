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
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AEHangarItemTableViewCell" owner:self options:nil];
        self = [nib objectAtIndex:0];
    }
    
    return self;
}


- (void)setShopItem:(AEShopItem *)shopItem {
    _itemNameLabel.text = shopItem.title;
    [_buyItemButton setHidden:shopItem.isBought];
    [_currentSelectionCheckMark setHidden:shopItem.isUsed];
    [_itemThumbnails setImage:[UIImage imageNamed:shopItem.thumbnails]];
}

- (IBAction)buyOrUseItem:(id)sender {

}

@end
