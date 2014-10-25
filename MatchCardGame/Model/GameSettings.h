//
//  GameSettings.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/25/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (nonatomic) int mismatch_penalty;
@property (nonatomic) int match_bonus;
@property (nonatomic) int triple_bonus;
@property (nonatomic) int cost_to_choose;
@property (nonatomic) int set_match_bonus;

+ (GameSettings *)instance;
@end
