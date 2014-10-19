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
    return @[@"oval", @"squiggle", @"diamond"];
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

+ (NSUInteger)maxNumber
{
    return 3;
}

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
    if (self.numOfShapes == otherCard.numOfShapes) return YES;
    else return NO;
}

- (BOOL) colorMatch:(SetCard *)otherCard
{
    if (self.color == otherCard.color) return YES;
    else return NO;
}

- (BOOL) isASet
{
    if(self.numberOfNumberMatches > 1 &&
       self.numberOfColorMatches != 1 &&
       self.numberOfShadingMatches != 1 &&
       self.numberOfShapeMatches != 1) {
        self.partialMatch = NO;
        return YES;
    }
    else if(self.numberOfNumberMatches != 1 &&
            self.numberOfColorMatches > 1 &&
            self.numberOfShadingMatches != 1 &&
            self.numberOfShapeMatches != 1) {
        self.partialMatch = NO;
        return YES;
    }
    else if(self.numberOfNumberMatches != 1 &&
            self.numberOfColorMatches != 1 &&
            self.numberOfShadingMatches > 1 &&
            self.numberOfShapeMatches != 1) {
        self.partialMatch = NO;
        return YES;
    }
    else if(self.numberOfNumberMatches != 1 &&
            self.numberOfColorMatches != 1 &&
            self.numberOfShadingMatches != 1 &&
            self.numberOfShapeMatches > 1) {
        self.partialMatch = NO;
        return YES;
    }
    else return NO;
}

- (BOOL) hasPartialMatch
{
    if (self.numberOfColorMatches == 1) return YES;
    else if( self.numberOfNumberMatches == 1) return YES;
    else if (self.numberOfShadingMatches == 1) return YES;
    else if (self.numberOfShapeMatches == 1) return YES;
    return NO;
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
       
        if (card.isChosen && !card.isMatched && self != card) {
            
            if ([self shapeMatch:card]) {
                shapeMatched = YES;
                
                self.numberOfShapeMatches++;
                self.partialMatch = YES;
            }
            else {
                shapeMatched = NO;
                score = 0;
            }
            
            if ([self colorMatch:card]) {
                colorMatched = YES;
                
                self.numberOfColorMatches++;
                self.partialMatch = YES;
            }
            else {
                colorMatched = NO;
                score = 0;
            }
            
            if ([self shadingMatch:card]) {
                shadingMatched = YES;
                
                self.numberOfShadingMatches++;
                self.partialMatch = YES;
            }
            else {
                shadingMatched = NO;
                score = 0;
            }
            
            if ([self numberMatch:card]) {
                numberMatched = YES;
                
                self.numberOfNumberMatches++;
                self.partialMatch = YES;
            }
            else {
                numberMatched = NO;
                score = 0;
            }
        }
        
    }
    if( self.isASet){
        score = 1;
        return score;
    }
    else if(!shapeMatched && !colorMatched && !shadingMatched && !numberMatched && self.allDiferentCards) {
        score = 1;
        return score;
    }
    else if (self.hasPartialMatch) {
        score = 0;
    }
    
    return score;
}

@end
