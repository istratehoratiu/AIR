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

#define ADDBannerWidth 320
#define ADDBannerHeight 50

@interface 	AEViewController () <ADBannerViewDelegate>

@property (nonatomic, assign) BOOL addBannerIsHidden;
@property (nonatomic, strong) ADBannerView *banner;

@end

@implementation AEViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        _banner = [[ADBannerView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - _banner.frame.size.width) * 0.5, 0, -_banner.frame.size.width, _banner.frame.size.height)];
        _banner.delegate = self;
        //[_banner setFrame:CGRectMake((self.view.bounds.size.width - _banner.frame.size.width) * 0.5, 0, -_banner.frame.size.width, _banner.frame.size.height)];
        _addBannerIsHidden = YES;
        
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
    if (_addBannerIsHidden) {
        
        SKView * skView = (SKView *)self.view;
        if (
            [skView.scene isKindOfClass:[AEGameScene class]]) {
            return;
        }
        
        [self.view addSubview:_banner];
        
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
        [_banner setFrame:CGRectMake((self.view.bounds.size.width - _banner.frame.size.width) * 0.5, 0, -_banner.frame.size.width, _banner.frame.size.height)];
        
        _addBannerIsHidden = YES;
        
        [UIView commitAnimations];
    }
}

@end
