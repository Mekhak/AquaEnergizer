//
//  Manager.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/4/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPoint.h"
#import "Constants.h"
#import "GameLevel.h"
#import "GameParameters.h"

@interface Manager : NSObject

@property (readonly)NSInteger numberOfRows;

@property (readonly)NSInteger numberOfColumns;

//positions
@property (readonly,copy)MyPoint* heroPoint;

@property (readonly,copy)MyPoint* gatePoint;

@property (readonly,copy)MyPoint* keyPoint;

@property (readonly,copy)MyPoint* exitPoint;

//dictionary of arrays with correspondent keys
@property (readonly,copy)NSMutableDictionary* objectsDictionary;

//indicates the direction of strong monster in appropriate index
@property (readonly,copy)NSMutableArray* strongMonstersMovementDirections;

@property (readonly)NSInteger score;


+ (instancetype)sharedInstance;

- (NSInteger)getValueInPoint:(MyPoint*)point;

- (NSMutableArray*)getPathForHeroFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2;

- (BOOL)canMoveHeroToPoint:(MyPoint*)point;

- (void)moveHeroToPoint:(MyPoint*)point;

- (BOOL)canHeroMoveObjectInPoint:(MyPoint*)point1 ToPoint:(MyPoint*)point2;

- (void)removeObjectInPoint:(MyPoint*)point;

- (BOOL)canMoveDownObjectInPoint:(MyPoint*)point;

- (void)moveObjectFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2;

- (BOOL)isMonsterInPoint:(MyPoint*)point;

- (BOOL)isObjectExplosiveFromHitInPoint:(MyPoint*)point;

- (MyPoint*)getStepForStrongMonsterWithIndex:(NSInteger)index andPoint:(MyPoint*)point;

- (MyPoint*)getStepForWeakMonsterInPoint:(MyPoint*)point;

- (NSMutableArray*)explodeInPoint:(MyPoint*)point;

- (void)resetManagerForLevel:(GameLevel*)level;

- (void)resetManagerForContinueTheGame:(GameParameters*)parameters;

- (void)saveParameters:(GameParameters*)parameters;

- (void)addScoreWithLeftSeconds:(NSInteger)leftSeconds;

- (void)resetScore;

@end
