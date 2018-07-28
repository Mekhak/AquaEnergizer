//
//  SaveScoreViewController.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/16/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MyResult.h"

@class SaveScoreViewController;

@protocol SaveScoreViewControllerDelegate <NSObject>

- (void)saveScoreViewControllerSaveButtonPressed:(SaveScoreViewController*)saveScoreVC;

@end


@interface SaveScoreViewController : UIViewController<UITextFieldDelegate>

@property NSInteger score;

@property NSInteger level;

@property (weak) id<SaveScoreViewControllerDelegate> delegate;

@end
