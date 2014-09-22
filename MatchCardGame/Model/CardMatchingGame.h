//
//  CardMatchingGame.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 8/30/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject
//designated initializer
- (instancetype) initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck;

- (void) chooseCardAtIndex:(NSUInteger) index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void) twoCardMode:(Card *)card;
- (void) threeCardMode:(Card *)card;
- (void) printPlay:(Card *)card current:(NSString *)currentPlay;
@property (nonatomic, readonly) NSUInteger score;

@property (nonatomic) int numCards;
@property (nonatomic) int numCardsChosen;
@property (nonatomic) BOOL gameStart;
@property (nonatomic, strong) NSMutableArray *lastPlays;

@end
