//
//  AEGameOverStatisticsSprite.m
//  AirEscape
//
//  Created by Horatiu Istrate on 24/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEGameOverStatisticsSprite.h"
#import "PPConstants.h"
#import "ShadowLabelNode.h"


@implementation AEGameOverStatisticsSprite


- (id)initGameOverSceneWithScore:(NSInteger)currentScore {
    self = [super initWithImageNamed:@"gameOverMenuBackground.png"];
    
    if (self) {
        
        NSInteger currentBestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kSGBestScoreKey];
        BOOL newScoreIsTheBest = currentScore > currentBestScore;
        
        //----------- Game Over
        
        ShadowLabelNode *gameOverLabel = [[ShadowLabelNode alloc] initWithFontNamed:@"If"];
        gameOverLabel.text = @"Game Over";
        gameOverLabel.fontSize = 40;
        gameOverLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        gameOverLabel.position = CGPointMake(0, 50);
        gameOverLabel.zPosition = 1000;
        gameOverLabel.offset = CGPointMake(5, -5);
        [self addChild:gameOverLabel];
        
        //----------- Current Score
        
        SKLabelNode *currentScoreText = [SKLabelNode labelNodeWithFontNamed:@"If"];
        [currentScoreText setFontSize:40];
        currentScoreText.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [currentScoreText setText:@"Score"];
        [currentScoreText setPosition:CGPointMake(-200, self.size.height - 340)];
        [self addChild:currentScoreText];
        
        SKLabelNode *currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"If"];
        currentScoreLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [currentScoreLabel setFontSize:40];
        [currentScoreLabel setText:[NSString stringWithFormat:@"%ld", (long)currentScore]];
        [currentScoreLabel setPosition:CGPointMake(-200, self.size.height - 400)];
        [self addChild:currentScoreLabel];
        
        //----------- Best Score
        
        SKLabelNode *bestScoreText = [SKLabelNode labelNodeWithFontNamed:@"If"];
        bestScoreText.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [bestScoreText setFontSize:40];
        [bestScoreText setText:newScoreIsTheBest ? @"New Best" : @"Best"];
        [bestScoreText setFontColor:newScoreIsTheBest ? [UIColor redColor] : [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1]];
        [bestScoreText setPosition:CGPointMake(0, self.size.height - 340)];
        [self addChild:bestScoreText];
        
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"If"];
        bestScoreLabel.fontColor = newScoreIsTheBest ? [UIColor redColor] : [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [bestScoreLabel setFontSize:40];
        [bestScoreLabel setText:[NSString stringWithFormat:@"%ld", newScoreIsTheBest ? (long)currentScore : (long)currentBestScore]];
        [bestScoreLabel setPosition:CGPointMake(0, self.size.height - 400)];
        [self addChild:bestScoreLabel];
        
        if (newScoreIsTheBest) {
            [[NSUserDefaults standardUserDefaults] setInteger:currentScore forKey:kSGBestScoreKey];
        }
        
        
        //----------- Total Score
        SKLabelNode *totalScoreText = [SKLabelNode labelNodeWithFontNamed:@"If"];
        [totalScoreText setFontSize:40];
        [totalScoreText setText: @"Total"];
        totalScoreText.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [totalScoreText setPosition:CGPointMake(200, self.size.height - 340)];
        [self addChild:totalScoreText];
        
        NSInteger currentTotalScore = [[NSUserDefaults standardUserDefaults] integerForKey:kAETotalScoreKey];
        
        NSLog(@">>>>>>>> %ld + %ld", (long)currentTotalScore, (long)currentScore);
        currentTotalScore = currentTotalScore + currentScore;
        NSLog(@">>>>>>>> %ld", currentTotalScore);
        
        SKLabelNode *totalScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"If"];
        [totalScoreLabel setFontSize:40];
        totalScoreLabel.fontColor = [UIColor colorWithRed:(122.0 / 255.0) green:(255.0 / 255.0) blue:(35.0 / 255.0) alpha:1];
        [totalScoreLabel setText:[NSString stringWithFormat:@"%ld",currentTotalScore]];
        [totalScoreLabel setPosition:CGPointMake(200, self.size.height - 400)];
        [self addChild:totalScoreLabel];
        
        [[NSUserDefaults standardUserDefaults] setInteger:currentTotalScore forKey:kAETotalScoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return self;
}

@end
