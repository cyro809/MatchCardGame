//
//  CardGameViewController.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 8/29/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardGameViewController : UIViewController

@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSDate *gameStartTime;
@property (nonatomic, strong) NSDate *gameFinishTime;
@property (nonatomic) BOOL start;
@property (nonatomic) NSUserDefaults *gameRecord;

@end
