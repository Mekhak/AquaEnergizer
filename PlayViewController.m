//
//  ViewController.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/4/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//


#import "PlayViewController.h"

BOOL isAppActive;//used for stopping timers from AppDelegate, when user goes to background mode


@interface PlayViewController()<DismissViewControllerProtocol>

@property Manager* manager;//game manager

@property BoardView* board;//game board

@property (weak, nonatomic) IBOutlet UIView *boardView;//a UIView, _board will be added on boardView

@property NSMutableArray* pathForHero;

@property NSInteger heroStep;//counter for heros step

@property BOOL isHeroMoving;//flag for hero timer

@property BOOL isGameStarted;//flag for timers

@property NSMutableArray* stonesFallingSituation;//array of boolean variables, that indicates whether the stone is falling or not;
@property NSMutableArray* oxygensFallingSituation;//array of boolean variables, that indicates whether the oxygen is falling or not;
@property NSMutableArray* bombsFallingSituation;//array of boolean variables, that indicates whether the bomb is falling or not;

@property NSInteger numberOfOxygens;//red balles

//alert controllers
@property UIAlertController* loseAlert;
@property UIAlertController* startAlert;

@property NSMutableArray* arrayOfLevelsFilesPaths;

@property NSString* continueFilePath;

@property NSInteger numberOfLevels;

@property NSInteger lives;

@property NSInteger level;//current level,

@property NSInteger time;//a time for completing the level

//toolbar
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *livesLabel;
@property (weak, nonatomic) IBOutlet UIButton *suicideButton;

//timers
@property NSTimer* timerForHero;
@property NSTimer* objectsTimer;
@property NSTimer* timerForSeconds;

@property BOOL isTimeToDismissVC;//indicates whether is time for dismissing VC

@property AVAudioPlayer* audioPlayer;

@property NSMutableDictionary* soundsDictionary;

@end



@implementation PlayViewController

