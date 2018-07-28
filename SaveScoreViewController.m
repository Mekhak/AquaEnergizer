//
//  SaveScoreViewController.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/16/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "SaveScoreViewController.h"

@interface SaveScoreViewController()

@property NSString* name;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end


@implementation SaveScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameTextField.delegate = self;
    
    //set labels text
    self.scoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.score];
    
    self.levelLabel.text = [NSString stringWithFormat:@"%li", (long)self.level];
    
    self.saveButton.enabled = NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* enteredText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.name = enteredText;
    
    if(self.name.length == 0)
        self.saveButton.enabled = NO;
    else
        self.saveButton.enabled = YES;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IBActions
- (IBAction)saveButtonAction:(id)sender
{
    //save score in file 
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString* fileName = @"hallOfFame.txt";
    NSString* filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSMutableArray* scoresArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    NSInteger newScoreIndex = -1;
    
    MyResult* result;
    
    for(NSInteger i = 0 ; i <= NUMBER_OF_SCORES_IN_HALL_OF_FAME - 1; i++)
    {
        result = scoresArray[i];
        if (self.score >= result.score)
        {
            newScoreIndex = i;
            break;
        }
    }
    
    result = [[MyResult alloc] init];
    
    if(newScoreIndex != -1)
    {
        result.score = self.score;
        
        result.name = self.name;
        
        result.level = self.level;
        
        [scoresArray insertObject:result atIndex:newScoreIndex];
        
        [scoresArray removeObjectAtIndex:NUMBER_OF_SCORES_IN_HALL_OF_FAME];
        
        [NSKeyedArchiver archiveRootObject:scoresArray toFile:filePath];
    }
    
    //for disableing saveMyScore button, if score already saved
    if([self.delegate respondsToSelector:@selector(saveScoreViewControllerSaveButtonPressed:)])
        [self.delegate saveScoreViewControllerSaveButtonPressed:self];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
