//
//  MenuViewController.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/22/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "MenuViewController.h"
#import "PlayViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property NSInteger gameMode;//Continue or New Game

@end

@implementation MenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //enable continue button if continue file exists
    self.continueButton.enabled = NO;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString* fileName = @"continue.txt";
    
    NSString* filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    if([fileManager fileExistsAtPath:filePath])
        self.continueButton.enabled = YES;
}

- (IBAction)continueButtonAction:(id)sender
{
    self.gameMode = CONTINUE;
    
    [self performSegueWithIdentifier:@"playVC" sender:nil];
}

- (IBAction)startNewGameButtonAction:(id)sender
{
    self.gameMode = NEW_GAME;
    
    [self performSegueWithIdentifier:@"playVC" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //set game mode in PlayViewController
    if([segue.destinationViewController isKindOfClass:[PlayViewController class]])
    {
        PlayViewController* playVC = (PlayViewController*)[segue destinationViewController];
        
        playVC.gameMode = self.gameMode;
    }
}

@end
