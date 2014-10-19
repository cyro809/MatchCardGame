//
//  SetCardView.h
//  Matchismo
//
//  Created by Martin Mandl on 29.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger numOfShapes;

@property (nonatomic) BOOL chosen;

@end
