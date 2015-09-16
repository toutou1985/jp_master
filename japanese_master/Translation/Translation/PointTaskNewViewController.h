//
//  PointTaskNewViewController.h
//  Translation
//
//  Created by monstarlab6 on 15-9-7.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@class TitleView;
@interface PointTaskNewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) ModeType modeType;
@property (nonatomic,strong) NSString * mission_id;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (strong, nonatomic) IBOutlet UIImageView *bgImageview;

@property (nonatomic,strong) NSMutableArray * pointsTaskArr;
@property (nonatomic,strong) NSMutableArray * pointsDetailArr;

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong ,nonatomic) TitleView * titleview;
@end
