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
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastPlayLabel;

@end

@implementation SetCardGameViewController


- (SetCardGame *)game
{
    if (!_game) _game = [[SetCardGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    _game.numCards = 3;
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
    self.gameType = @"SET GAME";
    self.start = YES;
    [self updateUI];
}


- (IBAction)touchReDealButton:(id)sender {
    self.gameFinishTime = [NSDate date];
    NSLog(@"Finish: %@", self.gameFinishTime);
    
    NSTimeInterval gameDurationTime = [self.gameStartTime timeIntervalSinceDate:self.gameFinishTime];
    
    self.game = [[SetCardGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self updateUI];
    
    self.gameRecord = [NSUserDefaults standardUserDefaults];
    [self.gameRecord setObject:self.gameType forKey:@"gameType"];
    [self.gameRecord setObject:self.gameStartTime forKey:@"gameStartTime"];
    [self.gameRecord setObject:self.gameFinishTime forKey:@"gameFinishTime"];
    [self.gameRecord setDouble:gameDurationTime forKey:@"gameDurationTime"];
    [self.gameRecord setInteger:[self.game score] forKey:@"gameScore"];
    //self.scoreLabel.text = @"Score: 0";
    //self.lastPlayLabel.text = @"Last Play: ";
    
    
    self.game.numCards = 3;
    self.game.gameStart = NO;
    self.start = YES;
    self.game.lastPlays = [[NSMutableArray alloc] init];
}

- (void) updateUI
{
    for(UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        
        SetCard *card =  (SetCard*)[self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setAttributedTitle:[self attributedTitleForCard:card] forState:UIControlStateNormal];
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        
        self.lastPlayLabel.attributedText = [self setCards:[self.game cardsChosen]];
        
        if ([self.game numCardsChosen] >= [self.game numCards]) {
            
        }
        
        if(card.isChosen) {
            cardButton.alpha = 0.3;
        }
        else {
            cardButton.alpha = 1;
        }
        
        if(self.start) {
            self.gameStartTime = [NSDate date];
            NSLog(@"Start: %@", self.gameStartTime);
            self.start = NO;
        }
        
        cardButton.enabled = !card.isMatched;
    }
}

- (NSAttributedString *)attributedTitleForCard:(SetCard *)card
{
    NSDictionary *titleAttributes;
    if([card.shading isEqual:@"striped"]) {
        titleAttributes = @{
                            NSStrokeWidthAttributeName : @-5,
                            NSStrokeColorAttributeName : card.color,
                        NSForegroundColorAttributeName : [card.color colorWithAlphaComponent:0.3]};
    } else {
        titleAttributes = @{
                            NSStrokeWidthAttributeName:@-5,
                            NSStrokeColorAttributeName:card.color,
                        NSForegroundColorAttributeName:[card.shading isEqual:@"outlined"] ? [UIColor whiteColor] : card.color };
    }
    
    
    
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.shape
                                                                attributes:titleAttributes];
    
    return title;
    
                                                                
}

- (NSAttributedString *)setCards:(NSArray *)chosenSetCards
{
    //NSMutableArray *lastCards = [[NSMutableArray alloc] init];
    NSMutableAttributedString *cardString = [[NSMutableAttributedString alloc] init];
    for (SetCard *card in chosenSetCards) {
        [cardString appendAttributedString:[self attributedTitleForCard:card]];
        //[lastCards insertObject:cardString atIndex:0];
    }
    return cardString;
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
