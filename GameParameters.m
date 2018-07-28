//
//  GameParameters.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/22/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "GameParameters.h"

@implementation GameParameters

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_board forKey:@"board"];
    
    [encoder encodeObject:_strongMonstersMovementDirections forKey:@"strongMonstersMovementDirections"];
    
    [encoder encodeObject:@(_lives) forKey:@"lives"];
    
    [encoder encodeObject:@(_score) forKey:@"score"];
    
    [encoder encodeObject:@(_level) forKey:@"level"];
    
    [encoder encodeObject:@(_time) forKey:@"time"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        _board = [decoder decodeObjectForKey:@"board"];
        
        _strongMonstersMovementDirections = [decoder decodeObjectForKey:@"strongMonstersMovementDirections"];
        
        _lives = [[decoder decodeObjectForKey:@"lives"] integerValue];
        
        _score = [[decoder decodeObjectForKey:@"score"] integerValue];
        
        _level = [[decoder decodeObjectForKey:@"level"] integerValue];
        
        _time = [[decoder decodeObjectForKey:@"time"] integerValue];
    }
    return self;
}

@end
