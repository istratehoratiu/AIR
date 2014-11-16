//
//  PPHangar.m
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 22/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEHangarScene.h"
#import "AEButtonNode.h"
#import "AEGameOverScene.h"
#import "AEMenuScene.h"
#import "AEShopItem.h"
#import "PPConstants.h"
#import "AEHangarItemSprite.h"
#import "NSObject+Additions.h"
#import "AEAppDelegate.h"
#import "AEGameManager.h"
#import "RageIAPHelper.h"


#define SHOP_ITEMS_DISTANCE 30

@implementation AEHangarScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // At first display the airplanes.
        _hangarItemsDisplayed = AEHangarItemsCredits;
        
        [[AEGameManager sharedManager] setCurrentScene:AESceneHangar];
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        background.blendMode = SKBlendModeReplace;
        [self addChild:background];
        
        //CGRectMake(0.0, self.size.height - (self.size.height * 0.25), self.size.width, self.size.height * 0.5)
        _airplaneScrollingStrip = [SKNode node];
        _airplaneScrollingStrip.position = CGPointZero;//center
        [_airplaneScrollingStrip setName:@"background"];
        //[_airplaneScrollingStrip setAnchorPoint:CGPointZero];

        [self addChild:_airplaneScrollingStrip];
        
        _backButton =  [[AEButtonNode alloc] initWithImageNamedNormal:@"backArrow" selected:@"backArrowPressed" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
        [_backButton setPosition:CGPointMake(_backButton.size.width * 0.5 + 10, size.height - 50)];
        [_backButton setTouchUpInsideTarget:self action:@selector(backButtonPressed)];
        _backButton.zPosition = 1000;
        [self addChild:_backButton];
        
        _restoreButton =  [[AEButtonNode alloc] initWithImageNamedNormal:@"restoreButton" selected:@"restoreButtonPressed" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
        [_restoreButton setPosition:CGPointMake(_backButton.position.x + _backButton.size.width * 0.5 + 500, size.height - 50)];
        [_restoreButton setTouchUpInsideTarget:self action:@selector(restorePurchases)];
        _restoreButton.zPosition = 1000;
        [_restoreButton.title setText:@"Restore"];
        //[self addChild:_restoreButton];
        
        NSString *credits = [[[NSUserDefaults standardUserDefaults] valueForKey:kAETotalScoreKey] stringValue];
        
        _changeDisplayedItemsButton =  [[AEButtonNode alloc] initWithImageNamedNormal:@"missileBackgroundButton" selected:@"missileBackgroundButtonPressed" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
        [_changeDisplayedItemsButton.title setFontName:@"Chalkduster"];
        [_changeDisplayedItemsButton.title setFontSize:40.0];
        [_changeDisplayedItemsButton.title setFontColor:[UIColor darkGrayColor]];
        [_changeDisplayedItemsButton.title setText:credits];
        [_changeDisplayedItemsButton.title setPosition:CGPointZero];
        [_changeDisplayedItemsButton setPosition:CGPointMake(self.size.width - 150, size.height - 50)];
        [_changeDisplayedItemsButton setTouchUpInsideTarget:self action:@selector(changeDisplayedItemsButtonPressed)];
        _changeDisplayedItemsButton.zPosition = 1000;
        [self addChild:_changeDisplayedItemsButton];
        
        // Populate the dictionary with the itemSHopt items.
        //NSString *hangarItemsTrailsAirplanesPlistPath = [[NSBundle mainBundle] pathForResource:@"hangarItemsAirplanes" ofType:@"plist"];
        
        NSString *hangarItemsTrailsPlistPath = [[NSBundle mainBundle] pathForResource:@"hangarItemsTrails" ofType:@"plist"];
        _trailsShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:hangarItemsTrailsPlistPath];
        
        NSString *hangarItemsCreditsPlistPath = [[NSBundle mainBundle] pathForResource:@"hangarItemsCredits" ofType:@"plist"];
        _creditsShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:hangarItemsCreditsPlistPath];
        
        _hintLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [_hintLabel setFontSize:20];
        [_hintLabel setText:@"* Aquiring any missile pack will remove the in-game Ads!"];
        [_hintLabel setPosition:CGPointMake((self.size.width * 0.5), 50)];
        [self addChild:_hintLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreen:) name:kSGUpdateHangarScreenNotification object:nil];
        
        [self changeDisplayedItemsForType:AEHangarItemsAirplanes];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)update:(CFTimeInterval)currentTime {
    for (SKSpriteNode *childSprite in _airplaneScrollingStrip.children) {
        
        CGPoint positionInMainView = [_airplaneScrollingStrip.parent convertPoint:childSprite.position fromNode:_airplaneScrollingStrip];
       
        CGFloat distanceFromCenter = self.size.width * 0.5 - positionInMainView.x;
        distanceFromCenter = (distanceFromCenter < 0) ? (distanceFromCenter * -1) : distanceFromCenter;
    }
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    
    [[self view] addGestureRecognizer:gestureRecognizer];
}

