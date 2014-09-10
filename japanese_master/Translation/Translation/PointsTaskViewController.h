//
//  PointsTaskViewController.h
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface PointsTaskViewController : UIViewController

@property (nonatomic, copy) NSString *points;
@property (nonatomic, assign) ModeType modeType;
@property (nonatomic,strong)UILabel *firstPointsCountLable;
@property (nonatomic,strong)UILabel * secondPointsCountLable;

@property (nonatomic,strong)UILabel *forthPointsCountLable;
@property (nonatomic,strong)UILabel *thirdPointsCountLable;
@property (nonatomic,strong)UILabel *fifthPointsCountLable;
@property (nonatomic,strong)UIButton * firstPointsNoteBtn;
@property (nonatomic,strong)UIButton * firstPoints;
@property (nonatomic,strong)NSString * isclick;
@property (nonatomic,strong)UIButton * secondPoints;
@property (nonatomic,strong)UIButton * thirdPoints;
@property (nonatomic,strong)UIButton * forthPoints;
@property (nonatomic,strong)UIButton * fifthPoints;
@end
