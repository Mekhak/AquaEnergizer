//
//  HallOfFameViewController.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/17/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "HallOfFameViewController.h"

@interface HallOfFameViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray* tableViewData;

@end

@implementation HallOfFameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    
    //read table view data in _tableViewData
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString* fileName = @"hallOfFame.txt";
    NSString* filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    self.tableViewData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUMBER_OF_SCORES_IN_HALL_OF_FAME;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    MyResult* result = self.tableViewData[indexPath.row];
    
    cell.name = result.name;
    
    cell.score = result.score;
    
    cell.level = result.level;
    
    return cell;
}
@end
