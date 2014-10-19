//
//  Deck.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 8/29/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "Card.h"

@interface Deck : Card
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (BOOL)isEmpty;

-(Card *)drawRandomCard;
@end
