//
//  CardGameViewController.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 8/29/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lastPlayLabel;
@property (weak, nonatomic) IBOutlet UISlider *lastPlaySlider;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    
    return _game;
}

- (Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)touchModeSwitch:(id)sender {
    if (self.modeSwitch.selectedSegmentIndex == 0)
    {
        self.game.numCards = 2;
    }
    else if (self.modeSwitch.selectedSegmentIndex == 1)
    {
        self.game.numCards = 3;
    }
    
}


- (IBAction)lastPlaysSlider:(UISlider *)sender {
    NSUInteger sliderValue = [sender value];
    if ([self.game.lastPlays count])
    {
        self.lastPlayLabel.text = [self.game.lastPlays objectAtIndex:sliderValue];
    }
    
}


- (IBAction)touchReDealButton:(UIButton *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self updateUI];
    self.scoreLabel.text = @"Score: 0";
    self.lastPlayLabel.text = @"Last Play: ";
    if (self.modeSwitch.selectedSegmentIndex == 0)
    {
        self.game.numCards = 2;
    }
    else if (self.modeSwitch.selectedSegmentIndex == 1)
    {
        self.game.numCards = 3;
    }
    self.game.gameStart = NO;
    self.game.lastPlays = [[NSMutableArray alloc] init];
}


- (void) updateUI
{
    for(UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        if([self.game.lastPlays count] > 0)
        {
            self.lastPlayLabel.text = [NSString stringWithFormat:@"Last Play: %@", [self.game.lastPlays objectAtIndex:0]];
            self.lastPlaySlider.maximumValue = [self.game.lastPlays count]-1;
        }
    }
    if (self.game.gameStart){
        self.modeSwitch.userInteractionEnabled = NO;
        self.modeSwitch.enabled = NO;
    }
    else {
        self.modeSwitch.userInteractionEnabled = YES;
        self.modeSwitch.enabled = YES;
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"card"];
}














@end
