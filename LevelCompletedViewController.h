//
//  LevelCompletedViewController.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/16/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyResult.h"
#import "Constants.h"
#import "SaveScoreViewController.h"

@class LevelCompletedViewController;

@protocol DismissViewControllerProtocol <NSObject>

- (void)viewControllerDismissed:(LevelCompletedViewController*)viewController;

@end


@interface LevelCompletedViewController : UIViewController

@property (weak) id<DismissViewControllerProtocol> delegate;

@property NSInteger timeBonus;

@property NSInteger score;

@property NSInteger level;

@end
