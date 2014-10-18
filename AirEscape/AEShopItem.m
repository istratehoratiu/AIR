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
        
        self.representedDictionary  = dictionary;
        self.typeOfRepresentedItem  = [dictionary valueForKey:@"ID"];
        self.title                  = [dictionary valueForKey:@"title"];
        self.isBought               = [[dictionary valueForKey:@"isBought"] boolValue];
        self.isUsed                 = [[dictionary valueForKey:@"isUsed"] boolValue];
        self.thumbnails             = [dictionary valueForKey:@"thumbnailImage"];
        self.price                  = [dictionary valueForKey:@"price"];
        self.localizedPrice         = [dictionary valueForKey:@"localizedPrice"];
        self.lockedThumbnails       = [dictionary valueForKey:@"lockedThumbnailImage"];
        self.value                  = [dictionary valueForKey:@"value"];
        self.ID                     = [dictionary valueForKey:@"ID"];
    }
    
    return self;
}

@end
