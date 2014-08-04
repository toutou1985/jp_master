//
//  StatisticsCell.m
//  Translation
//
//  Created by monst on 13-12-26.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "StatisticsCell.h"

@implementation StatisticsCell

@synthesize numberLabel;
@synthesize wordLabel;
@synthesize reslutLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.text = @"test";
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.numberLabel];
        
        self.wordLabel = [[UILabel alloc]init];
        self.wordLabel.text = @"test";
        self.wordLabel.textAlignment = NSTextAlignmentCenter;
        self.wordLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.wordLabel];
        
        self.reslutLabel = [[UILabel alloc]init];
        self.reslutLabel.text = @"test";
        self.reslutLabel.textAlignment = NSTextAlignmentCenter;
        self.reslutLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.reslutLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    self.numberLabel.frame = CGRectMake(0, 0, 50.0f, CGRectGetHeight(self.frame));
    self.wordLabel.frame = CGRectMake(50.0f, 0, 180, CGRectGetHeight(self.frame));
    self.reslutLabel.frame = CGRectMake(230, 0, 80, CGRectGetHeight(self.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
