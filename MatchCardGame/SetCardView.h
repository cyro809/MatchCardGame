//
//  SetCardView.h
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger numOfShapes;

@property (nonatomic) BOOL chosen;

@end
