//
//  SetCardGameViewController.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameViewController.h"

@interface SetCardGameViewController : CardGameViewController
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSDate *gameStart;
@property (nonatomic, strong) NSDate *gameFinish;
@property (nonatomic) BOOL start;
@end
