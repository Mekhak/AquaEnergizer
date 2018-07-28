//
//  GameParameters.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/22/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <Foundation/Foundation.h>

//used for combining a level information in a GameParameters object and then saving in the file for saving and loading the game

@interface GameParameters : NSObject

@property NSArray* board;

@property NSArray* strongMonstersMovementDirections;

@property NSInteger lives;

@property NSInteger score;

@property NSInteger level;

@property NSInteger time;

@end
