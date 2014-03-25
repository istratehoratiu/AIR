//
//  NSObject+Additions.m
//  AirEscape
//
//  Created by Horatiu Istrate on 25/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "NSObject+Additions.h"
#import "AEAppDelegate.h"

@implementation NSObject (Additions)

- (AEAppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

@end
