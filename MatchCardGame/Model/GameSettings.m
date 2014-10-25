//
//  GameSettings.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/25/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "GameSettings.h"

@interface GameSettings()


@end

@implementation GameSettings

- (id)init
{
    self = [super init];
    if (self) {
        self.mismatch_penalty = 2;
        self.match_bonus = 4;
        self.triple_bonus = 2.5;
        self.cost_to_choose = 1;
        self.set_match_bonus = 10;
    }
    return self;
}

+ (GameSettings *)instance
{
    static GameSettings *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[GameSettings alloc] init]; });
    return instance;
}

@end
