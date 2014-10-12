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
            
            currentPlay = [NSString stringWithFormat:@"%@", card.contents];
            
            [self.lastPlays insertObject:currentPlay atIndex:0];
        }
        else {
            card.chosen = YES;
            // match against other chosen cards
            if (self.numCardsChosen >= self.numCards) {
                NSLog(@"Three Cards Chosen");
                
                for (Card *otherCard in self.cards) {
                    
                    if (otherCard.isChosen) otherCard.chosen = NO;
                    //card.chosen = NO;
                    NSLog(@"Chosen %s", otherCard.isChosen ? "YES": "NO");
                }
                self.numCardsChosen = 0;
            }
            
        }
        [self printPlay:card current:currentPlay];
        
    }
    
}

@end
