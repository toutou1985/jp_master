//
//  AllDicViewController.h
//  Translation
//
//  Created by monst on 14-9-5.
//  Copyright (c) 2014年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllDicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray * tableArray;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * sendArr;
@end
