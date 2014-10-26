//
//  SetCardGameViewController.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameViewController.h"
#import "SetCardGame.h"

@interface SetCardGameViewController : CardGameViewController
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSDate *gameStartTime;
@property (nonatomic, strong) NSDate *gameFinishTime;
@property (nonatomic) BOOL start;
@property (nonatomic) NSUserDefaults *gameRecord;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) SetCardGame *game;

@end
