//
//  PointsCell.h
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface PointsCell : UITableViewCell
{
    UIImageView *bgIV;
    UIImageView *iconIV;
    UIImageView *noteIV;
}

@property (nonatomic, strong) UILabel *pointsLable;
@property (nonatomic, strong) UILabel *countLable;
@property (nonatomic, assign) PointsStatus pointsStatus;

@end
