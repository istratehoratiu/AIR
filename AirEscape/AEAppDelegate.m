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
    
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    
    BOOL shouldPlaySound = [[[NSUserDefaults standardUserDefaults] valueForKey:kAESoundIsEnabledKey] boolValue];
    
    if (shouldPlaySound) {
        [self.backgroundMusicPlayer play];
    }
    
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
                        
//                        if ([[currentDictionary valueForKey:@"ID"] isEqualToString:@"com.istratehoratiu.missileevasion.missiles1"]) {
//                            self.product1 = [products count] == 1 ? [products firstObject] : nil;
//                        } else if ([[currentDictionary valueForKey:@"ID"] isEqualToString:@"com.istratehoratiu.missileevasion.missiles2"]) {
//                            self.product2 = [products count] == 1 ? [products firstObject] : nil;
//                        } else {
//                            self.product3 = [products count] == 1 ? [products firstObject] : nil;
//                        }
                        
                        break;
                    }
                }
            }

            
            [_creditsShopItemsDictionary writeToFile:_creditsPlistPath atomically:NO];
            
        }
    }];
//    NSSet *productIdentifiers1 = [NSSet setWithObject:@"com.istratehoratiu.missileevasion.missiles1"];
//    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers1];
//    productsRequest.delegate = self;
//    [productsRequest start];
//    
//    NSSet *productIdentifiers2 = [NSSet setWithObject:@"com.istratehoratiu.missileevasion.missiles2"];
//    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers2];
//    productsRequest.delegate = self;
//    [productsRequest start];
//    
//    NSSet *productIdentifiers3 = [NSSet setWithObject:@"com.istratehoratiu.missileevasion.missiles3"];
//    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers3];
//    productsRequest.delegate = self;
//    [productsRequest start];
//    
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
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


//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
//{
//    for (SKPaymentTransaction *transaction in transactions)
//    {
//        switch (transaction.transactionState)
//        {
//            case SKPaymentTransactionStatePurchased: {
//                
//                break;
//            }
//            case SKPaymentTransactionStateFailed: {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                break;
//            }
//            case SKPaymentTransactionStateRestored: {
//                
//                break;
//            }
//            default:
//                break;
//        }
//    }
//}

@end
