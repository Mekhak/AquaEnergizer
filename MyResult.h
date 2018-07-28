//
//  MyResult.h
//  EscapeTheZoo
//
//  Created by Mekhak on 9/16/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <Foundation/Foundation.h>

//used for combining a score in a MyScore object, and then preserving in file
@interface MyResult : NSObject

@property NSString* name;

@property NSInteger score;

@property NSInteger level;

@end
