//
//  GameRecords.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/25/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "GameRecords.h"

@implementation GameRecords

-(id)init
{
    self = [super init];
    if(self) {
        self.allRecords = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (GameRecords *)instance
{
    static GameRecords *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[GameRecords alloc] init]; });
    return instance;
}

- (void)saveCurrentGame:(NSDictionary *)gameData
{
    [self.allRecords addObject:gameData];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.allRecords forKey:@"allRecords"];
    [userDefaults synchronize];
}

@end
