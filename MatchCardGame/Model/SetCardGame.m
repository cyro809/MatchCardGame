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
@interface SetCardGame()
@property (nonatomic, readwrite) NSUInteger score;
@end

@implementation SetCardGame

- (NSMutableArray *)cardsChosen
{
    if (!_cardsChosen) {
        _cardsChosen = [[NSMutableArray alloc] init];
    }
    return _cardsChosen;
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
    self.numCards = 3;
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
            
            [self.cardsChosen removeObject:card];
            
            currentPlay = [NSString stringWithFormat:@"%@", card.contents];
            
            [self.lastPlays insertObject:currentPlay atIndex:0];
        }
        else {
            card.chosen = YES;
            [self.cardsChosen addObject:card];
            // match against other chosen cards
            self.score--;
            
            
            if (self.numCardsChosen >= self.numCards) {
                NSLog(@"Three Cards Chosen");
                NSLog(@"Chosen cards count %d",[self.cardsChosen count]);
                
                Card *card01 = self.cardsChosen[0];
                Card *card02 = self.cardsChosen[1];
                Card *card03 = self.cardsChosen[2];
                
                if([(SetCard *)card01 match:@[card02,card03]] != 0 && [(SetCard *)card02 match:@[card01,card03]] != 0 && [(SetCard *)card03 match:@[card01,card02]] != 0) {
                    NSLog(@"MATCHED!!");
                    
                    self.matched = YES;
                    
                    self.score += 10;
                }
                else self.matched = NO;
            
                for (Card *otherCard in self.cards) {
                    if(self.matched && otherCard.isChosen) {
                        otherCard.matched = YES;
                    }
                }
                
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen) otherCard.chosen = NO;
                }
                
                [self.cardsChosen removeAllObjects];
                
                self.numCardsChosen = 0;
            }
            
        }
        
        [self printPlay:card current:currentPlay];
    }
    
}

@end
