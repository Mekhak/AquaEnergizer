//
//  ViewController.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/4/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPoint.h"
#import "Manager.h"
#import "BoardView.h"
#import "GameLevel.h"
#import "GameParameters.h"
#import "LevelCompletedViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface PlayViewController : UIViewController<BoardViewDelegate>

@property NSInteger gameMode;//Continue or New Game

@end

