//
//  AllWordsView.h
//  Translation
//
//  Created by monstarlab6 on 15-9-10.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllWordsView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * tableArray;
@property (nonatomic,strong) NSMutableArray * sectionArray;
@property (nonatomic,strong) NSMutableArray * sendArr;
@property (nonatomic,strong) NSString * maxLevel;

@end
