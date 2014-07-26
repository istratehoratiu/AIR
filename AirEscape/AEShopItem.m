//
//  AEShopItem.m
//  AirEscape
//
//  Created by Horatiu Istrate on 13/07/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEShopItem.h"

@implementation AEShopItem

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _typeOfRepresentedItem = [dictionary valueForKey:@"ID"];
        _title = [dictionary valueForKey:@"title"];
        _isBought = [[dictionary valueForKey:@"isBought"] boolValue];
        _isUsed = [[dictionary valueForKey:@"isUsed"] boolValue];
        _thumbnails = [dictionary valueForKey:@"thumbnails"];
    }
    
    return self;
}

@end
