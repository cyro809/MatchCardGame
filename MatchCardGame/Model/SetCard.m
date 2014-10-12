//
//  SetCard.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray *)validShapes
{
    return @[@"●",@"●●", @"●●●", @"◼︎", @"◼︎◼︎", @"◼︎◼︎◼︎", @"▲", @"▲▲", @"▲▲▲"];
}

+ (NSArray *)validColors
{
    return @[[UIColor redColor], [UIColor purpleColor], [UIColor greenColor]];
}

+ (NSArray *)validShadings
{
    return @[@"solid",@"striped",@"outlined"];
}

+ (NSArray *)validNumbersOfShapes
{
    return @[@1,@2,@3];
}

+ (NSUInteger) maxNumber { return [[self validNumbersOfShapes] count]; }

- (BOOL) shapeMatch:(SetCard *)otherCard
{
    NSString *thisShape = [self.shape substringToIndex:1];
    NSString *otherShape = [otherCard.shape substringToIndex:1];
    if ([thisShape isEqual:otherShape]) return YES;
    else return NO;
}

- (BOOL) shadingMatch:(SetCard *)otherCard
{
    if ([self.shading isEqual:otherCard.shading]) return YES;
    else return NO;
}

- (BOOL) numberMatch:(SetCard *)otherCard
{
    if ([self.shape length] == [otherCard.shape length]) return YES;
    else return NO;
}

- (BOOL) colorMatch:(SetCard *)otherCard
{
    if (self.color == otherCard.color) return YES;
    else return NO;
}

- (BOOL) isASet
{
    if(self.numberOfNumberMatches > 1 || self.numberOfColorMatches > 1 ||
       self.numberOfShadingMatches > 1 || self.numberOfShapeMatches > 1) return YES;
    else return NO;
}

- (BOOL) allDiferentCards
{
    if (self.numberOfNumberMatches == 0 && self.numberOfColorMatches == 0 && self.numberOfShadingMatches == 0 && self.numberOfShapeMatches == 0) return YES;
    else return NO;
}

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    self.numberOfShapeMatches = 0;
    self.numberOfShadingMatches = 0;
    self.numberOfColorMatches = 0;
    self.numberOfNumberMatches = 0;
    
    BOOL shapeMatched = NO;
    BOOL numberMatched = NO;
    BOOL shadingMatched = NO;
    BOOL colorMatched = NO;
    
    for (SetCard *card in otherCards) {
        NSLog(@"================= Inicio For ===================");
        NSLog(@"Shape: %d", self.numberOfShapeMatches);
        NSLog(@"NUmber: %d", self.numberOfNumberMatches);
        NSLog(@"Color: %d", self.numberOfColorMatches);
        NSLog(@"Shading: %d", self.numberOfShadingMatches);
        NSLog(@"================================================");
        if (card.isChosen && !card.isMatched && self != card) {
            
            if ([self shapeMatch:card]) {
                NSLog(@"Shape Match");
                shapeMatched = YES;
                self.numberOfShapeMatches++;
            }
            else {
                shapeMatched = NO;
                score = 0;
                self.numberOfShapeMatches = 0;
            }
            
            if ([self colorMatch:card]) {
                NSLog(@"Color Match");
                colorMatched = YES;
                self.numberOfColorMatches++;
            }
            else {
                colorMatched = NO;
                score = 0;
                self.numberOfColorMatches = 0;
            }
            
            if ([self shadingMatch:card]) {
                NSLog(@"Shading Match");
                shadingMatched = YES;
                self.numberOfShadingMatches++;
            }
            else {
                shadingMatched = NO;
                score = 0;
                self.numberOfShadingMatches = 0;
            }
            
            if ([self numberMatch:card]) {
                NSLog(@"Number Match");
                numberMatched = YES;
                self.numberOfNumberMatches++;
            }
            else {
                numberMatched = NO;
                score = 0;
                self.numberOfNumberMatches = 0;
            }
        }
        NSLog(@"================= Final do For =================");
        NSLog(@"Shape: %d", self.numberOfShapeMatches);
        NSLog(@"NUmber: %d", self.numberOfNumberMatches);
        NSLog(@"Color: %d", self.numberOfColorMatches);
        NSLog(@"Shading: %d", self.numberOfShadingMatches);
        NSLog(@"================================================");
    }
    if( self.isASet) score = 1;
    if(!shapeMatched && !colorMatched && !shadingMatched && !numberMatched && self.allDiferentCards) score = 1;
    
    return score;
}

@end
