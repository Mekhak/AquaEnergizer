//
//  GameLevel.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/14/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <Foundation/Foundation.h>

//used for combining a level in a GameLevel object, and then preserving in file
@interface GameLevel : NSObject

@property NSArray* board;

@property NSInteger time;

@end