#pragma mark - live cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [Manager sharedInstance];
    
    [self.manager resetScore];
    
    self.numberOfLevels = NUMBER_OF_LEVELS;
    
    self.lives = NUMBER_OF_LIVES;
    
    self.level = 1;
    
    //init startAlert
    self.startAlert = [UIAlertController alertControllerWithTitle:@"Get ready!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* startAction = [UIAlertAction actionWithTitle:@"Start" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.isGameStarted = YES;
        
        //sound
        [self playSoundWithSoundName:@"start"];
    }];
    
    [self.startAlert addAction:startAction];
    
    //init loseAlert
    self.loseAlert = [UIAlertController alertControllerWithTitle:@"You Lose" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* loseAction = [UIAlertAction actionWithTitle:@"Go To Menu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.loseAlert addAction:loseAction];
    
    //preserving file paths in _arrayOfPaths
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = [paths objectAtIndex:0];
    
    self.arrayOfLevelsFilesPaths = [NSMutableArray array];
    
    NSString* fileName = @"level1.txt";
    NSString* filePath = [documentsDirectoryPath stringByAppendingPathComponent: fileName];
    [self.arrayOfLevelsFilesPaths addObject:filePath];
    
    fileName = @"level2.txt";
    filePath = [documentsDirectoryPath stringByAppendingPathComponent: fileName];
    [self.arrayOfLevelsFilesPaths addObject:filePath];
    
    fileName = @"level3.txt";
    filePath = [documentsDirectoryPath stringByAppendingPathComponent: fileName];
    [self.arrayOfLevelsFilesPaths addObject:filePath];
    
    fileName = @"continue.txt";
    filePath = [documentsDirectoryPath stringByAppendingPathComponent: fileName];
    self.continueFilePath = filePath;
 
    //init board
    self.board = [[BoardView alloc]initWithFrame:CGRectMake(0, 0, self.boardView.frame.size.width, self.boardView.frame.size.height)];
    
    self.board.delegate = self;
    
    [self.boardView addSubview:self.board];
    
    self.isTimeToDismissVC = NO;
    
    //preserving sounds name in _soundsDictionary
    self.soundsDictionary = [NSMutableDictionary dictionary];
    
    NSString* path = [NSString stringWithFormat:@"%@/heroMovement.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL* soundUrl = [NSURL fileURLWithPath:path];
    [self.soundsDictionary setObject:soundUrl forKey:@"heroMovement"];
    
    path = [NSString stringWithFormat:@"%@/fellDown.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    [self.soundsDictionary setObject:soundUrl forKey:@"fellDown"];
    
    path = [NSString stringWithFormat:@"%@/explosion.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    [self.soundsDictionary setObject:soundUrl forKey:@"explosion"];
    
    path = [NSString stringWithFormat:@"%@/start.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    [self.soundsDictionary setObject:soundUrl forKey:@"start"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //for hero movement
    self.timerForHero = [NSTimer scheduledTimerWithTimeInterval:TIMER_FOR_HERO_TIME_INTERVAL target:self selector:@selector(heroTimerHandler:) userInfo:nil repeats:YES];
    
    //used for synchronizing movements of all objects, besides the hero
    self.objectsTimer = [NSTimer scheduledTimerWithTimeInterval:OBJECTS_TIMER_TIME_INTERVAL target:self selector:@selector(objectsTimerHandler:) userInfo:nil repeats:YES];
    
    //for game seconds
    self.timerForSeconds = [NSTimer scheduledTimerWithTimeInterval:TIMER_FOR_SECONDS_TIME_INTERVAL target:self selector:@selector(secondsTimerHandler:) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isTimeToDismissVC)
        [self dismissViewControllerAnimated:NO completion:nil];
    else
    {
        //reset game
        [self resetViewController];
        
        //alert with level information
        [self levelStarted];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //invalidate all timers
    [self.timerForHero invalidate];
    [self.objectsTimer invalidate];
    [self.timerForSeconds invalidate];
    
    //save game if needed
    if(self.isGameStarted)
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:self.continueFilePath contents:nil attributes:nil];
        
        GameParameters* parameters = [[GameParameters alloc]init];
        [self.manager saveParameters:parameters];
        
        parameters.lives = self.lives;
        parameters.level = self.level;
        parameters.time = self.time;
        
        [NSKeyedArchiver archiveRootObject:parameters toFile:self.continueFilePath];
    }
    
    //stop audio
    [self.audioPlayer stop];
}


#pragma mark - timers
- (void)heroTimerHandler:(NSTimer*)timer
{
    if(self.isGameStarted && self.manager.heroPoint != nil && self.isHeroMoving && isAppActive)
    {
        MyPoint* firstNextPoint = self.pathForHero[self.heroStep];
        
        if([self.manager canMoveHeroToPoint: firstNextPoint])
        {
            //if(nextStep == KEY) delete key, open gate
            if(self.manager.keyPoint != nil)
            {
                if([self.manager.keyPoint isEqualToPoint:firstNextPoint])
                {
                    [self.board removeCellInPoint:self.manager.gatePoint];
                    [self.manager removeObjectInPoint:self.manager.keyPoint];
                    [self.manager removeObjectInPoint:self.manager.gatePoint];
                }
            }

            if([self.manager isMonsterInPoint:firstNextPoint])
            {
                //explosion
                NSMutableArray* array = [self.manager explodeInPoint:self.manager.heroPoint];
                
                [self.board explodeWithArray:array];
                
                //stop hero
                self.isHeroMoving = NO;
                
                //sound
                [self playSoundWithSoundName:@"explosion"];
            }
            else
            {
                //move hero
                [self.board moveHeroFromPoint:self.manager.heroPoint toPoint:firstNextPoint];
                
                [self.manager moveHeroToPoint:firstNextPoint];
                
                //sound
                [self playSoundWithSoundName:@"heroMovement"];
            }
    
            //checking for wining
            MyPoint* endPoint = [MyPoint pointWithX:self.manager.exitPoint.x - 1 andY:self.manager.exitPoint.y];
            
            //if hero is in the endPoint and oxygens count is 0
            if(self.numberOfOxygens == 0 && [self.manager.heroPoint isEqualToPoint:endPoint])
                [self levelCompleted];
        }
        else
        {
            if(self.heroStep <= self.pathForHero.count - 1 && self.manager.heroPoint.y != firstNextPoint.y)
            {
                MyPoint* secondNextPoint;
                
                if(self.manager.heroPoint.y < firstNextPoint.y)
                    secondNextPoint = [MyPoint pointWithX:firstNextPoint.x andY:firstNextPoint.y + 1];
                else
                    secondNextPoint = [MyPoint pointWithX:firstNextPoint.x andY:firstNextPoint.y - 1];
                
                if([self.manager canHeroMoveObjectInPoint:firstNextPoint ToPoint:secondNextPoint])
                {
                    //move object
                    [self.board moveCellFromPoint:firstNextPoint toPoint:secondNextPoint];
                    
                    //move hero
                    [self.board moveHeroFromPoint:self.manager.heroPoint toPoint:firstNextPoint];
                    
                    [self.manager moveObjectFromPoint:firstNextPoint toPoint:secondNextPoint];
                    
                    [self.manager moveHeroToPoint:firstNextPoint];
                    
                    //sound
                    [self playSoundWithSoundName:@"heroMovement"];
                }
                else
                {
                    //stop hero
                    self.isHeroMoving = NO;
                    self.heroStep = 0;
                }
            }
        }
        
        if(self.heroStep >= (NSInteger)self.pathForHero.count - 1)
        {
            self.isHeroMoving = NO;
            self.heroStep = 0;
        }
        else if(self.isHeroMoving)
            self.heroStep++;
    }
}

- (void)objectsTimerHandler:(NSTimer*)timer
{
    //STONES
    if(self.manager.heroPoint != nil && isAppActive && self.isGameStarted)
    {
        NSInteger stonesCount = [[self.manager.objectsDictionary objectForKey:@STONE] count];
        
        for (NSInteger i = 0; i <= stonesCount - 1; i++)
        {
            MyPoint* currentPoint = [self.manager.objectsDictionary objectForKey:@STONE][i];
            
            MyPoint* nextPoint = [MyPoint pointWithX:currentPoint.x + 1 andY:currentPoint.y];
            
            //if nextPoint is not busy
            if ([self.manager canMoveDownObjectInPoint:nextPoint])
            {
                //move down
                [self.board moveCellFromPoint:currentPoint toPoint:nextPoint];
                [self.manager moveObjectFromPoint:currentPoint toPoint:nextPoint];
                
                self.stonesFallingSituation[i] = @YES;
            }
            else
            {
                if([self.stonesFallingSituation[i] integerValue] == YES && [self.manager isObjectExplosiveFromHitInPoint:nextPoint])
                {
                    //explosion
                    NSMutableArray* array = [self.manager explodeInPoint:currentPoint];
                    
                    [self.board explodeWithArray:array];
                    
                    //remove stone from _stonesFallingSituation
                    [self.stonesFallingSituation removeObjectAtIndex:i];
                    
                    //back for loop one step
                    i--;
                    
                    stonesCount = [[self.manager.objectsDictionary objectForKey:@STONE] count];
                
                    //sound
                    [self playSoundWithSoundName:@"explosion"];
                }
                else//if hits the ground
                {
                    //sound
                    if([self.stonesFallingSituation[i] boolValue] == YES)
                        [self playSoundWithSoundName:@"fellDown"];
                        
                    self.stonesFallingSituation[i] = @NO;
                }
            }
        }
        
        
        //OXYGENS
        NSInteger oxygensCount = [[self.manager.objectsDictionary objectForKey:@OXYGEN] count];
        
        for (NSInteger i = 0; i <= oxygensCount - 1; i++)
        {
            MyPoint* currentPoint = [self.manager.objectsDictionary objectForKey:@OXYGEN][i];
            
            MyPoint* nextPoint = [MyPoint pointWithX:currentPoint.x + 1 andY:currentPoint.y];
            
            NSInteger nextPointValue = [self.manager getValueInPoint:nextPoint];
            
            // if nextPoint is empty
            if ([self.manager canMoveDownObjectInPoint:nextPoint])
            {
                //move down oxygen
                [self.board moveCellFromPoint:currentPoint toPoint:nextPoint];
                [self.manager moveObjectFromPoint:currentPoint toPoint:nextPoint];
                
                self.oxygensFallingSituation[i] = @YES;
            }
            else
            {
                if([self.oxygensFallingSituation[i] integerValue] == YES && [self.manager isObjectExplosiveFromHitInPoint:nextPoint])
                {
                    //explosion
                    NSMutableArray* array = [self.manager explodeInPoint:currentPoint];
                    
                    [self.board explodeWithArray:array];
                    
                    //remove oxygen from _oxygensFallingSituation
                    [self.oxygensFallingSituation removeObjectAtIndex:i];
                    
                    oxygensCount = [[self.manager.objectsDictionary objectForKey:@OXYGEN] count];
                    
                    //back for loop one step
                    i--;
                    
                    //sound
                    [self playSoundWithSoundName:@"explosion"];
                }
                else
                {
                    if(nextPointValue == EXIT)
                    {
                        [self.board removeCellInPoint:currentPoint];
                        [self.manager removeObjectInPoint:currentPoint];
                        
                        //remove oxygen from _oxygensFallingSituation
                        [self.oxygensFallingSituation removeObjectAtIndex:i];
                        
                        //back for loop one step
                        i--;
                        
                        oxygensCount--;
                        
                        self.numberOfOxygens--;
                        
                        //check for open the exit
                        if(self.numberOfOxygens == 0)
                            [self.board openExit];
                    }
                    else//if hits the ground
                    {
                        //sound
                        if([self.oxygensFallingSituation[i] boolValue] == YES)
                            [self playSoundWithSoundName:@"fellDown"];
                        
                        self.oxygensFallingSituation[i] = @NO;
                    }
                }
            }
        }
        
        //BOMBS
        NSInteger bombsCount = [[self.manager.objectsDictionary objectForKey:@BOMB] count];
        
        for (NSInteger i = 0; i <= bombsCount - 1; i++)
        {
            MyPoint* currentPoint = [self.manager.objectsDictionary objectForKey:@BOMB][i];
            
            MyPoint* nextPoint = [MyPoint pointWithX:currentPoint.x + 1 andY:currentPoint.y];
            
            //if nextPoint is GRASS
            if ([self.manager canMoveDownObjectInPoint:nextPoint])
            {
                //move down bomb
                [self.board moveCellFromPoint:currentPoint toPoint:nextPoint];
                [self.manager moveObjectFromPoint:currentPoint toPoint:nextPoint];
                
                self.bombsFallingSituation[i] = @YES;
            }
            else if([self.bombsFallingSituation[i] integerValue] == YES)
            {
                //explosion
                NSMutableArray* array = [self.manager explodeInPoint:currentPoint];
                
                [self.board explodeWithArray:array];
                
                [self.bombsFallingSituation removeObjectAtIndex:i];
                
                bombsCount = [[self.manager.objectsDictionary objectForKey:@BOMB] count];
                
                //back for loop one step
                i--;
                
                //sound
                [self playSoundWithSoundName:@"explosion"];
            }
        }
        
        
        //KEY
        MyPoint* currentPoint = self.manager.keyPoint;
        
        MyPoint* nextPoint = [MyPoint pointWithX:currentPoint.x + 1 andY:currentPoint.y];
        
        // if nextPoint is empty
        if ([self.manager canMoveDownObjectInPoint:nextPoint])
        {
            //move key down
            [self.board moveCellFromPoint:currentPoint toPoint:nextPoint];
            [self.manager moveObjectFromPoint:currentPoint toPoint:nextPoint];
        }
        
        
        //monsters move slower
        static NSInteger counter;
        
        if(counter < MONSTERS_SPEED)
            counter++;
        else
            counter = 0;
        
        if (counter == 0)
        {
            //STRONG_MONSTERS
            NSInteger strongMonstersCount = [[self.manager.objectsDictionary objectForKey:@STRONG_MONSTER] count];
            
            for (NSInteger i = 0; i <= strongMonstersCount - 1; i++)
            {
                MyPoint* currentPoint = [self.manager.objectsDictionary objectForKey:@STRONG_MONSTER][i];
                
                NSInteger currentPointValue = [self.manager getValueInPoint:currentPoint];
                
                MyPoint* nextPoint = [self.manager getStepForStrongMonsterWithIndex:i andPoint:currentPoint];
                
                if(nextPoint)
                {
                    if([nextPoint isEqualToPoint:self.manager.heroPoint])
                    {
                        //stop hero
                        self.isHeroMoving = NO;
                        
                        //explosion , hero died
                        NSMutableArray* array = [self.manager explodeInPoint:self.manager.heroPoint];
                        
                        [self.board explodeWithArray:array];
                       
                        //sound
                        [self playSoundWithSoundName:@"explosion"];
                    }
                    else
                    {
                        //move monster
                        NSInteger direction =[self.manager.strongMonstersMovementDirections[i] integerValue];
                        
                        NSString* imageName = [NSString stringWithFormat:@"image%li-%li",(long)currentPointValue,(long)direction];
                        
                        [self.board removeCellInPoint:currentPoint];
                        
                        [self.board updateCellWithPoint:nextPoint andImageName:imageName];
                        
                        [self.manager moveObjectFromPoint:currentPoint toPoint:nextPoint];
                    }
                }
            }
            
            
            //WEAK_MONSTER
            NSInteger weakMonstersCount = [[self.manager.objectsDictionary objectForKey:@WEAK_MONSTER] count];
            
            for (NSInteger i = 0; i <= weakMonstersCount - 1; i++)
            {
                MyPoint* currentPoint = [self.manager.objectsDictionary objectForKey:@WEAK_MONSTER][i];
                
                MyPoint* nextPoint = [self.manager getStepForWeakMonsterInPoint:currentPoint];
                
                if(nextPoint)
                {
                    if([nextPoint isEqualToPoint:self.manager.heroPoint])
                    {
                        //stop hero
                        self.isHeroMoving = NO;
                        
                        //explosion , hero died
                        NSMutableArray* array = [self.manager explodeInPoint:self.manager.heroPoint];
                        
                        [self.board explodeWithArray:array];
                       
                        //sound
                        [self playSoundWithSoundName:@"explosion"];
                    }
                    else
                    {
                        //move monster
                        [self.board moveCellFromPoint:currentPoint toPoint:nextPoint];
                        
                        [self.manager moveObjectFromPoint:currentPoint toPoint:nextPoint];
                    }
                }
            }
        }
    }
}


- (void)secondsTimerHandler:(NSTimer*)timer
{
    if(self.isGameStarted && isAppActive)
    {
        self.time -= 1;
        self.timeLabel.text = [NSString stringWithFormat:@"%li", (long)self.time];
        
        //if hero died, delay a bit
        if(self.manager.heroPoint == nil && self.time % 5 == 1)
            [self heroDied];
        else
        {
            //time ended
            if(self.time == 0)
            {
                //explosion, hero died
                NSMutableArray* array = [self.manager explodeInPoint:self.manager.heroPoint];
                
                [self.board explodeWithArray:array];
                
                [self heroDied];
                
                //sound
                [self playSoundWithSoundName:@"explosion"];
            }
        }
        
    }
}
#pragma mark - end


- (void)resetViewController
{
    if(self.gameMode == NEW_GAME)
    {
        //reading level info from file
        GameLevel* gameLevel = [[GameLevel alloc]init];
        
        gameLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:self.arrayOfLevelsFilesPaths[self.level - 1]];
        
        //reset _manager
        [self.manager resetManagerForLevel:gameLevel];
        
        self.time = gameLevel.time;
    }
    else if(self.gameMode == CONTINUE)
    {
        //read info from continue file
        GameParameters* parameters = [NSKeyedUnarchiver unarchiveObjectWithFile:self.continueFilePath];
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:self.continueFilePath error:nil];
        
        //reset manager
        [self.manager resetManagerForContinueTheGame:parameters];
        
        //set parameters
        self.time = parameters.time;
        
        self.lives = parameters.lives;
        
        self.level = parameters.level;
        
        self.gameMode = NEW_GAME;
    }
    
    //toolbar
    self.timeLabel.text = [NSString stringWithFormat:@"%li", (long)self.time];
    self.levelLabel.text = [NSString stringWithFormat:@"%li", (long)self.level];
    self.livesLabel.text = [NSString stringWithFormat:@"%li", (long)self.lives];
    self.scoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.manager.score];
    
    self.board.frame = CGRectMake(0, 0, self.boardView.frame.size.width, self.boardView.frame.size.height);
    [self.board reset];
    
    //init _stonesFallingSituation
    self.stonesFallingSituation = [NSMutableArray array];
    NSInteger stonesCount = [[self.manager.objectsDictionary objectForKey:@STONE] count];
    for(NSInteger i = 0; i <= stonesCount - 1; i++)
        [_stonesFallingSituation addObject:@NO];
    
    //init _oxygensFallingSituation
    self.oxygensFallingSituation = [NSMutableArray array];
    NSInteger oxygensCount = [[self.manager.objectsDictionary objectForKey:@OXYGEN] count];
    for(NSInteger i = 0; i <= oxygensCount - 1; i++)
        [_oxygensFallingSituation addObject:@NO];
    self.numberOfOxygens = oxygensCount;
    
    //init _bombsFallingSituation
    self.bombsFallingSituation = [NSMutableArray array];
    NSInteger bombsCount = [[self.manager.objectsDictionary objectForKey:@BOMB] count];
    for(NSInteger i = 0; i <= bombsCount - 1; i++)
        [_bombsFallingSituation addObject:@NO];
    
    self.heroStep = 0;
    
    self.isHeroMoving = NO;
    
    self.isGameStarted = NO;
}

- (void)levelCompleted
{
    //stop timers
    self.isGameStarted = NO;
    
    self.level++;
    
    [self.manager addScoreWithLeftSeconds:self.time];
    
    [self performSegueWithIdentifier:@"scoreVC" sender:self];
}

- (void)levelStarted
{
    if(self.manager.heroPoint != nil)
    {
        //alert with level information, action START
        self.startAlert.message = [NSString stringWithFormat:@"level %li", (long)self.level];
        
        [self presentViewController:self.startAlert animated:YES completion:nil];
    }
    else
        self.isGameStarted = YES;
}

- (void)heroDied
{
    //stop timers
    self.isGameStarted = NO;
    
    self.lives--;
    
    if(self.lives == 0)
    {
        //end of game, present lose alert
        self.livesLabel.text =[NSString stringWithFormat:@"%li", (long)self.lives];
        
        [self presentViewController:self.loseAlert animated:YES completion:nil];
    }
    else
    {
        //restart level
        [self resetViewController];
        
        [self levelStarted];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[LevelCompletedViewController class]])
    {
        LevelCompletedViewController* levelCompletedVC = (LevelCompletedViewController*)[segue destinationViewController];
        
        levelCompletedVC.delegate = self;
        
        levelCompletedVC.timeBonus = self.time;
        
        levelCompletedVC.score = self.manager.score;
        
        levelCompletedVC.level = self.level;
    }
}

