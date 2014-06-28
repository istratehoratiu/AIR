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
        
        SKLabelNode *medalLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [medalLabel setFontSize:40];
        [medalLabel setText:@"Medal"];
        [medalLabel setPosition:CGPointMake(-(self.size.width * 0.5) + 20, self.size.height - 20)];
        [self addChild:medalLabel];
        
        NSString *medalImageName = @"";
        
        if (newScoreIsTheBest) {
            medalImageName = @"highMedal.png";
        } else if (currentBestScore - newScoreIsTheBest < 5) {
            medalImageName = @"mediumMedal.png";
        } else if (currentBestScore - newScoreIsTheBest < 10) {
             medalImageName = @"minimumMedal.png";
        }
        
        SKSpriteNode *medal = [SKSpriteNode spriteNodeWithImageNamed:medalImageName];
        [medal setPosition:CGPointMake(20, self.size.height - 110)];
        [self addChild:medal];
        
        //-----------
        
        SKLabelNode *currentScoreText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [currentScoreText setFontSize:40];
        [currentScoreText setText:@"Score"];
        [currentScoreText setPosition:CGPointMake(self.size.width - 100, self.size.height - 20)];
        [self addChild:currentScoreText];
        
        SKLabelNode *currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [currentScoreLabel setFontSize:40];
        [currentScoreLabel setText:[NSString stringWithFormat:@"%ld", (long)currentScore]];
        [currentScoreLabel setPosition:CGPointMake(self.size.width - 100, self.size.height - 110)];
        [self addChild:currentScoreLabel];
        
        //-----------
        
        SKLabelNode *bestScoreText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [bestScoreText setFontSize:40];
        [bestScoreText setText:newScoreIsTheBest ? @"New Best" : @"Best"];
        [bestScoreText setPosition:CGPointMake(self.size.width / 2, self.size.height - 100)];
        [self addChild:bestScoreText];
        
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [bestScoreLabel setFontSize:40];
        [bestScoreLabel setText:[NSString stringWithFormat:@"%ld", newScoreIsTheBest ? (long)currentScore : (long)currentBestScore]];
        [bestScoreLabel setPosition:CGPointMake(self.size.width / 2, self.size.height - 210)];
        [self addChild:bestScoreLabel];
        

        if (newScoreIsTheBest) {
            [[NSUserDefaults standardUserDefaults] setInteger:currentScore forKey:kSGBestScoreKey];
        }
    }
    
    return self;
}

@end
