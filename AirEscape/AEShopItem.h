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

@property (nonatomic, strong) NSDictionary *representedDictionary;
@property (nonatomic, strong) NSString *keyValue;
@property (nonatomic, assign) AEShopItem *typeOfRepresentedItem;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isBought;
@property (nonatomic, assign) BOOL isUsed;
@property (nonatomic, strong) NSString *thumbnails;
@property (nonatomic, strong) NSString *lockedThumbnails;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *localizedPrice;
@property (nonatomic, strong) NSString *ID;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
