//
//  AEGameOverStatisticsSprite.m
//  AirEscape
//
//  Created by Horatiu Istrate on 24/06/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEGameOverStatisticsSprite.h"
#import "PPConstants.h"


@implementation AEGameOverStatisticsSprite


- (id)initGameOverSceneWithScore:(NSInteger)currentScore {
    self = [super initWithImageNamed:@"gameOverMenuBackground.png"];
    
    if (self) {
        
        NSInteger currentBestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kSGBestScoreKey];
        BOOL newScoreIsTheBest = currentScore > currentBestScore;
        
        //----------- Current Score
        
        SKLabelNode *currentScoreText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [currentScoreText setFontSize:40];
        [currentScoreText setText:@"Score"];
        [currentScoreText setPosition:CGPointMake(-150, self.size.height - 180)];
        [self addChild:currentScoreText];
        
        SKLabelNode *currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [currentScoreLabel setFontSize:40];
        [currentScoreLabel setText:[NSString stringWithFormat:@"%ld", (long)currentScore]];
        [currentScoreLabel setPosition:CGPointMake(-150, self.size.height - 240)];
        [self addChild:currentScoreLabel];
        
        //----------- Best Score
        
        SKLabelNode *bestScoreText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [bestScoreText setFontSize:40];
        [bestScoreText setText:newScoreIsTheBest ? @"New Best" : @"Best"];
        [bestScoreText setPosition:CGPointMake(0, self.size.height - 180)];
        [self addChild:bestScoreText];
        
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [bestScoreLabel setFontSize:40];
        [bestScoreLabel setText:[NSString stringWithFormat:@"%ld", newScoreIsTheBest ? (long)currentScore : (long)currentBestScore]];
        [bestScoreLabel setPosition:CGPointMake(0, self.size.height - 240)];
        [self addChild:bestScoreLabel];
        
        if (newScoreIsTheBest) {
            [[NSUserDefaults standardUserDefaults] setInteger:currentScore forKey:kSGBestScoreKey];
        }
        
        
        //----------- Total Score
        SKLabelNode *totalScoreText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [totalScoreText setFontSize:40];
        [totalScoreText setText: @"Total"];
        [totalScoreText setPosition:CGPointMake(150, self.size.height - 180)];
        [self addChild:totalScoreText];
        
        NSInteger currentTotalScore = [[NSUserDefaults standardUserDefaults] integerForKey:kAETotalScoreKey];
        
        NSLog(@">>>>>>>> %ld + %ld", (long)currentTotalScore, (long)currentScore);
        currentTotalScore = currentTotalScore + currentScore;
        NSLog(@">>>>>>>> %ld", currentTotalScore);
        
        SKLabelNode *totalScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [totalScoreLabel setFontSize:40];
        [totalScoreLabel setText:[NSString stringWithFormat:@"%ld",currentTotalScore]];
        [totalScoreLabel setPosition:CGPointMake(150, self.size.height - 240)];
        [self addChild:totalScoreLabel];
        
        [[NSUserDefaults standardUserDefaults] setInteger:currentTotalScore forKey:kAETotalScoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return self;
}

@end
