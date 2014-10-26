//
//  TwoPlayersSetCardGameViewController.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/25/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "TwoPlayersSetCardGameViewController.h"
#import "GameSettings.h"

@interface TwoPlayersSetCardGameViewController ()
@property (nonatomic, strong) NSMutableArray *playersScores;
@property (nonatomic) NSUInteger currentPlayer;

@end

@implementation TwoPlayersSetCardGameViewController

-(NSMutableArray *)playerScores
{
    if (!_playersScores) {
        _playersScores = [NSMutableArray arrayWithArray:@[@0,@0]];
    }
    return _playersScores;
}
- (IBAction)touchReDealButton:(UIButton *)sender {
    self.playersScores = nil;
    self.currentPlayer = 0;
    [super touchReDealButton:sender];
    self.scoreLabel.text = @"P1: 0  P2: 0";
}

- (void)calculateScores
{
    int otherPlayer = (self.currentPlayer +1) % 2;
    int newScore = self.game.score - [self.playersScores[otherPlayer] integerValue];
    
    if ((newScore + [GameSettings instance].cost_to_choose < [self.playerScores[self.currentPlayer] integerValue])
        || self.game.end_of_play) {
        self.playerScores[self.currentPlayer] = @(newScore);
        self.currentPlayer = otherPlayer;
        self.game.end_of_play = NO;
    } else {
        self.playerScores[self.currentPlayer] = @(newScore);
    }
}

- (void)updateUI
{
    [super updateUI];
    [self calculateScores];
    
    NSString *text = [NSString stringWithFormat:@"P1: %@  P2: %@",
                      self.playerScores[0], self.playerScores[1]];
    
    self.scoreLabel.text = text;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameType = @"SET GAME";
    self.scoreLabel.text = @"P1: 0  P2: 0";
    // Do any additional setup after loading the view.
}



@end
