//
//  Manager.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/4/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "Manager.h"

static Manager* _sharedInstance = nil;

@interface Manager()

@property NSMutableArray* matrix;

@property NSMutableArray* explodedPointsArray;

@end


@implementation Manager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Manager alloc] init];
    });
    
    return _sharedInstance;
}


#pragma mark - algorithms

- (MyPoint*)getStepForWeakMonsterInPoint:(MyPoint*)point
{
    MyPoint* nextPoint;
    
    //if in the same vertical
    if(point.y == self.heroPoint.y)
    {
        if(point.x > self.heroPoint.x)
            nextPoint = [MyPoint pointWithX:point.x - 1 andY:point.y];
        else
            nextPoint = [MyPoint pointWithX:point.x + 1 andY:point.y];
    }
    else
    {
        //try to go along horisontal and reach the hero's vertical
        if(point.y < self.heroPoint.y)
            nextPoint = [MyPoint pointWithX:point.x andY:point.y + 1];
        else
            nextPoint = [MyPoint pointWithX:point.x andY:point.y - 1];
        
        //if can't go along horisontal and reach the hero's vertical
        if(![self isPositionAvailableForMonsters:nextPoint])
        {
            //go along vertical and reach the hero's horisontal
            if(point.x < self.heroPoint.x)
                nextPoint = [MyPoint pointWithX:point.x + 1 andY:point.y];
            else if(point.x > self.heroPoint.x)
                nextPoint = [MyPoint pointWithX:point.x - 1 andY:point.y];
            else
                nextPoint = nil;
        }
        
    }
    
    if(nextPoint && [self isPositionAvailableForMonsters:nextPoint])
        return nextPoint;
    return nil;
}


- (MyPoint*)getStepForStrongMonsterWithIndex:(NSInteger)index andPoint:(MyPoint*)point
{
    MyPoint* nextPoint;
    
    NSInteger direction = [self.strongMonstersMovementDirections[index] integerValue];
    
    MyPoint* right;
    
    MyPoint* left;
    
    MyPoint* front;
    
    switch (direction) {
        case RIGHT:
            
            right = [MyPoint pointWithX:point.x + 1 andY:point.y];
            left = [MyPoint pointWithX:point.x - 1 andY:point.y];
            front = [MyPoint pointWithX:point.x andY:point.y + 1];
            break;
            
        case LEFT:
            
            right = [MyPoint pointWithX:point.x - 1 andY:point.y];
            left = [MyPoint pointWithX:point.x + 1 andY:point.y];
            front = [MyPoint pointWithX:point.x andY:point.y - 1];
            break;
            
        case UP:
            
            right = [MyPoint pointWithX:point.x andY:point.y + 1];
            left = [MyPoint pointWithX:point.x andY:point.y - 1];
            front = [MyPoint pointWithX:point.x - 1 andY:point.y];
            break;
            
        case DOWN:
            
            right = [MyPoint pointWithX:point.x andY:point.y - 1];
            left = [MyPoint pointWithX:point.x andY:point.y + 1];
            front = [MyPoint pointWithX:point.x + 1 andY:point.y];
            break;
            
        default:
            break;
    }
    
    //if in the right is obstacle
    if([self isPointObstacleForStrongMonster:right])
    {
        //if in the front is not obstacle
        if(![self isPointObstacleForStrongMonster:front])
            nextPoint = front;
        else
        {
            //rotate left
            direction--;
            
            if(direction < RIGHT)
                direction = UP;
            
            //change direction
            [self.strongMonstersMovementDirections setObject:[NSNumber numberWithInteger:direction] atIndexedSubscript:index];
            
            nextPoint = nil;
        }
    }
    else
    {
        //rotate right
        direction++;
        
        if(direction > UP)
            direction = RIGHT;
        
        //change direction
        [self.strongMonstersMovementDirections setObject:[NSNumber numberWithInteger:direction] atIndexedSubscript:index];
        
        //go right
        nextPoint = right;
    }

    return nextPoint;
}


