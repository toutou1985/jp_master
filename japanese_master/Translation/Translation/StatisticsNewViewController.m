//
//  StatisticsNewViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-3.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "StatisticsNewViewController.h"
#import "StatisticsTableViewCell.h"
@interface StatisticsNewViewController ()

@end

@implementation StatisticsNewViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromDB];
    [self.tableView reloadData];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        sortType = kSortTypeDesend;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 40.0;
    
}
- (void)loadDataFromDB
{
    displayWordsArr = [NSMutableArray array];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    NSLog(@"dbpath====================%@",DBPath);
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    NSString *tSQL = @"select kanji,kana,right_num,wrong_num from word where right_num>0 or wrong_num>0 order by wrong_num desc,right_num asc,id asc limit 100";
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    
    FMResultSet *set = [fmdb executeQuery:tSQL];
    while ([set next])
    {
        NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
        
        NSString *tRightSum = [set stringForColumn:@"right_num"];
        NSString *tWrongSum = [set stringForColumn:@"wrong_num"];
        NSString *tPianJiaMin = [set stringForColumn:@"kanji"];
        NSString *tPingJiaMin = [set stringForColumn:@"kana"];
        tDic[WORD_RIGHT_SUM_KEY] = tRightSum;
        tDic[WORD_WRONG_SUM_KEY] = tWrongSum;
        tDic[PIAN_JIA_MIN_KEY] = tPianJiaMin;
        tDic[PING_JIA_MIN_KEY] = tPingJiaMin;
       
        
        [displayWordsArr addObject:tDic];
    }
    
    [fmdb close];


    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayWordsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentity = @"statisticscell";
    StatisticsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[StatisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    NSInteger tIndex = 0;
    if (sortType == kSortTypeAsend)
    {
        tIndex = displayWordsArr.count - indexPath.row - 1;
    }
    else if (sortType == kSortTypeDesend)
    {
        tIndex = indexPath.row;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.numberLabel.frame = CGRectMake(0, 0, self.numImageview.frame.size.width, 40);
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.wordLabel.frame = CGRectMake(self.wordImageview.frame.origin.x, 0, self.wordImageview.frame.size.width+30, 40);
    cell.wordLabel.text = displayWordsArr[tIndex][PIAN_JIA_MIN_KEY];
    [cell.wordLabel setFont:[UIFont systemFontOfSize:15]];
    cell.reslutLabel.frame = CGRectMake(self.wrongImageview.frame.origin.x+10, 0, self.wrongImageview.frame.size.width, 40);
    NSMutableAttributedString * str =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ / %@", displayWordsArr[tIndex][WORD_WRONG_SUM_KEY], displayWordsArr[tIndex][WORD_RIGHT_SUM_KEY]]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] range:NSMakeRange(0, [displayWordsArr[tIndex][WORD_WRONG_SUM_KEY] length])];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] range:NSMakeRange([displayWordsArr[tIndex][WORD_WRONG_SUM_KEY] length], 1)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:1.0 blue:0 alpha:1] range:NSMakeRange([displayWordsArr[tIndex][WORD_WRONG_SUM_KEY] length]+3, [displayWordsArr[tIndex][WORD_RIGHT_SUM_KEY] length])];
    
    cell.reslutLabel.attributedText = str;
    
    return cell;


    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.2];
    return view;
}
- (IBAction)sortBtn:(id)sender {
    if (sortType == kSortTypeDesend) {
        sortType = kSortTypeAsend;
        [self.tableView reloadData];
    } else {
        sortType = kSortTypeDesend;
        [self.tableView reloadData];
    }
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
