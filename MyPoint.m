//
//  MyPoint.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/4/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

+ (instancetype)pointWithX:(NSInteger)x andY:(NSInteger)y
{
    MyPoint* point = [[MyPoint alloc] initWithX:x andY:y];
    
    return point;
}

- (instancetype)initWithX:(NSInteger)x andY:(NSInteger)y;
{
    self = [super init];
    if (self)
    {
        _x = x;
        
        _y = y;
    }
    return self;
}

- (BOOL)isEqualToPoint:(MyPoint*)point
{
    if (self.x == point.x && self.y == point.y)
        return YES;
    
    return NO;
}

- (BOOL)isEqual:(id)object
{
    return [self isEqualToPoint:object];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"(%li %li)", (long)self.x, (long)self.y];    
}

@end
