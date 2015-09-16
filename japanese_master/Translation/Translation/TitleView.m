//
//  TitleView.m
//  Translation
//
//  Created by monstarlab6 on 15-9-8.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "TitleView.h"
#import "THCircularProgressView.h"
@implementation TitleView
- (void)awakeFromNib{
    self.example2 = [[THCircularProgressView alloc] initWithFrame:CGRectMake(30, 0, self.circleView.frame.size.height-30, self.circleView.frame.size.height-30)];
    self.example2.lineWidth = 20;
    self.example2.progressBackgroundColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1];
    self.example2.centerLabelVisible = YES;
    self.example2.progressColor = [UIColor colorWithRed:230.0/255.0 green:77/255.0 blue:101/255.0 alpha:1];
    self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,(self.circleView.frame.size.height-30)/2-10 , self.circleView.frame.size.height-70, 20)];
    [self.example2 addSubview:self.percentLabel];
    [self.percentLabel setTextAlignment:NSTextAlignmentCenter];
    [self.circleView addSubview:self.example2];
    
    [self.bigLockLable setTextColor:[UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1]];
    [self.passLabel setTextColor:[UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1]];
    [self.allLabel setTextColor:[UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1]];
    
 
    
    }
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
