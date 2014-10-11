//
//  SetCardGame.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/11/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "SetCardGame.h"
#import "SetCard.h"
#import "SetCardDeck.h"


@implementation SetCardGame

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
    self.temp_score = 0;
    self.current_play_points = 0;
    return self;
}

- (void)threeCardMode:(Card *)card
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
                    int matchScore = [(SetCard *)card match:@[otherCard]];
                    if (matchScore) {
                        self.matched = YES;
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
            
            card.chosen = YES;
        }
        [self printPlay:card current:currentPlay];
        
    }
    
}

@end
