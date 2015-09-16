//
//  GameCollectionViewCell.h
//  Translation
//
//  Created by monstarlab6 on 15-9-3.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCircularProgressView.h"
@interface GameCollectionViewCell : UICollectionViewCell
@property(nonatomic ,strong)UIView *imgView;
@property (nonatomic,strong)THCircularProgressView * circleView;
@property (nonatomic,strong)UILabel * missionLabel;
@property (nonatomic,strong)UILabel * percentLabel;
@end
