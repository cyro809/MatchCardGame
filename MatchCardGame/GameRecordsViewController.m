//
//  GameRecordsViewController.m
//  MatchCardGame
//
//  Created by Cyro Guimaraes on 10/25/14.
//  Copyright (c) 2014 MAB604. All rights reserved.
//

#import "GameRecordsViewController.h"
#import "GameRecords.h"

@interface GameRecordsViewController()
@property (weak, nonatomic) IBOutlet UITextView *resultsTextView;
@property (nonatomic, strong) NSMutableArray *resultsDictionary;
@property (nonatomic, strong) NSArray *sortedArray;

@end

@implementation GameRecordsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [GameRecords instance].allRecords = [userDefaults objectForKey:@"allRecords"];
    self.resultsDictionary = [GameRecords instance].allRecords;
    if (!self.resultsDictionary) {
        self.resultsDictionary = [[NSMutableArray alloc] init];
    }
    self.sortedArray = self.resultsDictionary;
    
    [self printResults];
}

- (void)printResults
{
    
    self.resultsTextView.text = @"Score:   Duration:   Game Type:  \n";
    for(NSDictionary *dictionary in self.sortedArray)
    {
        double duration = [[dictionary objectForKey:@"gameDuration"] doubleValue];
        int score = [[dictionary objectForKey:@"gameScore"] intValue];
        NSString *gameType = [dictionary objectForKey:@"gameType"];
        
        self.resultsTextView.text = [self.resultsTextView.text stringByAppendingFormat:@"   %d     %.02f         %@ \n",
                                score, duration, gameType];
    }
        
}


- (IBAction)sortByDuration:(UIButton *)sender {
    NSSortDescriptor *durationDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gameDuration" ascending:YES];
    NSMutableArray *sortedDurationArray = [NSMutableArray arrayWithObject:durationDescriptor];
    self.sortedArray = [self.resultsDictionary sortedArrayUsingDescriptors:sortedDurationArray];
    [self printResults];
}


- (IBAction)sortByScore:(UIButton *)sender {
    NSSortDescriptor *scoreDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gameScore" ascending:NO];
    NSMutableArray *sortedScoreArray = [NSMutableArray arrayWithObject:scoreDescriptor];
    self.sortedArray = [self.resultsDictionary sortedArrayUsingDescriptors:sortedScoreArray];
    [self printResults];
}

@end
