//
//  SetCardGame.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/11/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "CardMatchingGame.h"

@interface SetCardGame : CardMatchingGame
- (instancetype) initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck;
@property (nonatomic, strong) NSMutableArray *cards; //of cards

@property (nonatomic, strong) NSMutableArray *cardsChosen;

@end
