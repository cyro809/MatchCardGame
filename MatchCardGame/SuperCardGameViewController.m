//
//  SuperCardGameViewController.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/18/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "SuperCardGameViewController.h"
#import "PlayingCardView.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "Grid.h"

@interface SuperCardGameViewController ()


@end

@implementation SuperCardGameViewController

- (Deck *)createDeck
{
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc] init];
}

- (UIView *)createViewForCard:(Card *)card
{
    PlayingCardView *view = [[PlayingCardView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    if (![card isKindOfClass:[PlayingCard class]]) return;
    if (![view isKindOfClass:[PlayingCardView class]]) return;
    
    PlayingCard *playingCard = (PlayingCard *)card;
    PlayingCardView *playingCardView = (PlayingCardView *)view;
    playingCardView.rank = playingCard.rank;
    playingCardView.suit = playingCard.suit;
    playingCardView.faceUp = playingCard.chosen;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberOfStartingCards = 35;
    self.maxCardSize = CGSizeMake(80.0, 120.0);
    [self updateUI];
}

@end
