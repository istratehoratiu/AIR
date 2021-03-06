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
#import "SKProduct+Additions.h"
#import "RageIAPHelper.h"

@implementation AEAppDelegate

@synthesize     atlas = _atlas;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [RageIAPHelper sharedInstance];
    
    [self testInternetConnection];
    
    _atlas = [SKTextureAtlas atlasNamed:@"sprite"];
    
    [Appirater setAppId:@"931203917"];
    //[Appirater userDidSignificantEvent:NO];
    
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    
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
    
    _currentTrackIndex = 0;
    
    _arrayOfSoundtracks = [NSArray arrayWithObjects:[[NSBundle mainBundle] URLForResource:@"Enter the Party" withExtension:@"mp3"],
                                                    [[NSBundle mainBundle] URLForResource:@"justin_mahar2" withExtension:@"mp3"],
                                                    [[NSBundle mainBundle] URLForResource:@"Electrodoodle" withExtension:@"mp3"],
                                                    [[NSBundle mainBundle] URLForResource:@"justin_mahar" withExtension:@"mp3"],
                                                    [[NSBundle mainBundle] URLForResource:@"Pamgaea" withExtension:@"mp3"],
                                                    [[NSBundle mainBundle] URLForResource:@"Cut Trance" withExtension:@"mp3"],nil];
    
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self.arrayOfSoundtracks objectAtIndex:self.currentTrackIndex] error:&error];
    self.backgroundMusicPlayer.delegate = self;
    
    BOOL shouldPlaySound = [[[NSUserDefaults standardUserDefaults] valueForKey:kAESoundIsEnabledKey] boolValue];
    
    if (shouldPlaySound) {
        [self.backgroundMusicPlayer play];
    }
    
    [self requestProducts];

    return YES;
}

- (void)requestProducts {
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            
            NSMutableDictionary *_creditsShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:_creditsPlistPath];
            
            NSArray *keyArray = [_creditsShopItemsDictionary allKeys];
            for (SKProduct *product in products) {
                for (NSString *key in keyArray) {
                    
                    NSMutableDictionary *currentDictionary = [_creditsShopItemsDictionary valueForKey:key];
                    
                    if ([[currentDictionary valueForKey:@"ID"] isEqualToString:product.productIdentifier]) {
                        [currentDictionary setValue:product.price forKey:@"price"];
                        [currentDictionary setValue:product.localizedTitle forKey:@"title"];
                        [currentDictionary setValue:product.localizedPrice forKey:@"localizedPrice"];
                        
                        break;
                    }
                }
            }
            _productsFetched = YES;
            [_creditsShopItemsDictionary writeToFile:_creditsPlistPath atomically:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSGUpdateHangarScreenNotification object:nil];
        } else {
            _productsFetched = NO;
            
        }
    }];
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


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *products = response.products;
    SKProduct *proUpgradeProduct = [products count] == 1 ? [products firstObject] : nil;
    
    
    NSMutableDictionary *_creditsShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:_creditsPlistPath];
    
    NSArray *keyArray = [_creditsShopItemsDictionary allKeys];
    
    for (NSString *key in keyArray) {
        
        NSMutableDictionary *currentDictionary = [_creditsShopItemsDictionary valueForKey:key];
        
        if ([[currentDictionary valueForKey:@"ID"] isEqualToString:proUpgradeProduct.productIdentifier]) {
            [currentDictionary setValue:proUpgradeProduct.price forKey:@"price"];
            [currentDictionary setValue:proUpgradeProduct.localizedTitle forKey:@"title"];
            [currentDictionary setValue:proUpgradeProduct.localizedPrice forKey:@"localizedPrice"];
            
            if ([[currentDictionary valueForKey:@"ID"] isEqualToString:@"com.istratehoratiu.missileevasion.missiles1"]) {
                self.product1 = [products count] == 1 ? [products firstObject] : nil;
            } else if ([[currentDictionary valueForKey:@"ID"] isEqualToString:@"com.istratehoratiu.missileevasion.missiles2"]) {
                self.product2 = [products count] == 1 ? [products firstObject] : nil;
            } else {
                self.product3 = [products count] == 1 ? [products firstObject] : nil;
            }
            
            break;
        }
    }
    
    [_creditsShopItemsDictionary writeToFile:_creditsPlistPath atomically:NO];
}

- (void)testInternetConnection
{
    self.internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    __weak typeof(self) weakSelf = self;
    
    // Internet is reachable
    self.internetReachable.reachableBlock = ^(Reachability*reach)
    {
        weakSelf.internetIsReachable = YES;
    };
    
    // Internet is not reachable
    self.internetReachable.unreachableBlock = ^(Reachability*reach)
    {
        weakSelf.internetIsReachable = NO;
    };
    
    [self.internetReachable startNotifier];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    ++self.currentTrackIndex;
    
    if (self.currentTrackIndex >= [self.arrayOfSoundtracks count]) {
        self.currentTrackIndex = 0;
    }
    
    NSError *error;
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self.arrayOfSoundtracks objectAtIndex:self.currentTrackIndex] error:&error];
    self.backgroundMusicPlayer.delegate = self;
    
    BOOL shouldPlaySound = [[[NSUserDefaults standardUserDefaults] valueForKey:kAESoundIsEnabledKey] boolValue];
    
    if (shouldPlaySound) {
        [self.backgroundMusicPlayer play];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    [self.backgroundMusicPlayer pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:kAESoundIsEnabledKey] boolValue]) {
        [self.backgroundMusicPlayer play];
    }
}

@end
