//
//  LevelCompletedViewController.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/16/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "LevelCompletedViewController.h"

@interface LevelCompletedViewController()<SaveScoreViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeBonusLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *goToNextLevelOrMenuButton;

@property (weak, nonatomic) IBOutlet UIButton *saveMyScoreButton;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end


@implementation LevelCompletedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set labels text
    self.timeBonusLabel.text = [NSString stringWithFormat:@"%li", (long)self.timeBonus];
    
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.score];
    
    
    if(self.level > NUMBER_OF_LEVELS)
    {
        [self.goToNextLevelOrMenuButton setTitle:@"Back To Menu" forState:UIControlStateNormal];
        
        self.infoLabel.text = @"All Levels Completed";
    }
    else
    {
        [self.goToNextLevelOrMenuButton setTitle:@"Go To Next Level" forState:UIControlStateNormal];
        
        self.infoLabel.text = @"Level Completed";
    }
    
    //ckeck whether user can save score
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString* fileName = @"hallOfFame.txt";
    NSString* filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSArray* scoresArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if(self.score < [scoresArray[NUMBER_OF_SCORES_IN_HALL_OF_FAME - 1] score])
        self.saveMyScoreButton.enabled = NO;
}

- (IBAction)goToNextLevelOrMenuButtonAction:(id)sender
{
    //if end of game, dismiss previous VC too
    if(self.level > NUMBER_OF_LEVELS)
    {
        if([self.delegate respondsToSelector:@selector(viewControllerDismissed:)])
            [self.delegate viewControllerDismissed:self];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SaveScoreViewController class]])
    {
        SaveScoreViewController* saveScoreVC = (SaveScoreViewController*)[segue destinationViewController];
        
        saveScoreVC.score = self.score;
        
        saveScoreVC.level = self.level - 1;
        
        saveScoreVC.delegate = self;
    }
}


#pragma  mark - SaveScoreViewControllerDelegate

- (void)saveScoreViewControllerSaveButtonPressed:(SaveScoreViewController *)saveScoreVC
{
    self.saveMyScoreButton.enabled = NO;
}

@end
