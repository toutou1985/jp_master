//
//  StatisticsTableViewCell.m
//  Translation
//
//  Created by monstarlab6 on 15-9-3.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "StatisticsTableViewCell.h"

@implementation StatisticsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.text = @"test";
        self.numberLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:175/255.0 blue:218/255.0 alpha:1];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.numberLabel];
        
        self.wordLabel = [[UILabel alloc]init];
        self.wordLabel.text = @"test";
        self.wordLabel.textAlignment = NSTextAlignmentLeft;
        self.wordLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:175/255.0 blue:218/255.0 alpha:1];
  
        [self.contentView addSubview:self.wordLabel];
        
        self.reslutLabel = [[UILabel alloc]init];
        self.reslutLabel.text = @"test";
        self.reslutLabel.textAlignment = NSTextAlignmentLeft;
      self.reslutLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:175/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:self.reslutLabel];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
