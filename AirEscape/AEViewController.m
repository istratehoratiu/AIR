//
//  AEViewController.m
//  AirEscape
//
//  Created by Horatiu Istrate on 24/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEViewController.h"
#import "AEGameScene.h"
#import "AEMenuScene.h"
#import "AEGameOverScene.h"
#import <iAd/iAd.h>
#import "AEGameManager.h"

#define ADDBannerWidth 320
#define ADDBannerHeight 50

@interface 	AEViewController () <ADBannerViewDelegate>

@property (nonatomic, assign) BOOL addBannerIsHidden;
@property (nonatomic, strong) ADBannerView *banner;


@end

@implementation AEViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AEGameManager sharedManager] addObserver:self forKeyPath:@"currentScene" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)dealloc {
    [[AEGameManager sharedManager] removeObserver:self forKeyPath:@"currentScene"];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.originalContentView;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        _banner = [[ADBannerView alloc] initWithFrame:CGRectZero];
        [_banner setFrame:CGRectMake((self.view.bounds.size.width - _banner.frame.size.width) * 0.5,
                                                                    -_banner.frame.size.height,
                                                                    _banner.frame.size.width,
                                                                    _banner.frame.size.height)];
        self.banner.delegate = self;
        [self.banner sizeToFit];
        _addBannerIsHidden = YES;
        [self.view addSubview:_banner];
        
        // Create and configure the scene.
        SKScene * scene = [[AEMenuScene alloc] initWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self hideADDS];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self showADDS];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)showADDS {
    
    BOOL userBoughtItems = [[[NSUserDefaults standardUserDefaults] valueForKey:kAEUserBuyedSomethingKey] boolValue];

    if (userBoughtItems) {
        return;
    }
    
    AESceneType currentScene = [AEGameManager sharedManager].currentScene;
    
    if (_addBannerIsHidden && (currentScene != AESceneHangar) && (currentScene != AESceneGame)) {
        
        SKView * skView = (SKView *)self.originalContentView;
        if (
            [skView.scene isKindOfClass:[AEGameScene class]]) {
            return;
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        _banner.frame = CGRectMake((self.view.bounds.size.width - _banner.frame.size.width) * 0.5, 0, _banner.frame.size.width, _banner.frame.size.height);
        
        _addBannerIsHidden = NO;
        [UIView commitAnimations];
    }
}

- (void)hideADDS {
    if (!_addBannerIsHidden) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        [_banner setFrame:CGRectMake((self.view.bounds.size.width - _banner.frame.size.width) * 0.5, -_banner.frame.size.height, _banner.frame.size.width, _banner.frame.size.height)];
        
        _addBannerIsHidden = YES;
        
        [UIView commitAnimations];
    }
}


#pragma mark - KVO -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"currentScene"]) {
        switch ([object currentScene]) {
            case AESceneMenu:
            case AESceneGameOver: {
                BOOL userBoughtItems = [[[NSUserDefaults standardUserDefaults] valueForKey:kAEUserBuyedSomethingKey] boolValue];
                
                if (!userBoughtItems) {
                    [self requestInterstitialAdPresentation];
                }
                break;
            }
            case AESceneHangar:
            case AESceneGame:
                [self hideADDS];
                
                break;
            default:
                break;
        }
    }
    
}

@end
