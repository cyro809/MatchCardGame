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

@end

@implementation GameRecordsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self printResults];
}

- (void)printResults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [GameRecords instance].allRecords = [userDefaults objectForKey:@"allRecords"];
    NSMutableArray *resultsDictionary = [GameRecords instance].allRecords;
    if (!resultsDictionary) {
        resultsDictionary = [[NSMutableArray alloc] init];
    }
    self.resultsTextView.text = @"Score:   Duration:   Game Type:  \n";
    for(NSDictionary *dictionary in resultsDictionary)
    {
        double duration = [[dictionary objectForKey:@"gameDuration"] doubleValue];
        int score = [[dictionary objectForKey:@"gameScore"] intValue];
        NSString *gameType = [dictionary objectForKey:@"gameType"];
        
        self.resultsTextView.text = [self.resultsTextView.text stringByAppendingFormat:@"   %d     %.02f         %@ \n",
                                score, duration, gameType];
    }
        
}

@end
