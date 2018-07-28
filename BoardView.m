//
//  BoardView.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/6/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "BoardView.h"

@interface BoardView()

@property Manager* manager;

@property NSMutableArray* board;//matrix of imageViews

@property MyPoint* currentPoint;

@property MyPoint* destinationPoint;

//key - image name that used in project, objetc - real image name(in Assets.scassets)
@property NSMutableDictionary* imagesNamesDictionary;

@end


@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    _manager = [Manager sharedInstance];

    self = [super initWithFrame:frame];
    
    if(self)
    {
         _imagesNamesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"grass",@"image1", @"tree",@"image2", @"wall",@"image3", @"wood",@"image4", @"gate",@"image5", @"exit",@"image6", @"hero",@"image10", @"strongMonster1",@"image11", @"strongMonster1",@"image11-1", @"strongMonster2",@"image11-2", @"strongMonster3",@"image11-3", @"strongMonster4",@"image11-4", @"weakMonster",@"image12", @"stone",@"image13", @"oxygen",@"image14", @"key",@"image15", @"bomb",@"image16", @"explosionFire",@"imageFire", @"openedExit",@"openedExit", nil];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    NSInteger row = point.y / (self.frame.size.height / self.manager.numberOfRows);
    
    NSInteger column = point.x / (self.frame.size.width / self.manager.numberOfColumns);
    
    self.currentPoint = [MyPoint pointWithX:row andY:column];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    NSInteger row = point.y / (self.frame.size.height / self.manager.numberOfRows);
    
    NSInteger column = point.x / (self.frame.size.width / self.manager.numberOfColumns);
    
    self.destinationPoint = [MyPoint pointWithX:row andY:column];

    if([self.delegate respondsToSelector:@selector(boardView:swipedFromPoint:toPoint:)])
        [self.delegate boardView:self swipedFromPoint:self.currentPoint toPoint:self.destinationPoint];
}

- (void)moveCellFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2;
{
    [self.board[point2.x][point2.y] setImage:[self.board[point1.x][point1.y] image]];
    
    NSString* imageName = [self.imagesNamesDictionary objectForKey:[NSString stringWithFormat:@"image%li",(long)GRASS]];
    
    [self.board[point1.x][point1.y] setImage:[UIImage imageNamed:imageName]];
}

- (void)removeCellInPoint:(MyPoint *)point
{
    NSString* imageName = [self.imagesNamesDictionary objectForKey:[NSString stringWithFormat:@"image%li",(long)GRASS]];
    
    [self.board[point.x][point.y] setImage:[UIImage imageNamed:imageName]];
}


- (void)updateCellWithPoint:(MyPoint*)point andImageName:(NSString*)string
{
    NSString* imageName = [self.imagesNamesDictionary objectForKey:string];
    
    [self.board[point.x][point.y] setImage:[UIImage imageNamed:imageName]];
}


//animate hero movement
- (void)moveHeroFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2
{
    [self.board[point2.x][point2.y] setImage:[self.board[point1.x][point1.y] image]];
    
    NSString* imageName = [self.imagesNamesDictionary objectForKey:[NSString stringWithFormat:@"image%li",(long)GRASS]];
    
    [self.board[point1.x][point1.y] setImage:[UIImage imageNamed:imageName]];
    
    [self.board[point2.x][point2.y] setAlpha:0.7];

    [UIView animateWithDuration:HERO_MOVEMENT_ANIMATION_DURATION animations:^{
        [self.board[point2.x][point2.y] setAlpha:1];
    } completion:nil];
}

//animate explosion
- (void)explodeWithArray:(NSArray*)explodedPoints
{
    for(NSInteger i = 0; i <= explodedPoints.count - 1; i++)
    {
        MyPoint* point = explodedPoints[i];
        
        [self updateCellWithPoint:point andImageName:@"imageFire"];
    }
    
    for(NSInteger i = 0; i <= explodedPoints.count - 1; i++)
    {
        MyPoint* point = explodedPoints[i];
        
        [UIView animateWithDuration:EXPLOSION_ANIMATION_DURATION animations:^{
            [_board[point.x][point.y] setAlpha:0.3];
        }completion:^(BOOL finished) {
            NSString* imageName = [NSString stringWithFormat:@"image%li", (long)[self.manager getValueInPoint:point]];
            
            [self updateCellWithPoint:point andImageName:imageName];
            
            [_board[point.x][point.y] setAlpha:1];
        }];
    }
}

- (void)openExit
{
    MyPoint* point = [MyPoint pointWithX:self.manager.exitPoint.x - 1 andY:self.manager.exitPoint.y];
    
    [self updateCellWithPoint:point andImageName:@"openedExit"];    
}

- (void)reset
{
    self.board = [NSMutableArray array];

    for(NSInteger i = 0; i <= _manager.numberOfRows - 1; i++)
    {
        [self.board addObject:[NSMutableArray array]];
        
        for(NSInteger j = 0; j <= _manager.numberOfColumns - 1; j++)
        {
            //create imageView
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j * self.frame.size.width / _manager.numberOfColumns, i * self.frame.size.height / _manager.numberOfRows, self.frame.size.width / _manager.numberOfColumns, self.frame.size.height / _manager.numberOfRows)];
            
            MyPoint* point = [MyPoint pointWithX:i andY:j];
            
            NSString* imageName = [_imagesNamesDictionary objectForKey:[NSString stringWithFormat:@"image%li",(long)[_manager getValueInPoint:point]]];
            
            imageView.image = [UIImage imageNamed: imageName];
            
            [self addSubview:imageView];
            
            [self.board[i] addObject:imageView];
        }
    }
}
@end
