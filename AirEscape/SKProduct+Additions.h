//
//  SKProduct+Additions.h
//  AirEscape
//
//  Created by Horatiu Istrate on 18/10/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (Additions)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
