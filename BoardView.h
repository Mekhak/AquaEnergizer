//
//  BoardView.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/6/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"

@class BoardView;

@protocol BoardViewDelegate <NSObject>

- (void)boardView:(BoardView*)view swipedFromPoint:(MyPoint*)point1 toPoint:(MyPoint*) point2;

@end

@interface BoardView : UIView

@property (weak)id<BoardViewDelegate> delegate;

- (void)reset;

- (void)moveCellFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2;

- (void)removeCellInPoint:(MyPoint*)point;

- (void)updateCellWithPoint:(MyPoint*)point andImageName:(NSString*)string;

- (void)explodeWithArray:(NSArray*)explodedPoints;

- (void)moveHeroFromPoint:(MyPoint*)point1 toPoint:(MyPoint*)point2;

- (void)openExit;

@end
