//
//  StatisticsNewViewController.h
//  Translation
//
//  Created by monstarlab6 on 15-9-3.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "Config.h"

@interface StatisticsNewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *displayWordsArr;
    SortType sortType;
}

@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollview;

@property (strong, nonatomic) IBOutlet UIButton *sortBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *numImageview;
@property (strong, nonatomic) IBOutlet UIImageView *wordImageview;
@property (strong, nonatomic) IBOutlet UIImageView *wrongImageview;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@end
