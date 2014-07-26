//
//  AEShopItem.h
//  AirEscape
//
//  Created by Horatiu Istrate on 13/07/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEShopItem : NSObject {

}

@property (nonatomic, assign) AEShopItem *typeOfRepresentedItem;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isBought;
@property (nonatomic, assign) BOOL isUsed;
@property (nonatomic, strong) NSString *thumbnails;

@end