- (void)explosionInPoint:(MyPoint*)explosionPoint
{
    if(explosionPoint.x == self.numberOfRows - 1 || explosionPoint.y == self.numberOfColumns - 1)
        return;
    
    else
    {
        //travel around the point
        for (NSInteger i = explosionPoint.x - 1; i <= explosionPoint.x + 1; i++)
        {
            for (NSInteger j = explosionPoint.y - 1; j <= explosionPoint.y + 1; j++)
            {
                MyPoint* point = [MyPoint pointWithX:i andY:j];
                
                NSInteger pointValue = [self getValueInPoint:point];
                
                if(![self.explodedPointsArray containsObject:point])
                {
                    [self.explodedPointsArray addObject:point];
                    
                    //remove from matrix
                    if(pointValue != WALL && pointValue != GATE && pointValue != EXIT)
                        [self removeObjectInPoint:point];
                }
                
                //recursive call
                if(pointValue == STONE || pointValue == OXYGEN || pointValue == BOMB || pointValue == STRONG_MONSTER || pointValue == WEAK_MONSTER)
                    [self explosionInPoint:point];
            }
        }
    }
}


- (NSMutableArray*)getPathForHeroFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2
{
    NSMutableArray* path = [NSMutableArray array];
    
    MyPoint* point;
    
    NSInteger firstDirection;
    
    //init firstDirection
    if(labs(point2.x - point1.x) < labs(point2.y - point1.y))
        firstDirection = HORIZONTAL;
    else
        firstDirection = VERTICAL;
    
    if(firstDirection == HORIZONTAL)
    {
        if(point2.y > point1.y)//right
        {
            for (NSInteger i = point1.y + 1; i <= point2.y; i++)
            {
                point = [MyPoint pointWithX:point1.x andY:i];
                if([self canMoveHeroToPoint:point] || [self isMoveableObjectInPoint:point])
                    [path addObject:point];
                else
                    break;
            }
        }
        else//left
        {
            for (NSInteger i = point1.y - 1; i >= point2.y; i--)
            {
                point = [MyPoint pointWithX:point1.x andY:i];
                if([self canMoveHeroToPoint:point] || [self isMoveableObjectInPoint:point])
                    [path addObject:point];
                else
                    break;
            }
        }
    }
    else//if(firstDirection == VERTICAL)
    {
        if(point2.x > point1.x)//down
        {
            for (NSInteger i = point1.x + 1; i <= point2.x; i++)
            {
                point = [MyPoint pointWithX:i andY:point1.y];
                if([self canMoveHeroToPoint:point])
                    [path addObject:point];
                else
                    break;
            }
        }
        else//up
        {
            for (NSInteger i = point1.x - 1; i >= point2.x; i--)
            {
                point = [MyPoint pointWithX:i andY:point1.y];
                if([self canMoveHeroToPoint:point])
                    [path addObject:point];
                else
                    break;
            }
        }
    }
    
    //if the way is closed
    if(path.count == 0)
        return nil;
    
    if(firstDirection == VERTICAL)
    {
        //is hero reached to secondDirection?
        if([path[path.count - 1] isEqualToPoint:[MyPoint pointWithX:point2.x andY:point1.y]])
        {
            if(point2.y > point1.y)//right
            {
                for (NSInteger i = point1.y + 1; i <= point2.y; i++)
                {
                    point = [MyPoint pointWithX:point2.x andY:i];
                    if([self canMoveHeroToPoint:point] || [self isMoveableObjectInPoint:point])
                        [path addObject:point];
                    else
                        break;
                }
            }
            else//left
            {
                for (NSInteger i = point1.y - 1; i >= point2.y; i--)
                {
                    point = [MyPoint pointWithX:point2.x andY:i];
                    if([self canMoveHeroToPoint:point] || [self isMoveableObjectInPoint:point])
                        [path addObject:point];
                    else
                        break;
                }
            }
        }
    }
    else
    {
        if([path[path.count - 1] isEqualToPoint:[MyPoint pointWithX:point1.x andY:point2.y]])
        {
            if(point2.x > point1.x)//down
            {
                for (NSInteger i = point1.x + 1; i <= point2.x; i++)
                {
                    point = [MyPoint pointWithX:i andY:point2.y];
                    if([self canMoveHeroToPoint:point])
                        [path addObject:point];
                    else
                        break;
                }
            }
            else//up
            {
                for (NSInteger i = point1.x - 1; i >= point2.x; i--)
                {
                    point = [MyPoint pointWithX:i andY:point2.y];
                    if([self canMoveHeroToPoint:point])
                        [path addObject:point];
                    else
                        break;
                }
            }
        }
    }
    
    return path;
}
#pragma mark - end of algorithms

