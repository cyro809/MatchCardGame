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
#import "Grid.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lastPlayLabel;
@property (weak, nonatomic) IBOutlet UISlider *lastPlaySlider;

@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@end

@implementation CardGameViewController

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [NSMutableArray arrayWithCapacity:self.numberOfStartingCards];
    return _cardViews;
}

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.cellAspectRatio = self.maxCardSize.width / self.maxCardSize.height;
        _grid.minimumNumberOfCells = self.numberOfStartingCards;
        _grid.maxCellWidth = self.maxCardSize.width;
        _grid.maxCellHeight = self.maxCardSize.height;
        _grid.size = self.gridView.frame.size;
    }
    return _grid;
}


- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfStartingCards
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}



- (UIView *)createViewForCard:(Card *)card
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)touchCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.game chooseCardAtIndex:gesture.view.tag];
        [self updateUI];
    }
}

- (void)swipeCard:(UISwipeGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateEnded) {
        [self.game chooseCardAtIndex:gesture.view.tag];
        [self updateUI];
    }
}

static const double CARDSPACINGINPERCENT = 0.08;

- (void)updateUI
{
    for (NSUInteger cardIndex = 0;
         cardIndex < self.game.numCardsDealed;
         cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        
        NSUInteger viewIndex = [self.cardViews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                if (((UIView *)obj).tag == cardIndex) return YES;
            }
            return NO;
        }];
        UIView *cardView;
        if (viewIndex == NSNotFound) {
            cardView = [self createViewForCard:card];
            cardView.tag = cardIndex;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(touchCard:)];
            
            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(swipeCard:)];
            [cardView addGestureRecognizer:tap];
            [cardView addGestureRecognizer:swipe];
            
            [self.cardViews addObject:cardView];
            viewIndex = [self.cardViews indexOfObject:cardView];
            [self.gridView addSubview:cardView];
        } else {
            cardView = self.cardViews[viewIndex];
            [self updateView:cardView forCard:card];
            cardView.alpha = card.matched ? 0.3 : 1.0;
        }
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        cardView.frame = frame;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (IBAction)touchReDealButton:(UIButton *)sender {
    self.gameFinishTime = [NSDate date];
    NSLog(@"Finish: %@", self.gameFinishTime);
    
    NSTimeInterval gameDurationTime = [self.gameStartTime timeIntervalSinceDate:self.gameFinishTime];
    
    //self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    
    self.gameRecord = [NSUserDefaults standardUserDefaults];
    [self.gameRecord setObject:self.gameType forKey:@"gameType"];
    [self.gameRecord setObject:self.gameStartTime forKey:@"gameStartTime"];
    [self.gameRecord setObject:self.gameFinishTime forKey:@"gameFinishTime"];
    [self.gameRecord setDouble:gameDurationTime forKey:@"gameDurationTime"];
    [self.gameRecord setInteger:[self.game score] forKey:@"gameScore"];

    self.game = nil;
    self.cardViews = nil;
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

@end
