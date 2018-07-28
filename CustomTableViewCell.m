//
//  CustomTableViewCell.m
//  EscapeTheZoo
//
//  Created by Mekhak on 9/17/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end

@implementation CustomTableViewCell

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%li", (long)score];
}

- (void)setLevel:(NSInteger)level
{
    _level = level;
    self.levelLabel.text = [NSString stringWithFormat:@"%li", (long)level];
}

@end