- (NSInteger)getValueInPoint:(MyPoint*)point
{
    return [self.matrix[point.x][point.y] integerValue];
}


- (BOOL)canMoveHeroToPoint:(MyPoint*)point
{
    NSInteger value = [self.matrix[point.x][point.y] integerValue];
    
    if(value == GRASS || value == TREE || value == KEY || value == STRONG_MONSTER || value == WEAK_MONSTER)
        return YES;
    
    return NO;
}

- (BOOL)canHeroMoveObjectInPoint:(MyPoint*)point1 ToPoint:(MyPoint*)point2
{
    NSInteger value1 = [self.matrix[point1.x][point1.y] integerValue];
    
    NSInteger value2 = [self.matrix[point2.x][point2.y] integerValue];
    
    if(point1.x == point2.x && (value1 == STONE || value1 == OXYGEN || value1 == BOMB))
    {
        if(value2 == GRASS)
            return YES;
    }
    
    return NO;
}

- (void)moveHeroToPoint:(MyPoint*)point
{
    self.matrix[self.heroPoint.x][self.heroPoint.y] = @(GRASS);
    
    self.matrix[point.x][point.y] = @(HERO);
    
    _heroPoint = point;
}

- (void)removeObjectInPoint:(MyPoint*)point
{
    if([point isEqualToPoint:self.heroPoint])
        _heroPoint = nil;
    
    else
    {
        NSInteger value = [self getValueInPoint:point];
        
        if(value == STRONG_MONSTER || value == WEAK_MONSTER || value == STONE || value == OXYGEN || value == BOMB)
            //update _objectsDictionary
            [[self.objectsDictionary objectForKey:@(value)] removeObject:point];
        
        else if([point isEqualToPoint:self.gatePoint])
            _gatePoint = nil;
        
        else if([point isEqualToPoint:self.keyPoint])
            _keyPoint = nil;
    }
    
    self.matrix[point.x][point.y] = @(GRASS);
}

//moves all movable objects besides of the HERO
- (void)moveObjectFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2
{
    NSInteger point1Value = [self getValueInPoint:point1];
    
    if(point1Value == STRONG_MONSTER || point1Value == WEAK_MONSTER || point1Value == STONE || point1Value == OXYGEN || point1Value == BOMB)//update _objectsDictionary
    {
        NSInteger index = [[_objectsDictionary objectForKey:@(point1Value)]  indexOfObject:point1];
        
        [[self.objectsDictionary objectForKey:@(point1Value)] setObject:point2 atIndex:index];
    }
    
    else if(point1Value == KEY)
        _keyPoint = point2;
    
    //update _matrix
    self.matrix[point2.x][point2.y] = self.matrix[point1.x][point1.y];
    
    self.matrix[point1.x][point1.y] = [NSNumber numberWithInteger:GRASS];
}

- (BOOL)canMoveDownObjectInPoint:(MyPoint*)point
{
    if([self getValueInPoint:point] == GRASS)
        return YES;
    return NO;
}

- (BOOL)isMonsterInPoint:(MyPoint*)point
{
    NSInteger value = [self.matrix[point.x][point.y] integerValue];
    
    if(value == WEAK_MONSTER || value == STRONG_MONSTER)
        return YES;
    return NO;
}

- (BOOL)isObjectExplosiveFromHitInPoint:(MyPoint*)point
{
    NSInteger value = [self.matrix[point.x][point.y] integerValue];
    
    if(value == HERO || value == STRONG_MONSTER || value == WEAK_MONSTER || value ==BOMB)
        return YES;
    return NO;
}


