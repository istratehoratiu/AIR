//
//  SKProduct+Additions.m
//  AirEscape
//
//  Created by Horatiu Istrate on 18/10/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "SKProduct+Additions.h"

@implementation SKProduct (Additions)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];

    return formattedString;
}

@end
