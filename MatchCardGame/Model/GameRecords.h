//
//  GameRecords.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/25/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameRecords : NSObject

+ (GameRecords *) instance;
- (void)saveCurrentGame:(NSDictionary *)gameData;
@property (nonatomic, strong) NSMutableArray *allRecords;


@end
