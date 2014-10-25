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

@property (strong, nonatomic) UIDynamicAnimator *animators;
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
    for (int i = 0; i < sender.tag; i++) {
        [self.game drawNewCard];
    }
    if ([self.game isDeckEmpty]) {
        sender.enabled = NO;
    }
    self.animators = nil;
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
    if (!card.isMatched && !self.animators) {
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
            if (!card.matched) {
                cardView = [self createViewForCard:card];
                cardView.tag = cardIndex;
                cardView.frame = CGRectMake(self.gridView.bounds.size.width,
                                            self.gridView.bounds.size.height,
                                            self.grid.cellSize.width,
                                            self.grid.cellSize.height);
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(touchCard:)];
                [cardView addGestureRecognizer:tap];
                
                [self.cardViews addObject:cardView];
                viewIndex = [self.cardViews indexOfObject:cardView];
                [self.gridView addSubview:cardView];
            }
        } else {
            cardView = self.cardViews[viewIndex];
            if (!card.matched) {
                [self updateView:cardView forCard:card];
            } else {
                if ([self.gameType isEqualToString:@"SET GAME"]) {
                    [self.cardViews removeObject:cardView];
                    [UIView animateWithDuration:1.0
                                     animations:^{
                                         cardView.frame = CGRectMake(0.0,
                                                                     self.gridView.bounds.size.height,
                                                                     self.grid.cellSize.width,
                                                                     self.grid.cellSize.height);
                                         
                                     } completion:^(BOOL finished) {
                                         [cardView removeFromSuperview];
                                     }];
                } else {
                    cardView.alpha = card.matched ? 0.6 : 1.0;
                }
            }
        }
    }
    
    self.grid.minimumNumberOfCells = [self.cardViews count];
    
    NSUInteger changedViews = 0;
    for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++) {
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        UIView *cardView = (UIView *)self.cardViews[viewIndex];
        if (![self frame:frame equalToFrame:cardView.frame]) {
            [UIView animateWithDuration:0.5
                                  delay:1.5 * changedViews++ / [self.cardViews count]
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cardView.frame = frame;
                             } completion:NULL];
        }
    }
    
}

#define FRAMEROUNDINGERROR 0.01

- (BOOL)frame:(CGRect)frame1 equalToFrame:(CGRect)frame2
{
    if (fabs(frame1.size.width - frame2.size.width) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.size.height - frame2.size.height) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.x - frame2.origin.x) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.y - frame2.origin.y) > FRAMEROUNDINGERROR) return NO;
    return YES;
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
        [UIView animateWithDuration:0.5
                         animations:^{
                             subView.frame = CGRectMake(0.0,
                                                        self.gridView.bounds.size.height,
                                                        self.grid.cellSize.width,
                                                        self.grid.cellSize.height);
                         } completion:^(BOOL finished) {
                             [subView removeFromSuperview];
                         }];
    }
    self.animators = nil;
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.animators = nil;
    self.grid.size = self.gridView.bounds.size;
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

#define RESISTANCE_TO_PILING 40.0
- (IBAction)gatherCardsIntoPile:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        if (!self.animators) {
            CGPoint center = [gesture locationInView:self.gridView];
            self.animators = [[UIDynamicAnimator alloc] initWithReferenceView:self.gridView];
            UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:self.cardViews];
            item.resistance = RESISTANCE_TO_PILING;
            [self.animators addBehavior:item];
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:center];
                [self.animators addBehavior:snap];
            }
        }
    }
}

- (IBAction)panPile:(UIPanGestureRecognizer *)gesture {
    if (self.animators) {
        CGPoint gesturePoint = [gesture locationInView:self.gridView];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            for (UIView *cardView in self.cardViews) {
                UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView
                                                                             attachedToAnchor:gesturePoint];
                [self.animators addBehavior:attachment];
            }
            for (UIDynamicBehavior *behaviour in self.animators.behaviors) {
                if ([behaviour isKindOfClass:[UISnapBehavior class]]) {
                    [self.animators removeBehavior:behaviour];
                }
            }
        } else if (gesture.state == UIGestureRecognizerStateChanged) {
            for (UIDynamicBehavior *behaviour in self.animators.behaviors) {
                if ([behaviour isKindOfClass:[UIAttachmentBehavior class]]) {
                    ((UIAttachmentBehavior *)behaviour).anchorPoint = gesturePoint;
                }
            }
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            for (UIDynamicBehavior *behaviour in self.animators.behaviors) {
                if ([behaviour isKindOfClass:[UIAttachmentBehavior class]]) {
                    [self.animators removeBehavior:behaviour];
                }
            }
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:gesturePoint];
                [self.animators addBehavior:snap];
            }
        }
    }
}



@end
