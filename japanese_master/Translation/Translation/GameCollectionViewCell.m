//
//  GameCollectionViewCell.m
//  Translation
//
//  Created by monstarlab6 on 15-9-3.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "GameCollectionViewCell.h"

@implementation GameCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.imgView.backgroundColor = [UIColor clearColor];
        self.circleView = [[THCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, self.imgView.frame.size.width,self.imgView.frame.size.height)];
        self.circleView.lineWidth = 20.0f;
        self.circleView.progressColor = [UIColor colorWithRed:230.0/255.0 green:77/255.0 blue:101/255.0 alpha:1];[UIColor redColor];
        self.circleView.centerLabelVisible = YES;
        [self.imgView addSubview:self.circleView];
        
        self.missionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-10, 30, 20, 20)];
       
        [self.missionLabel setFont:[UIFont systemFontOfSize:15]];
        [self.missionLabel setTextAlignment:NSTextAlignmentCenter];
        [self.circleView addSubview:self.missionLabel];
        
        self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-30, 50, 60, 20)];
        
        [self.percentLabel setFont:[UIFont systemFontOfSize:12]];
        [self.percentLabel setTextAlignment:NSTextAlignmentCenter];
        [self.circleView addSubview:self.percentLabel];


        [self.contentView addSubview:self.imgView];
        
            }
    return self;
}
@end
