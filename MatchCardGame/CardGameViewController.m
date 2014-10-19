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
@property (weak, nonatomic) IBOutlet UILabel *lastPlayLabel;
@property (weak, nonatomic) IBOutlet UISlider *lastPlaySlider;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;

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

- (IBAction)touchAddNewCards:(UIButton *)sender {
    NSLog(@"ADICIONA PORRA!!!!!!!!!!!!!");
    NSLog(@"Sender tag: %d", sender.tag);
    for (int i = 0; i < sender.tag; i++) {
        NSLog(@"TAG: %d", i);
        [self.game drawNewCard];
    }
    if ([self.game isDeckEmpty]) {
        sender.enabled = NO;
    }
    [self updateUI];
}

- (UIView *)createViewForCard:(Card *)card
{
    UIView *view = [[UIView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    view.backgroundColor = [UIColor redColor];
}

- (void)touchCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self flipTransition:gesture];
    }
}

static const double FLIPTRANSITIONDURATION = 0.5;

- (void)flipTransition:(UIGestureRecognizer *)gesture
{
    Card *card = [self.game cardAtIndex:gesture.view.tag];
    if (!card.isMatched) {
        [UIView transitionWithView:gesture.view
                          duration:FLIPTRANSITIONDURATION
                           options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                               card.chosen = !card.chosen;
                               [self updateView:gesture.view forCard:card];
                           } completion:^(BOOL finished) {
                               card.chosen = !card.chosen;
                               [self.game chooseCardAtIndex:gesture.view.tag];
                               [self updateUI];
                           }];
    }
    
}

- (void)swipeCard:(UISwipeGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateEnded) {
        [self flipTransition:gesture];
    }
}

static const double CARDSPACINGINPERCENT = 0.08;

- (void)updateUI
{
    for (NSUInteger cardIndex = 0; cardIndex < self.game.numCardsDealed; cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        
        NSUInteger viewIndex = [self.cardViews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                if (((UIView *)obj).tag == cardIndex) return YES;
            }
            return NO;
        }];
        UIView *cardView;
        if (viewIndex == NSNotFound) {
            if (!card.isMatched) {
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
            }
            
        } else {
            cardView = self.cardViews[viewIndex];
            
            if (!card.isMatched) {
                [self updateView:cardView forCard:card];
            }
            else {
                if ([self.gameType isEqualToString:@"SET GAME"]) {
                    [cardView removeFromSuperview];
                    [self.cardViews removeObject:cardView];
                }
                else {
                    cardView.alpha =card.isMatched ? 0.5 : 1.0;
                }
            }
        }
        
        self.grid.minimumNumberOfCells = [self.cardViews count];
        for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++) {
            CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                              inColumn:viewIndex % self.grid.columnCount];
            frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
            ((UIView *)self.cardViews[viewIndex]).frame = frame;
        }
        
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
    
    self.gameRecord = [NSUserDefaults standardUserDefaults];
    [self.gameRecord setObject:self.gameType forKey:@"gameType"];
    [self.gameRecord setObject:self.gameStartTime forKey:@"gameStartTime"];
    [self.gameRecord setObject:self.gameFinishTime forKey:@"gameFinishTime"];
    [self.gameRecord setDouble:gameDurationTime forKey:@"gameDurationTime"];
    [self.gameRecord setInteger:[self.game score] forKey:@"gameScore"];
    
    for (UIView *subView in self.cardViews) {
        [subView removeFromSuperview];
    }
    
    self.game = nil;
    self.cardViews = nil;
    self.grid = nil;
    [self updateUI];
    
    self.scoreLabel.text = @"Score: 0";
    self.lastPlayLabel.text = @"Last Play: ";
    
    self.addCardsButton.enabled = YES;
    
    self.game.gameStart = NO;
    self.game.lastPlays = [[NSMutableArray alloc] init];
}

@end
