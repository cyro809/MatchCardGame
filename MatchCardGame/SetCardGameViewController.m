//
//  SetCardGameViewController.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/6/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCard.h"
#import "SetCardGame.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) SetCardGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation SetCardGameViewController


- (SetCardGame *)game
{
    if (!_game) _game = [[SetCardGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    
    return _game;
}

- (Deck *) createDeck
{
    return [[SetCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}


- (void) viewDidLoad
{
    [self updateUI];
}


- (IBAction)touchModeSwitch:(id)sender {
   
    
}


- (IBAction)lastPlaysSlider:(UISlider *)sender {
    
    
}


- (IBAction)touchReDealButton:(UIButton *)sender {

}


- (void) updateUI
{
    for(UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        SetCard *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitleColor:card.color forState:UIControlStateNormal];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isChosen;
    }
}



- (NSString *)titleForCard:(Card *)card
{
    return card.contents;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:@"card"];
}





@end