#pragma mark - IBActions
- (IBAction)suicideButtonAction:(id)sender
{
    if(self.manager.heroPoint != nil)
    {
        //explosion, hero died
        NSMutableArray* array = [self.manager explodeInPoint:self.manager.heroPoint];
        
        [self.board explodeWithArray:array];
        
        self.isHeroMoving = NO;
        
        //sound
        [self playSoundWithSoundName:@"explosion"];
    }
}

- (IBAction)quitButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DismissViewControllerProtocol
- (void)viewControllerDismissed:(LevelCompletedViewController *)viewController
{
    self.isTimeToDismissVC = YES;
}

#pragma mark - BoardViewDelegate
- (void)boardView:(BoardView *)view swipedFromPoint:(MyPoint *)point1 toPoint:(MyPoint *)point2
{
    if(!self.isHeroMoving && [point1 isEqualToPoint:self.manager.heroPoint] && point2.x >= 0 && point2.x < self.manager.numberOfRows && point2.y >= 0 && point2.y < self.manager.numberOfColumns && ![point1 isEqualToPoint:point2])
    {
        self.pathForHero = [self.manager getPathForHeroFromPoint:point1 toPoint:point2];
        
        if(self.pathForHero)
            self.isHeroMoving = YES;
    }
}

#pragma mark - soundPlayerFunction
- (void)playSoundWithSoundName:(NSString*)soundName
{
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self.soundsDictionary objectForKey:soundName] error:nil];
    
    [self.audioPlayer play];
}

@end
