//
//  PointsCell.m
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "PointsCell.h"

@implementation PointsCell
@synthesize pointsLable;
@synthesize countLable;
@synthesize pointsStatus;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        bgIV = [[UIImageView alloc]init];
        bgIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bgIV];
        
        iconIV = [[UIImageView alloc]init];
        iconIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:iconIV];
        
        self.pointsLable = [[UILabel alloc]init];
        self.pointsLable.backgroundColor = [UIColor clearColor];
        self.pointsLable.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.pointsLable];
        
        self.countLable = [[UILabel alloc]init];
        self.countLable.backgroundColor = [UIColor clearColor];
        self.countLable.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.countLable];
        
        noteIV = [[UIImageView alloc]init];
        noteIV.backgroundColor = [UIColor redColor];
        
//        [self.contentView addSubview:noteIV];
        
//        self.accessoryView = noteIV;
    }
    return self;
}



- (void)layoutSubviews
{
    bgIV.frame = CGRectMake(40, 0, CGRectGetWidth(self.frame) - 100, CGRectGetHeight(self.frame) - 30);
    iconIV.frame = CGRectMake(40, 10, 30, 30);
    self.pointsLable.frame = CGRectMake(100, 0, 300, CGRectGetHeight(self.frame) - 30);
    self.countLable.frame = CGRectMake(CGRectGetWidth(self.frame) - 150, 0, 100, CGRectGetHeight(self.frame) - 30);
//    noteIV.frame = CGRectMake(0, 0, 100, 100);
}

- (void)setPointsStatus:(PointsStatus)ps
{
    switch (ps)
    {
        case kPointsStatusLock:
        {
            bgIV.image = [UIImage imageNamed:@"part3_1"];
            iconIV.image = [UIImage imageNamed:@"lock"];
        }
            break;
        case kPointsStatusRun:
        {
            bgIV.image = [UIImage imageNamed:@"part3_2"];
            iconIV.image = [UIImage imageNamed:@"run"];
        }
            break;
        case kPointsStatusComplete:
        {
            bgIV.image = [UIImage imageNamed:@"part3_3"];
            iconIV.image = [UIImage imageNamed:@"key"];
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
