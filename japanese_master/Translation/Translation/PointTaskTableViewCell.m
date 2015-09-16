//
//  PointTaskTableViewCell.m
//  Translation
//
//  Created by monstarlab6 on 15-9-7.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "PointTaskTableViewCell.h"
#import "THCircularProgressView.h"
@implementation PointTaskTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.numLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.numLabel];
        self.wordsLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.wordsLabel];
        self.imageview = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-100, 5, 30, 30)];
        self.percentage = 1;
        self.example3 = [[THCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, self.imageview.frame.size.width,self.imageview.frame.size.height)];
        self.example3.lineWidth = 15.0f;
        self.example3.progressColor = [UIColor redColor];
        self.example3.centerLabelVisible = YES;
        //self.example3.clockwise = NO;
        [self.imageview addSubview:self.example3];

        [self.contentView addSubview:self.imageview];
        self.arrowView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.arrowView];
        self.wordsLabel.textAlignment = NSTextAlignmentCenter;
        
    
    }
    
    return self;
 
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
