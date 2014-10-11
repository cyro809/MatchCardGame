//
//  SetCardGameViewController.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCard.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation SetCardGameViewController


- (IBAction)touchCardButton:(UIButton *)sender
{

}





- (IBAction)touchModeSwitch:(id)sender {
   
    
}


- (IBAction)lastPlaysSlider:(UISlider *)sender {
    
    
}


- (IBAction)touchReDealButton:(UIButton *)sender {

}


- (void) updateUI
{
    
}



- (NSString *)titleForCard:(Card *)card
{
    return @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:@"card"];
}





@end
