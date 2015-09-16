//
//  PointTaskTableViewCell.h
//  Translation
//
//  Created by monstarlab6 on 15-9-7.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCircularProgressView.h"
@interface PointTaskTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * numLabel;
@property (nonatomic,strong) UILabel * wordsLabel;
@property (nonatomic,strong) UIView * imageview;
@property (nonatomic,strong) UIImageView * arrowView;
@property (nonatomic,assign) float percentage;
@property (nonatomic,strong)THCircularProgressView *example3;
@end
