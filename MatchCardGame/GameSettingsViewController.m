//
//  GameSettingsViewController.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/25/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "GameSettingsViewController.h"
#import "GameSettings.h"

@interface GameSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *misMatchPenaltyField;
@property (weak, nonatomic) IBOutlet UITextField *matchBonusField;
@property (weak, nonatomic) IBOutlet UITextField *setMatchBonusField;
@property (weak, nonatomic) IBOutlet UITextField *costToChooseField;

@end

@implementation GameSettingsViewController

- (IBAction)changeCardMatchBonus:(UITextField *)sender {
    [GameSettings instance].match_bonus = [self.matchBonusField.text intValue];
}


- (IBAction)changeSetMatchBonus:(UITextField *)sender {
    [GameSettings instance].set_match_bonus = [self.setMatchBonusField.text intValue];
}


- (IBAction)changeCostToChoose:(UITextField *)sender {
    [GameSettings instance].cost_to_choose = [self.costToChooseField.text intValue];
}


- (IBAction)changeMismatchPenalty:(UITextField *)sender {
    [GameSettings instance].cost_to_choose = [self.costToChooseField.text intValue];
}

-(void)dismissKeyboard {
    [self.misMatchPenaltyField resignFirstResponder];
    [self.matchBonusField resignFirstResponder];
    [self.setMatchBonusField resignFirstResponder];
    [self.costToChooseField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.matchBonusField.text = [NSString stringWithFormat:@"%d", [GameSettings instance].match_bonus];
    self.setMatchBonusField.text = [NSString stringWithFormat:@"%d", [GameSettings instance].set_match_bonus];
    self.misMatchPenaltyField.text = [NSString stringWithFormat:@"%d", [GameSettings instance].mismatch_penalty];
    self.costToChooseField.text = [NSString stringWithFormat:@"%d", [GameSettings instance].cost_to_choose];
    // Do any additional setup after loading the view.
}


@end
