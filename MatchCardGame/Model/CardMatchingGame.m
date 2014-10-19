//
//  CardMatchingGame.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 8/30/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSUInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of cards
@property (nonatomic, strong) Deck *deck;

@end


@implementation CardMatchingGame

- (NSUInteger)numCardsDealed {
    return [self.cards count];
}

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

- (void)drawNewCard
{
    Card *card = [self.deck drawRandomCard];
    
    if(card) {
        [self.cards addObject:card];
    }
}

- (BOOL)isDeckEmpty
{
    if ([self.deck isEmpty]) return YES;
    return NO;
}

- (instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; //super's designated initializer
    
    if (self) {
        _deck = deck;
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
    self.temp_score = 0;
    self.current_play_points = 0;
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int TRIPLE_BONUS = 2.5;
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
            [self.lastPlays insertObject:currentPlay atIndex:0];
        }
        else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if(otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.current_play_points = matchScore * MATCH_BONUS;
                        self.score += self.current_play_points;
                        otherCard.matched = YES;
                        card.matched = YES;
                        self.numCardsChosen = 0;
                        currentPlay = [NSString stringWithFormat:@"Matched %@ %@ for %d points", card.contents, otherCard.contents, self.current_play_points];
                        self.current_play_points = 0;
                        [self.lastPlays insertObject:currentPlay atIndex:0];
                    }
                    else {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                        self.numCardsChosen = 0;
                        currentPlay = [NSString stringWithFormat:@"%@ %@ don't match", card.contents, otherCard.contents];
                        [self.lastPlays insertObject:currentPlay atIndex:0];
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
    if(!card.isMatched) {
        if(card.isChosen) {
            card.chosen = NO;
            currentPlay = [NSString stringWithFormat:@"%@", card.contents];
            [self.lastPlays insertObject:currentPlay atIndex:0];
        }
        else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if(otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.matched = YES;
                        self.current_play_points = matchScore * MATCH_BONUS * TRIPLE_BONUS;
                        self.temp_score += self.current_play_points;
                    }
                }
                
                else if(!self.matched && otherCard.isChosen){
                    card.chosen = NO;
                    otherCard.chosen = NO;
                }
                
                //garantia de que caso eu tenha combinado um par e a proxima nao seja uma combinação o atributo matched continue YES até o fim da jogada
                if(self.matched){
                    self.matched = YES;
                }
                else {
                    self.matched = NO;
                }
            }
            // Cofere quais cartas foram escolhidas e quais foram combinadas
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
                }
            }
            // Se foram selecionadas 3 ou mais cartas:
            //     Se houve combinação o numero de cartas escolhidas vai pra zero.
            //     Se não, a ultima carta continua escolhida permanece virada
            if (self.numCardsChosen >= self.numCards) {
                if(self.matched) self.numCardsChosen = 0;
                else self.numCardsChosen = 1;
                self.matched = NO;
                self.end_of_play = YES;
                
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
        [self printPlay:card current:currentPlay];
        
    }
}



- (void) printPlay:(Card *)card current:(NSString *)currentPlay
{
    if(card.isMatched && self.end_of_play)
    {
        //Pegar e juntar as cartas na string currentPlay
        currentPlay = [NSString stringWithFormat:@"%@ %@", currentPlay, card.contents];
        
        //Juntar matched com a string das cartas
        currentPlay = [NSString stringWithFormat:@"Matched %@ for %d points", currentPlay, self.current_play_points];
        [self.lastPlays insertObject:currentPlay atIndex:0];
        
        //atualizo o score somente no final da jogada
        self.score = self.temp_score;
        self.current_play_points = 0;
    }
    else if(!card.isMatched && self.end_of_play)
    {
        currentPlay = [NSString stringWithFormat:@"%@ %@", currentPlay, card.contents];
        
        //Juntar matched com a string das cartas
        currentPlay = [NSString stringWithFormat:@"%@ don't match", currentPlay];
        [self.lastPlays insertObject:currentPlay atIndex:0];
    }
}



- (void) chooseCardAtIndex:(NSUInteger)index
{
    self.gameStart = YES;
    Card *card = [self cardAtIndex:index];
    self.end_of_play = NO;
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
