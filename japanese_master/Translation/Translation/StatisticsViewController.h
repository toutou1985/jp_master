//
//  StatisticsViewController.h
//  Translation
//
//  Created by monst on 13-12-26.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray * sendArr;

@end
