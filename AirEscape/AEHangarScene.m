//
//  PPHangar.m
//  PaperPlane Fighting
//
//  Created by Horatiu Istrate on 22/03/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEHangarScene.h"
#import "SKButtonNode.h"
#import "AEGameOverScene.h"
#import "AEMenuScene.h"
#import "AEShopItem.h"
#import "PPConstants.h"
#import "AEHangarItemSprite.h"
#import "NSObject+Additions.h"
#import "AEAppDelegate.h"
#import "AEGameManager.h"


#define SHOP_ITEMS_DISTANCE 30

@implementation AEHangarScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
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
        
        SKButtonNode *backButton =  [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
        [backButton.title setFontName:@"Chalkduster"];
        [backButton.title setFontSize:40.0];
        [backButton.title setText:@"Back"];
        [backButton setPosition:CGPointMake(backButton.size.width * 0.5 + 10, size.height - 100)];
        [backButton setTouchUpInsideTarget:self action:@selector(backButton)];
        backButton.zPosition = 1000;
        [self addChild:backButton];
        
        SKButtonNode *airplanesButton =  [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
        [airplanesButton.title setFontName:@"Chalkduster"];
        [airplanesButton.title setFontSize:40.0];
        [airplanesButton.title setText:@"Airplane"];
        [airplanesButton setPosition:CGPointMake(airplanesButton.size.width * 0.5 + 210, size.height - 100)];
        [airplanesButton setTouchUpInsideTarget:self action:@selector(airplanesButton)];
        airplanesButton.zPosition = 1000;
        // Uncomment this to add Airplane tab in Hangar.
        //[self addChild:airplanesButton];
            
        SKButtonNode *getCreditsButton =  [[SKButtonNode alloc] initWithImageNamedNormal:@"transparentButton" selected:@"transparentButton" disabled:nil itleVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
        [getCreditsButton.title setFontName:@"Chalkduster"];
        [getCreditsButton.title setFontSize:40.0];
        [getCreditsButton.title setText:@"Credits"];
        [getCreditsButton setPosition:CGPointMake(self.size.width - 150, size.height - 100)];
        [getCreditsButton setTouchUpInsideTarget:self action:@selector(creditsButton)];
        getCreditsButton.zPosition = 1000;
        [self addChild:getCreditsButton];
        
        // Populate the dictionary with the itemSHopt items.
        //NSString *hangarItemsTrailsAirplanesPlistPath = [[NSBundle mainBundle] pathForResource:@"hangarItemsAirplanes" ofType:@"plist"];
        
        NSString *hangarItemsTrailsPlistPath = [[NSBundle mainBundle] pathForResource:@"hangarItemsTrails" ofType:@"plist"];
        _trailsShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:hangarItemsTrailsPlistPath];
        
        NSString *hangarItemsCreditsPlistPath = [[NSBundle mainBundle] pathForResource:@"hangarItemsCredits" ofType:@"plist"];
        _creditsShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:hangarItemsCreditsPlistPath];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreen:) name:kSGUpdateHangarScreenNotification object:nil];
        
        [self airplanesButton];
    }
    
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    for (SKSpriteNode *childSprite in _airplaneScrollingStrip.children) {
        
        CGPoint positionInMainView = [_airplaneScrollingStrip.parent convertPoint:childSprite.position fromNode:_airplaneScrollingStrip];
       
    
        CGFloat distanceFromCenter = self.size.width * 0.5 - positionInMainView.x;
        distanceFromCenter = (distanceFromCenter < 0) ? (distanceFromCenter * -1) : distanceFromCenter;
        
        //childSprite.scale = ((self.size.width * 0.5) - distanceFromCenter) / (self.size.width * 0.5) ;
        
        
        //NSLog(@">>>> %f %f >>>>>>> %f", positionInMainView.x, positionInMainView.y, (self.size.width * 0.5 - distanceFromCenter) / self.size.width * 0.5);
    }
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    
    [[self view] addGestureRecognizer:gestureRecognizer];
}

