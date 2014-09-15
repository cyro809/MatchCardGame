//
//  CardMatchingGame.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 8/30/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSUInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of cards
@property (nonatomic) BOOL matched;
@end


@implementation CardMatchingGame

@synthesize lastPlays = _lastPlays;

- (NSMutableArray*) lastPlays
{
    if (!_lastPlays)
    {
        _lastPlays = [[NSMutableArray alloc] init];
    }
    return _lastPlays;
}


- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; //super's designated initializer
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
    }
    self.numCards = 2;
    self.numCardsChosen = 0;
    return self;
}


@synthesize numCardsChosen = _numCardsChosen;

- (void) setNumCardsChosen:(int)numCardsChosen
{
    _numCardsChosen = numCardsChosen;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int TRIPLE_BONUS = 0.5;
static const int COST_TO_CHOOSE = 1;
- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}


- (void) twoCardMode:(Card *) card
{
    NSString *currentPlay;
    if(!card.isMatched) {
        if(card.isChosen) {
            card.chosen = NO;
            currentPlay = [NSString stringWithFormat:@"%@", card.contents];
            NSLog(@"%@",currentPlay);
        }
        else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if(otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                        self.numCardsChosen = 0;
                        currentPlay = [NSString stringWithFormat:@"Matched %@ %@", card.contents, otherCard.contents];
                        NSLog(@"%@",currentPlay);
                        [self.lastPlays addObject:currentPlay];
                        NSLog(@"%@", [self.lastPlays objectAtIndex:0]);
                    }
                    else {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                        self.numCardsChosen = 0;
                        currentPlay = [NSString stringWithFormat:@"%@ %@ don't match", card.contents, otherCard.contents];
                        NSLog(@"%@",currentPlay);
                    }
                    break; // can only choose 2 card for now
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (void) threeCardMode:(Card *) card
{
    NSString *currentPlay = @"";
    NSLog(@"Num Cards Chosen: %d and Num Cards: %d", self.numCardsChosen, self.numCards);
    if(!card.isMatched) {
        if(card.isChosen) {
            card.chosen = NO;
            currentPlay = [NSString stringWithFormat:@"%@", card.contents];
            NSLog(@"%@",currentPlay);
        }
        else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if(otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.matched = YES;
                        self.score += matchScore * MATCH_BONUS * TRIPLE_BONUS;
                    }
                }
                
                else if(!self.matched && otherCard.isChosen){
                    NSLog(@"No match and card is chosen");
                    card.chosen = NO;
                    otherCard.chosen = NO;
                }
                if(self.matched){
                    self.matched = YES;
                }
                else {
                    self.matched = NO;
                }
                
            }
            for (Card *otherCard in self.cards) {
                if(self.matched && otherCard.isChosen && self.numCardsChosen == self.numCards){
                    card.matched = YES;
                    otherCard.matched = YES;
                    currentPlay = [NSString stringWithFormat:@"%@ %@",otherCard.contents, currentPlay];
                }
                else if(!self.matched && self.numCardsChosen == self.numCards && otherCard.isChosen){
                    card.chosen = NO;
                    otherCard.chosen = NO;
                    currentPlay = [NSString stringWithFormat:@"%@ %@",otherCard.contents, currentPlay];
                    //self.numCardsChosen = 0;
                }
            }
            if (self.numCardsChosen >= self.numCards) {
                self.matched = NO;
                self.numCardsChosen = 1;
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
        if(card.isMatched)
        {
            //Pegar e juntar as cartas na string currentPlay
            currentPlay = [NSString stringWithFormat:@"%@ %@", currentPlay, card.contents];
            
            //Juntar matched com a string das cartas
            currentPlay = [NSString stringWithFormat:@"Matched %@", currentPlay];
        }
        else
        {
            currentPlay = [NSString stringWithFormat:@"%@ %@", currentPlay, card.contents];
            
            //Juntar matched com a string das cartas
            currentPlay = [NSString stringWithFormat:@"%@ don't match", currentPlay];
        }
        NSLog(@"%@", currentPlay);
    }
}

- (void) chooseCardAtIndex:(NSUInteger)index
{
    self.gameStart = YES;
    Card *card = [self cardAtIndex:index];
    if(card.isChosen){
        self.numCardsChosen--;
    }
    else{
        self.numCardsChosen++;
    }
    if(self.numCards == 2) {
        [self twoCardMode:card];
    }
    else {
        [self threeCardMode:card];
    }
    
    
}

@end