//for changing level
- (void)resetManagerForLevel:(GameLevel *)level;
{
    self.matrix = [level.board mutableCopy];
    
    _numberOfRows = self.matrix.count;
    
    _numberOfColumns = [self.matrix[0] count];
    
    [self reset];
}


//for continue the game
- (void)resetManagerForContinueTheGame:(GameParameters*)parameters
{
    self.matrix = [parameters.board mutableCopy];
    
    _numberOfRows = self.matrix.count;
    
    _numberOfColumns = [self.matrix[0] count];
    
    [self reset];
    
    _score = parameters.score;
    
    _strongMonstersMovementDirections = [parameters.strongMonstersMovementDirections mutableCopy];
}

//for saving the required info for continue the game
- (void)saveParameters:(GameParameters*)parameters
{
    parameters.board = [self.matrix mutableCopy];
    
    parameters.strongMonstersMovementDirections = [self.strongMonstersMovementDirections mutableCopy];
    
    parameters.score = self.score;
}

- (NSMutableArray*)explodeInPoint:(MyPoint*)explosionPoint
{
    self.explodedPointsArray = [NSMutableArray array];
    
    [self explosionInPoint:explosionPoint];
    
    return self.explodedPointsArray;
}

- (void)addScoreWithLeftSeconds:(NSInteger)leftSeconds
{
    _score += leftSeconds;
}

- (void)resetScore
{
    _score = 0;
}



#pragma mark-Private methods

- (BOOL)isMoveableObjectInPoint:(MyPoint*)point//for hero movement algorithm
{
    NSInteger value = [self.matrix[point.x][point.y] integerValue];
    if(value == STONE || value == OXYGEN || value == BOMB)
        return YES;
    return NO;
}

- (BOOL)isPositionAvailableForMonsters:(MyPoint*)point
{
    NSInteger value = [self.matrix[point.x][point.y] integerValue];
    if(value == GRASS || [point isEqualToPoint:self.heroPoint])
        return YES;
    return NO;
}

- (BOOL)isPointObstacleForStrongMonster:(MyPoint*)point
{
    NSInteger value = [self.matrix[point.x][point.y] integerValue];
    if(value == GRASS || value == HERO)
        return NO;
    return YES;
}

- (void)reset
{
    NSMutableArray* strongMonstresArray = [NSMutableArray array];
    NSMutableArray* weakMonstersArray = [NSMutableArray array];
    NSMutableArray* stonesArray = [NSMutableArray array];
    NSMutableArray* oxygensArray = [NSMutableArray array];
    NSMutableArray* bombsArray = [NSMutableArray array];
    
    //init _objectsDictionary
    _objectsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:strongMonstresArray,@(STRONG_MONSTER), weakMonstersArray,@(WEAK_MONSTER), stonesArray,@(STONE), oxygensArray,@(OXYGEN), bombsArray,@(BOMB),  nil];
    
    for(NSInteger i = 0; i <= self.numberOfRows - 1; i++)
    {
        for(NSInteger j = 0; j <= self.numberOfColumns - 1; j++)
        {
            MyPoint* point = [MyPoint pointWithX:i andY:j];
            
            NSInteger value = [_matrix[i][j] integerValue];
            
            if(value == HERO)
                _heroPoint = point;
            else if(value == GATE)
                _gatePoint = point;
            else if(value == KEY)
                _keyPoint = point;
            else if(value == EXIT)
                _exitPoint = point;
            else if(value == STRONG_MONSTER || value == WEAK_MONSTER || value == STONE || value == OXYGEN || value == BOMB)
                [[_objectsDictionary objectForKey:@(value)] addObject:point];
        }
    }
    
    _strongMonstersMovementDirections = [NSMutableArray array];
    
    NSInteger strongMonstersCount = [[_objectsDictionary objectForKey:@STRONG_MONSTER] count];
    
    for(NSInteger i = 0; i <= strongMonstersCount - 1; i++)
        [_strongMonstersMovementDirections addObject:@RIGHT];
    
    _explodedPointsArray = [NSMutableArray array];
}


@end
