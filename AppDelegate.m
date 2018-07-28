//
//  AppDelegate.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/4/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "AppDelegate.h"
#import "GameLevel.h"
#import "MyResult.h"
#import "GameParameters.h"
#import "Constants.h"

extern BOOL isAppActive;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //opening files
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = [paths objectAtIndex:0];
    
    
    //level1
    NSString* fileName = @"level1.txt";
    NSString* filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath: filePath] == NO)
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
        GameLevel* level1 = [[GameLevel alloc]init];
        level1.board = [NSMutableArray arrayWithObjects:
                        [@[@3, @3, @3, @3, @3, @3, @3, @3] mutableCopy],
                        [@[@3, @1, @1,@10 ,@1, @1, @1, @3] mutableCopy],
                        [@[@3, @1, @3, @3, @3,@14, @1, @3] mutableCopy],
                        [@[@3, @1, @3, @1, @3, @2, @5, @3] mutableCopy],
                        [@[@3, @1, @3, @1, @3, @2, @1, @3] mutableCopy],
                        [@[@3, @1, @2, @1, @1, @2, @1, @3] mutableCopy],
                        [@[@3,@15, @1,@11, @1, @6, @1, @3] mutableCopy],
                        [@[@3, @3, @3, @3, @3, @3, @3, @3] mutableCopy],nil];
        level1.time = 30;
        [NSKeyedArchiver archiveRootObject:level1 toFile:filePath];
    }
    
    //level2
    fileName = @"level2.txt";
    filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath: filePath] == NO)
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
        GameLevel* level2 = [[GameLevel alloc]init];
        level2.board = [NSMutableArray arrayWithObjects:
                        [@[@3, @3, @3, @3, @3, @3, @3, @3, @3, @3, @3, @3] mutableCopy],
                        [@[@3,@15, @1,@14, @1, @1, @1, @3,@12, @1, @1, @3] mutableCopy],
                        [@[@3, @2, @2, @2, @1, @1, @1, @3, @1, @1, @1, @3] mutableCopy],
                        [@[@3, @1, @1, @1, @1, @1, @1, @3, @1,@11, @1, @3] mutableCopy],
                        [@[@3, @1, @1,@14, @1, @1, @1, @3, @1,@14, @1, @3] mutableCopy],
                        [@[@3, @2, @2, @2, @1, @1, @1, @3, @1, @2, @2, @3] mutableCopy],
                        [@[@3, @1, @1, @1, @1, @1, @1, @3, @1, @1, @1, @3] mutableCopy],
                        [@[@3, @1, @1,@14, @1, @1, @1, @3, @1,@13, @1, @3] mutableCopy],
                        [@[@3, @2, @2, @2, @1, @1, @1, @3, @1, @2, @2, @3] mutableCopy],
                        [@[@3, @1, @1, @1, @1, @1, @1, @3, @1, @1, @1, @3] mutableCopy],
                        [@[@3, @1, @1, @1, @1, @1, @1, @3, @1, @1, @1, @3] mutableCopy],
                        [@[@3, @1, @1, @1, @1, @1,@10, @1, @1, @1, @1, @3] mutableCopy],
                        [@[@3, @1, @1, @1, @1, @1, @5, @1, @1, @1, @1, @3] mutableCopy],
                        [@[@3, @3, @3, @3, @3, @3, @6, @3, @3, @3, @3, @3] mutableCopy],
                        nil];
        level2.time = 70;
        [NSKeyedArchiver archiveRootObject:level2 toFile:filePath];
    }


    
    
    //level3
    fileName = @"level3.txt";
    filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath: filePath] == NO)
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
        GameLevel* level3 = [[GameLevel alloc]init];
        level3.board = [NSMutableArray arrayWithObjects:
                        [@[@3, @3, @3, @3, @3, @3, @3, @3, @3, @3, @3, @3, @3, @3, @3] mutableCopy],
                        [@[@3, @1,@13, @1 ,@1, @1, @1, @1, @1, @1, @1, @3, @1, @2, @3] mutableCopy],
                        [@[@3, @1, @2, @2 ,@2, @2, @2, @2, @2, @2, @1, @3, @1, @2, @3] mutableCopy],
                        [@[@3, @1, @1, @1 ,@11, @1, @1, @1, @1, @1, @1, @3, @1, @2, @3] mutableCopy],
                        [@[@3, @1, @1, @4 ,@2,@14, @2,@16, @4, @1, @1, @3,@12, @2, @3] mutableCopy],
                        [@[@3, @1, @1, @4 ,@2, @2, @2, @2, @4, @1, @1, @3, @1, @2, @3] mutableCopy],
                        [@[@3, @1, @1, @4 ,@4, @4, @4, @4, @4, @1, @1, @3,@15, @2, @3] mutableCopy],
                        [@[@3, @1, @1, @1 ,@1, @1, @1, @1, @1, @1, @1, @3, @1, @2, @3] mutableCopy],
                        [@[@3, @1,@14, @1 ,@1, @1,@10, @1, @1,@14, @1, @3, @2, @2, @3] mutableCopy],
                        [@[@3, @2, @2, @2 ,@2, @3, @5, @3, @2, @2, @2, @3, @1, @2, @3] mutableCopy],
                        [@[@3, @2, @2, @2 ,@2, @3, @1, @3, @2, @2,@16,@16,@16, @2, @3] mutableCopy],
                        [@[@3, @3, @3, @3, @3, @3, @6, @3, @3, @3, @3, @3, @3, @3, @3] mutableCopy],nil];
        level3.time = 60;
        [NSKeyedArchiver archiveRootObject:level3 toFile:filePath];
    }
    

    //hall of fame file
    fileName = @"hallOfFame.txt";
    filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath: filePath] == NO)
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
        NSMutableArray* scoresArray = [NSMutableArray array];
        
        for(NSInteger i = 0; i <= NUMBER_OF_SCORES_IN_HALL_OF_FAME - 1; i++)
        {
            MyResult* result = [[MyResult alloc]init];
            [scoresArray addObject:result];
        }
        
        [NSKeyedArchiver archiveRootObject:scoresArray toFile:filePath];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    isAppActive = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    isAppActive = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "-.EscapeTheZoo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EscapeTheZoo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EscapeTheZoo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