- (void)handleTouchFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        
        touchLocation = [self convertPointFromView:touchLocation];
        
        if ([[self nodeAtPoint:touchLocation] isKindOfClass:[SKButtonNode class]]) {
            NSLog(@"asdasdasdasdas");
        }
    }
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        
        touchLocation = [self convertPointFromView:touchLocation];
        
        //[self selectNodeForTouch:touchLocation];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        
        CGPoint newPos = CGPointMake(_airplaneScrollingStrip.position.x + translation.x, _airplaneScrollingStrip.position.y + translation.y);
        
        
        if (newPos.x > _leftMarginOFHangarScrollView) {

            newPos = CGPointMake(_leftMarginOFHangarScrollView, newPos.y);
        
        }
        else if (newPos.x + _rightMarginOFHangarScrollView < self.size.width) {

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

- (void)backButton {
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

- (void)creditsButton {
    
    [_airplaneScrollingStrip removeAllChildren];
    
    for(int i = 0; i < [[_airplanesShopItemsDictionary allKeys] count]; ++i) {
        
        AEShopItem *currentItem = [[AEShopItem alloc] initWithDictionary:[_airplanesShopItemsDictionary objectForKey:[NSString stringWithFormat:@"%i", i]]];
        [currentItem setKeyValue:[NSString stringWithFormat:@"%i", i]];
        
        AEHangarItemSprite *shopItem = [[AEHangarItemSprite alloc] init];
        [shopItem setShopItem:currentItem];
        
        [shopItem setPosition:CGPointMake(i * shopItem.size.width + SHOP_ITEMS_DISTANCE, self.size.height / 2)];
        [_airplaneScrollingStrip addChild:shopItem];
        
        if (i == 0) {
            _leftMarginOFHangarScrollView = shopItem.position.x;
        } else if ( i == [[_airplanesShopItemsDictionary allKeys] count] - 1) {
            _rightMarginOFHangarScrollView = shopItem.position.x;
        }
    }
}

- (void)airplanesButton {
    
    _airplanesShopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[self appDelegate] airplanePListPath]];
    
    [_airplaneScrollingStrip removeAllChildren];
    
    CGFloat xPositionOfLastShopItem = 0;
    
    for(int i = 0; i < [[_airplanesShopItemsDictionary allKeys] count]; ++i) {

        AEShopItem *currentItem = [[AEShopItem alloc] initWithDictionary:[_airplanesShopItemsDictionary objectForKey:[NSString stringWithFormat:@"%i", i]]];
        [currentItem setKeyValue:[NSString stringWithFormat:@"%i", i]];
        
        AEHangarItemSprite *shopItem = [[AEHangarItemSprite alloc] init];
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
        } else if ( i == [[_airplanesShopItemsDictionary allKeys] count] - 1) {
            _rightMarginOFHangarScrollView = shopItem.position.x + (shopItem.size.width * 0.5) + SHOP_ITEMS_DISTANCE;
        }
    }
}

- (void)enginesButton {
    
    [_airplaneScrollingStrip removeAllChildren];
    
    for(int i = 0; i < [[_airplanesShopItemsDictionary allKeys] count]; ++i) {
        
        AEShopItem *currentItem = [[AEShopItem alloc] initWithDictionary:[_airplanesShopItemsDictionary objectForKey:[NSString stringWithFormat:@"%i", i]]];
        AEHangarItemSprite *shopItem = [[AEHangarItemSprite alloc] init];
        [shopItem setShopItem:currentItem];
        
        [shopItem setPosition:CGPointMake(i * shopItem.size.width + SHOP_ITEMS_DISTANCE, self.size.height / 2)];
        [_airplaneScrollingStrip addChild:shopItem];
        
        if (i == 0) {
            _leftMarginOFHangarScrollView = shopItem.position.x;
        } else if ( i == [[_airplanesShopItemsDictionary allKeys] count] - 1) {
            _rightMarginOFHangarScrollView = shopItem.position.x;
        }
    }
}


#pragma mark - Helper Methods -

CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}


#pragma mark - Notification Callbacks -

- (void)updateScreen:(NSNotification *)notif {
    //[self performSelector:@selector(airplanesButton) withObject:nil afterDelay:3];
    [self airplanesButton];
}



@end
