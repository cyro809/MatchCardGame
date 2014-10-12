//
//  SetCardDeck.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (UIColor *color in [SetCard validColors]) {
                for(NSString *shading in [SetCard validShadings]) {
                    SetCard *card = [[SetCard alloc] init];
                    card.color = color;
                    card.shape = shape;
                    card.shading = shading;
                    card.numOfShapes = [card.shape length];
                    card.partialMatch = NO;
                    [self addCard:card];
                }
                
            }
        }
    }
    return self;
}
@end
