//
//  AllWordsTableViewCell.m
//  Translation
//
//  Created by monst on 14-9-5.
//  Copyright (c) 2014年 monstar. All rights reserved.
//

#import "AllWordsTableViewCell.h"

@implementation AllWordsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.pianLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 45)];
        [self.contentView addSubview:self.pianLabel];
        
        
//        self.pingLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 220, 20)];
//        [self.contentView addSubview:self.pingLabel];
//        
//        self.chineseLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 220, 20)];
//        [self.contentView addSubview:self.chineseLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
