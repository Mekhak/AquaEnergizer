//
//  MyPoint.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/4/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPoint : NSObject

@property NSInteger x;

@property NSInteger y;

+ (instancetype)pointWithX:(NSInteger)x andY:(NSInteger)y;

- (BOOL)isEqualToPoint:(MyPoint*)point;

@end
