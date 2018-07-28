//
//  MyResult.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/16/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "MyResult.h"

@implementation MyResult

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:@"name"];
    
    [encoder encodeObject:@(_score) forKey:@"score"];
    
    [encoder encodeObject:@(_level) forKey:@"level"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        _name = [decoder decodeObjectForKey:@"name"];
        
        _score = [[decoder decodeObjectForKey:@"score"] integerValue];
        
        _level = [[decoder decodeObjectForKey:@"level"] integerValue];
    }
    return self;
}






@end