- (void)willMoveFromView:(SKView *)view {
    
    if (self.view.gestureRecognizers && ([self.view.gestureRecognizers count] > 0)) {
        for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
            [[self view] removeGestureRecognizer:gestureRecognizer];
        }
    }
}

- (void)handleTouchFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        
        touchLocation = [self convertPointFromView:touchLocation];
        
        if ([[self nodeAtPoint:touchLocation] isKindOfClass:[AEButtonNode class]]) {
        }
    }
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        
        touchLocation = [self convertPointFromView:touchLocation];
        
        //[self selectNodeForTouch:touchLocation];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if (_changeDisplayedItemsButton.isSelected) {
            [_changeDisplayedItemsButton setIsSelected:NO];
        }
        
        if (_restoreButton.isSelected) {
            [_restoreButton setIsSelected:NO];
        }
        
        if (_backButton.isSelected) {
            [_backButton setIsSelected:NO];
        }
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        
        CGPoint newPos = CGPointMake(_airplaneScrollingStrip.position.x + translation.x, _airplaneScrollingStrip.position.y + translation.y);
        
        
        if (newPos.x > _leftMarginOFHangarScrollView) {

            newPos = CGPointMake(_leftMarginOFHangarScrollView, newPos.y);
        
        } else if (newPos.x + _rightMarginOFHangarScrollView < self.size.width) {

            newPos = CGPointMake(self.size.width - _rightMarginOFHangarScrollView, newPos.y);
         
        }
    
        [_airplaneScrollingStrip setPosition:CGPointMake(newPos.x, _airplaneScrollingStrip.position.y)];
        
        [recognizer setTranslation:CGPointZero inView:recognizer.view];

    } else if (recognizer.state == UIGestureRecognizerStateEnded) {

        float scrollDuration = 0.2;
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        CGPoint pos = [_airplaneScrollingStrip position];
        CGPoint p = mult(velocity, scrollDuration);
        
        CGPoint newPos = CGPointMake(pos.x + p.x, _airplaneScrollingStrip.position.y);
        //newPos = [self boundLayerPos:newPos];
        [_airplaneScrollingStrip removeAllActions];
        
        
        if (newPos.x > _leftMarginOFHangarScrollView) {
            
            newPos = CGPointMake(_leftMarginOFHangarScrollView, newPos.y);
            
        }
        else if (newPos.x + _rightMarginOFHangarScrollView < self.size.width) {
            
            newPos = CGPointMake(self.size.width - _rightMarginOFHangarScrollView, newPos.y);
            
        }
        
        SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
        [moveTo setTimingMode:SKActionTimingEaseOut];
        [_airplaneScrollingStrip runAction:moveTo];
    }
}


#pragma mark - Button Callbacks -

- (void)restorePurchases {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)backButtonPressed {
    
    [self runAction:[SKAction playSoundFileNamed:@"Click.mp3" waitForCompletion:NO]];
    
    if (_hangarItemsDisplayed ==  AEHangarItemsCredits) {
        [self changeDisplayedItemsButtonPressed];
    } else {
    
        SKTransition *crossFade = [SKTransition fadeWithDuration:1];

        SKScene *newScene = nil;
        
        if (_score > 0) {
            newScene = [[AEGameOverScene alloc] initWithSize: self.size score:_score];
        } else {
            newScene = [[AEMenuScene alloc] initWithSize: self.size];
        }
        
    //  Optionally, insert code to configure the new scene.
        [self.scene.view presentScene: newScene transition: crossFade];
    }
}

