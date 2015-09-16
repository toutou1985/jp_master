//
//  PointTaskNewViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-7.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "PointTaskNewViewController.h"
#import "THCircularProgressView.h"
#import "PointTaskTableViewCell.h"
#import "GameScreenNewViewController.h"
#import "TitleView.h"
#import "RemenberScreenNewViewController.h"
@interface PointTaskNewViewController ()

@end

@implementation PointTaskNewViewController
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataFromDB];
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"TitleView" owner:nil options:nil];
    self.titleview = [apparray firstObject];
    self.titleview.frame = CGRectMake(0, 0, self.titleView.frame.size.width, self.titleView.frame.size.height);
    int finishedCount = 0;
    for (NSMutableDictionary * dic in self.pointsTaskArr) {
        NSString * lefttext =[dic objectForKey:@"levelStatus"];
        if ([lefttext isEqualToString:@"2"]) {
            finishedCount ++;
        }
    }
    self.titleview.bigLockLable.text = [NSString stringWithFormat:@"第%@关",self.mission_id];
    self.titleview.passLabel.text = [NSString stringWithFormat:@"完成 %d 项任务",finishedCount];
    self.titleview.allLabel.text = [NSString stringWithFormat:@"共计 %lu 项任务",(unsigned long)self.pointsTaskArr.count];
    self.titleview.percentLabel.text = [NSString stringWithFormat:@"%d/%lu",finishedCount,(unsigned long)self.pointsTaskArr.count];
    self.titleview.example2.percentage = finishedCount*1.0/self.pointsTaskArr.count;
    self.titleview.percentLabel.textColor = [UIColor colorWithRed:160/255.0 green:212/255.0 blue:104/255.0 alpha:1];
    [self.titleView addSubview:self.titleview];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40.0f;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.view removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView * titleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/320*50)];
    [titleImageview setImage:[UIImage imageNamed:@"navView"]];
    [self.view addSubview:titleImageview];
    
    UIButton * backbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtnpoint:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];

    
    
    
   
}
- (void)loadDataFromDB
{
    self.pointsTaskArr = [NSMutableArray array];
    self.pointsDetailArr =[NSMutableArray array];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    NSLog(@"dbpath====================%@",DBPath);
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    NSString * tql = [NSString stringWithFormat:@"select level_no,game_status from level where mission_id=%@",self.mission_id];
    NSString * tqlDetail = [NSString stringWithFormat:@"select allcnt.level_id,allcnt,rightcnt from (select level_id,count(id) as allcnt from word where mission_id=%@ group by level_id) allcnt left join (select level_id,count(id) as rightcnt from word where mission_id=%@ and right_num>0 group by level_id) rightcnt on allcnt.level_id=rightcnt.level_id",self.mission_id,self.mission_id];
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    FMResultSet * set1 = [fmdb executeQuery:tql];
    while ([set1 next]) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSString * levelCount = [set1 stringForColumn:@"level_no"];
        NSString * levelStatus = [set1 stringForColumn:@"game_status"];
        [dic setObject:levelCount forKey:@"levelCount"];
        [dic setObject:levelStatus forKey:@"levelStatus"];
        [self.pointsTaskArr addObject:dic];
        NSLog(@"level --- %@",self.pointsTaskArr);

    }
    FMResultSet * set2 = [fmdb executeQuery:tqlDetail];
    while ([set2 next]) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSString * allwords = [set2 stringForColumn:@"allcnt"];
        NSString * rightwords = [set2 stringForColumn:@"rightcnt"];
        if (!rightwords) {
            rightwords = @"0";
        }

        [dic setObject:allwords forKey:@"allwordscount"];
        [dic setObject:rightwords forKey:@"rightwordscount"];
        [self.pointsDetailArr addObject:dic];
        NSLog(@"leveldetail --- %@",self.pointsDetailArr);
    }
    [fmdb close];

    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pointsTaskArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentity = @"cell";
    PointTaskTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[PointTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numLabel.frame = CGRectMake(5, 5, 10, 30);
    cell.wordsLabel.frame = CGRectMake(20, 5, 60, 30);
    cell.imageview.frame = CGRectMake(kScreenWidth-100, 5, 30, 30);
    cell.arrowView.frame = CGRectMake(kScreenWidth-60, 5, 20, 30);
    cell.numLabel.text = self.pointsTaskArr[indexPath.row][@"levelCount"];
    
    cell.wordsLabel.text = [NSString stringWithFormat:@"%@ / %@",self.pointsDetailArr[indexPath.row][@"rightwordscount"],self.pointsDetailArr[indexPath.row][@"allwordscount"]];

    if ([self.pointsTaskArr[indexPath.row][@"levelStatus"]isEqualToString:@"0"]) {
        cell.numLabel.textColor = [UIColor grayColor];
        cell.wordsLabel.textColor = [UIColor grayColor];
        cell.example3.percentage = 0;
        cell.example3.progressBackgroundColor = [UIColor grayColor];
        [cell.arrowView setImage:[UIImage imageNamed:@"grayArrow"]];
       
    } else if ([self.pointsTaskArr[indexPath.row][@"levelStatus"]isEqualToString:@"2"]){
        cell.numLabel.textColor = [UIColor colorWithRed:160/255.0 green:212/255.0 blue:104/255.0 alpha:1];
        cell.wordsLabel.textColor = [UIColor colorWithRed:160/255.0 green:212/255.0 blue:104/255.0 alpha:1];
        cell.example3.percentage = 0;
        cell.example3.progressBackgroundColor = [UIColor colorWithRed:59/255.0f green:175/255.f blue:218/255.f alpha:1.00f];
        [cell.arrowView setImage:[UIImage imageNamed:@"greenArrow"]];
        

    } else {
        cell.numLabel.textColor = [UIColor colorWithRed:230.0/255.0 green:77/255.0 blue:101/255.0 alpha:1];
        cell.wordsLabel.textColor = [UIColor colorWithRed:230.0/255.0 green:77/255.0 blue:101/255.0 alpha:1];
        cell.example3.progressBackgroundColor = [UIColor colorWithRed:59/255.0f green:175/255.f blue:218/255.f alpha:1.00f];
        cell.example3.progressColor = [UIColor colorWithRed:230.0/255.0 green:77/255.0 blue:101/255.0 alpha:1];
        cell.example3.percentage = [self.pointsDetailArr[indexPath.row][@"rightwordscount"]floatValue]/[self.pointsDetailArr[indexPath.row][@"allwordscount"]floatValue];
        [cell.arrowView setImage:[UIImage imageNamed:@"redArrow"]];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pointsTaskArr[indexPath.row][@"levelStatus"]isEqualToString:@"0"]) {
        return;
    }
    if (self.modeType == kModeTypeGame) {
        GameScreenNewViewController * gameVC = [[GameScreenNewViewController alloc] initWithNibName:@"GameScreenNewViewController" bundle:nil];
        gameVC.points = self.pointsTaskArr[indexPath.row][@"levelCount"];
        gameVC.mission_id = self.mission_id;
        gameVC.levelStatus = self.pointsTaskArr[indexPath.row][@"levelStatus"];
        [self.navigationController pushViewController:gameVC animated:YES];
    } else {
        if ([self.pointsTaskArr[indexPath.row][@"levelStatus"]isEqualToString:@"1"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请通关游戏" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        } else {
            RemenberScreenNewViewController * gameVC = [[RemenberScreenNewViewController alloc] initWithNibName:@"RemenberScreenNewViewController" bundle:nil];
            gameVC.points = self.pointsTaskArr[indexPath.row][@"levelCount"];
            gameVC.mission_id = self.mission_id;
            
            [self.navigationController pushViewController:gameVC animated:YES];

        }
    }
    
}
- (void)backbtnpoint:(id)sender {
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
