//
//  SetCard.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
@property (strong, nonatomic) NSString* shape;
@property (strong, nonatomic) NSString* shading;
@property (strong, nonatomic) UIColor* color;
@property (nonatomic) NSUInteger numOfShapes;

@property (nonatomic) int numberOfShapeMatches;
@property (nonatomic) int numberOfShadingMatches;
@property (nonatomic) int numberOfColorMatches;
@property (nonatomic) int numberOfNumberMatches;

+ (NSArray *) validShapes;
+ (NSArray *) validColors;
+ (NSArray *) validShadings;
+ (NSArray *) validNumbersOfShapes;
+ (NSUInteger) maxNumber;

- (int) match:(NSArray *)otherCards;
- (BOOL) shapeMatch:(SetCard *)otherCard;
- (BOOL) colorMatch:(SetCard *) otherCard;
- (BOOL) shadingMatch:(SetCard *) otherCard;
- (BOOL) numberMatch:(SetCard *) otherCard;

@end