- (void)changeDisplayedItemsForType:(AEHangarItems)itemTypes {
    // If the user swtiched between the different Hangar screens, reset the scrollview.
    if (itemTypes != _hangarItemsDisplayed) {
        _airplaneScrollingStrip.position = CGPointZero;
    }
    
    // Update the button and the current displayed items.
    _hangarItemsDisplayed = itemTypes;
    
    [_hintLabel setHidden:!(_hangarItemsDisplayed == AEHangarItemsCredits)];
    [_restoreButton setHidden:!(_hangarItemsDisplayed == AEHangarItemsCredits)];
    
    NSString *credits = [[[NSUserDefaults standardUserDefaults] valueForKey:kAETotalScoreKey] stringValue];
    [_changeDisplayedItemsButton.title setText:credits];
//    [_changeDisplayedItemsButton.title setText:(_hangarItemsDisplayed == AEHangarItemsCredits) ? @"" : credits];
//    
//    SKTexture *displayedItemsNormalButtonTexture = (_hangarItemsDisplayed == AEHangarItemsCredits) ? [SKTexture textureWithImageNamed:@"airplaneButtonBackground"] : [SKTexture textureWithImageNamed:@"missileBackgroundButton"];
//    SKTexture *displayedItemsSelectedButtonTexture = (_hangarItemsDisplayed == AEHangarItemsCredits) ? [SKTexture textureWithImageNamed:@"airplaneButtonBackground"] : [SKTexture textureWithImageNamed:@"missileBackgroundButton"];
//    
//    [_changeDisplayedItemsButton setNormalTexture:displayedItemsNormalButtonTexture];
//    [_changeDisplayedItemsButton setSelectedTexture:displayedItemsSelectedButtonTexture];
//    [_changeDisplayedItemsButton setTexture:displayedItemsNormalButtonTexture];
    
    _shopItemsDictionary = (_hangarItemsDisplayed == AEHangarItemsCredits) ? [NSMutableDictionary dictionaryWithContentsOfFile:[[self appDelegate] creditsPlistPath]]  : [NSMutableDictionary dictionaryWithContentsOfFile:[[self appDelegate] airplanePListPath]];
    
    [_airplaneScrollingStrip removeAllChildren];
    
    CGFloat xPositionOfLastShopItem = 0;
    
    for(int i = 0; i < [[_shopItemsDictionary allKeys] count]; ++i) {

        AEShopItem *currentItem = [[AEShopItem alloc] initWithDictionary:[_shopItemsDictionary objectForKey:[NSString stringWithFormat:@"%i", i]]];
        [currentItem setKeyValue:[NSString stringWithFormat:@"%i", i]];
        
        AEHangarItemSprite *shopItem = [[AEHangarItemSprite alloc] init];
        [shopItem setShopItemType:_hangarItemsDisplayed];
        [shopItem setShopItem:currentItem];

        if (i == 0) {
            [shopItem setPosition:CGPointMake(shopItem.size.width / 2 + SHOP_ITEMS_DISTANCE, self.size.height / 2)];
            xPositionOfLastShopItem = shopItem.position.x + shopItem.size.width;
        } else {
            [shopItem setPosition:CGPointMake(xPositionOfLastShopItem + SHOP_ITEMS_DISTANCE, self.size.height / 2)];
            xPositionOfLastShopItem = shopItem.position.x + shopItem.size.width;
        }
        
        [_airplaneScrollingStrip addChild:shopItem];
    
        if (i == 0) {
            _leftMarginOFHangarScrollView = shopItem.position.x - (shopItem.size.width * 0.5) - SHOP_ITEMS_DISTANCE;
        } else if ( i == [[_shopItemsDictionary allKeys] count] - 1) {
            _rightMarginOFHangarScrollView = shopItem.position.x + (shopItem.size.width * 0.5) + SHOP_ITEMS_DISTANCE;
        }
    }
}

- (void)changeDisplayedItemsButtonPressed {
    [self runAction:[SKAction playSoundFileNamed:@"Click.mp3" waitForCompletion:NO]];
    //_hangarItemsDisplayed = (_hangarItemsDisplayed == AEHangarItemsAirplanes) ? AEHangarItemsCredits : AEHangarItemsAirplanes;
    if (self.appDelegate.internetIsReachable) {
        [self changeDisplayedItemsForType:((_hangarItemsDisplayed == AEHangarItemsAirplanes) ? AEHangarItemsCredits : AEHangarItemsAirplanes)];
    } else {
        UIAlertView *internetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet!" message:@"Please enable Internet access." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [internetAlert show];
    }
}


#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self changeDisplayedItemsButtonPressed];
    }
}

#pragma mark - Helper Methods -

CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}


#pragma mark - Notification Callbacks -

- (void)updateScreen:(NSNotification *)notif {
    //[self performSelector:@selector(airplanesButton) withObject:nil afterDelay:3];
    [self changeDisplayedItemsForType:_hangarItemsDisplayed];
}



@end
