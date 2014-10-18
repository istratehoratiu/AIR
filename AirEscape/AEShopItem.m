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
        
        self.representedDictionary = dictionary;
        self.typeOfRepresentedItem = [dictionary valueForKey:@"ID"];
        self.title = [dictionary valueForKey:@"title"];
        self.isBought = [[dictionary valueForKey:@"isBought"] boolValue];
        self.isUsed = [[dictionary valueForKey:@"isUsed"] boolValue];
        self.thumbnails = [dictionary valueForKey:@"thumbnailImage"];
        
        if ([[dictionary valueForKey:@"price"] isKindOfClass:[NSString class]]) {
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[dictionary valueForKey:@"price"]];
            
            self.price = myNumber;
        } else {
            self.price = [dictionary valueForKey:@"price"];
        }

        self.lockedThumbnails = [dictionary valueForKey:@"lockedThumbnailImage"];
        self.value = [dictionary valueForKey:@"value"];
    }
    
    return self;
}

@end
