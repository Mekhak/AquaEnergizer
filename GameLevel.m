//
//  GameLevel.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/14/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "GameLevel.h"

@implementation GameLevel

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_board forKey:@"board"];
    
    [encoder encodeObject:@(_time) forKey:@"time"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        _board = [decoder decodeObjectForKey:@"board"];
        
        _time = [[decoder decodeObjectForKey:@"time"] integerValue];
    }
    return self;
}


@end
