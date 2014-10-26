//
//  SetCardView.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView ()
@property (nonatomic) float shapeHeight;
@property (nonatomic) float shapeWidth;
@end

@implementation SetCardView

#define SHAPE_WIDTH_RATIO 0.7
#define SHAPE_HEIGHT_RATIO 0.2

-(float)shapeHeight
{
    return self.bounds.size.height * SHAPE_HEIGHT_RATIO;
}

-(float)shapeWidth
{
    return self.bounds.size.width * SHAPE_WIDTH_RATIO;
}



- (void)drawRect:(CGRect)rect
{
    [self drawCardBackground];
    
    for (int i = 1; i <= self.numOfShapes; i++) {
        
        float y = self.bounds.size.height / (self.numOfShapes + 1);
        
        y *= i;
        
        [self pushContextAndMoveCenterTo:CGPointMake(self.bounds.size.width / 2, y)];
        
        if ([self.shape  isEqual: @"diamond"])
            [self drawDiamonds];
        else if ([self.shape  isEqual: @"oval"])
            [self drawOvals];
        else
            [self drawSquiggles];
        
        [self popContext];
    }
}

-(void)drawOvals
{
    CGRect rect = CGRectMake(-self.shapeWidth/2, -self.shapeHeight/2, self.shapeWidth, self.shapeHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [self colorAndDraw:path];
}

-(void)drawSquiggles
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint upperLeft = CGPointMake(-self.shapeWidth/2, -(self.shapeHeight / 2) + self.shapeHeight / 5);
    [path moveToPoint:upperLeft];
    
    CGPoint upperRight = CGPointMake(self.shapeWidth/2, -(self.shapeHeight / 2));
    CGPoint cp1 = CGPointMake(0, -self.shapeHeight/1.5);
    CGPoint cp2 = CGPointMake(0, 0);
    [path addCurveToPoint:upperRight controlPoint1:cp1 controlPoint2:cp2];
    
    CGPoint lowerRight = CGPointMake(self.shapeWidth/2, (self.shapeHeight / 2) - self.shapeHeight / 5);
    CGPoint cp3 = CGPointMake(self.shapeWidth/1.5, 0);
    [path addQuadCurveToPoint:lowerRight controlPoint:cp3];
    
    CGPoint lowerLeft = CGPointMake(-self.shapeWidth/2, (self.shapeHeight / 2));
    CGPoint cp4 = CGPointMake(0, self.shapeHeight/1.5);
    CGPoint cp5 = CGPointMake(0, 0);
    [path addCurveToPoint:lowerLeft controlPoint1:cp4 controlPoint2:cp5];
    
    CGPoint cp6 = CGPointMake(-self.shapeWidth/1.5, 0);
    [path addQuadCurveToPoint:upperLeft controlPoint:cp6];
    
    [self colorAndDraw:path];
}

-(void)drawDiamonds
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, -(self.shapeHeight / 2))];
    [path addLineToPoint:CGPointMake(self.shapeWidth / 2, 0)];
    [path addLineToPoint:CGPointMake(0, self.shapeHeight / 2)];
    [path addLineToPoint:CGPointMake(- (self.shapeWidth / 2), 0)];
    [path closePath];
    
    [self colorAndDraw:path];
}

#define NUMBER_LINES 10

-(void)colorAndDraw:(UIBezierPath*)path
{
    if ([self.shading  isEqual: @"solid"]) {
        [self.color setFill];
        [path fill];
    }
    
    [path addClip]; // allow us to draw stripes without having to care about bounds
    
    [self.color setStroke];
    [path stroke];
    
    path.lineWidth = 0.3;
    if ([self.shading  isEqual: @"striped"]) {
        for (int i = 0; i <= NUMBER_LINES; i++) {
            [path moveToPoint:CGPointMake(-self.shapeWidth/2 + self.shapeWidth / NUMBER_LINES * i, -self.shapeHeight/2)];
            [path addLineToPoint:CGPointMake(-self.shapeWidth/2 + self.shapeWidth / NUMBER_LINES * i, self.shapeHeight/2)];
        }
        [path stroke];
    }
}

-(void)drawCardBackground
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:self.bounds.size.width * 0.1];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if (self.chosen) {
        [[UIColor blueColor] setStroke];
        roundedRect.lineWidth *= 2.0;
    } else {
        [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
        roundedRect.lineWidth /= 2.0;
    }
    [roundedRect stroke];
}

- (void)pushContextAndMoveCenterTo:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, point.x, point.y);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
