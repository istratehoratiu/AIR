//
//  AEAppDelegate.m
//  AirEscape
//
//  Created by Horatiu Istrate on 24/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEAppDelegate.h"
#import "Appirater.h"
#import "AEGameManager.h"


@implementation AEAppDelegate

@synthesize     atlas = _atlas;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _atlas = [SKTextureAtlas atlasNamed:@"sprite"];
    
    [Appirater setAppId:@"552035781"];
    //[Appirater userDidSignificantEvent:NO];
    
    
    // In order to be able to modify and save a plist we must move to the apps file system, do this at launch if it was not already done.
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    /* Load Airplane Items From PLIST */
    _airplanePListPath = [documentsDirectory stringByAppendingPathComponent:@"hangarItemsAirplanes.plist"]; //3
    if (![fileManager fileExistsAtPath: _airplanePListPath]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"hangarItemsAirplanes" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: _airplanePListPath error:&error]; //6
    }
    
    /* Load Credits Items From PLIST */
    _creditsPlistPath = [documentsDirectory stringByAppendingPathComponent:@"hangarItemsCredits.plist"];
    if (![fileManager fileExistsAtPath: _creditsPlistPath]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"hangarItemsCredits" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: _creditsPlistPath error:&error]; //6
    }
    
    
    [[AEGameManager sharedManager] updateMainAirplaneImages];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
