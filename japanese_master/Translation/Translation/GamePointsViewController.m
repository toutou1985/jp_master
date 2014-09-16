//
//  GamePointsViewController.m
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "GamePointsViewController.h"
#import "PointsCell.h"
#import "PointsTaskViewController.h"
#import "FMDatabase.h"

@interface GamePointsViewController ()
{
    NSMutableArray *pointsSourceArr;
}

@property (nonatomic, strong) UITableView *pointsTV;

@end

@implementation GamePointsViewController
@synthesize modeType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromDB];
    [self.pointsTV reloadData];
}

- (void)loadDataFromDB
{
    NSString *tSQL = nil;
    
//    if (modeType == kModeTypeGame)
    {
//        tSQL = @"select m.game_status ,count(gr.complete_status) as count, m.mission_no from  word w  left join  game_result gr on w.id = gr.word_id and gr.right_num > 0  left join mission m on m.id = w.mission_id where m.mission_no = ?";
        tSQL = @"select m.game_status,count(gr.id) as count, m.mission_no from mission as m left join word as w on m.id=w.mission_id left join game_result as gr on w.id=gr.word_id and gr.right_num>0 where m.id=?";
    }
//    else if (modeType == kModeTypeRemeber)
    {
        
    }
    
    pointsSourceArr = [NSMutableArray array];
    //获得存放数据库文件的沙盒地址
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    //创建数据库
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    //判断数据库是否打开

    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    [fmdb beginTransaction];
    BOOL isRollBack = NO;
    
    @try
    {
        for (NSInteger i = 1; i < 6; i++)
        {
            FMResultSet *set = [fmdb executeQuery:tSQL withArgumentsInArray:@[@(i)]];
            
            while ([set next])
            {
                //获取字符串
                NSString *tGameStatus = [set stringForColumn:@"game_status"];
                tGameStatus = tGameStatus ? tGameStatus : @"0";
                NSString *tCompleted = [set stringForColumn:@"count"];
                NSString *tPoints = [NSString stringWithFormat:@"%ld", (long)i];
                NSDictionary *tDic = @{POINTS_KEY: tPoints,
                                       COMPLETED_KEY: tCompleted,
                                       GAME_STATUS_KEY: tGameStatus};
                
                NSLog(@"tdic:%@", tDic);
                
                [pointsSourceArr addObject:tDic];
            }
            
        }
    }
    @catch (NSException *exception)
    {
        if (exception)
        {
            isRollBack = YES;
            [fmdb rollback];
            [pointsSourceArr removeAllObjects];
        }
    }
    @finally
    {
        if (!isRollBack)
        {
            [fmdb commit];
        }
    }
    
    [fmdb close];
    
}

- (void)setupView
{
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3-0.png"]];
    bgIV.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    bgIV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgIV];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[backBtn setTitle:@"<" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"3-4.png"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, 20, 40, 30);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnAtion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.pointsTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60) style:UITableViewStylePlain];
    self.pointsTV.backgroundColor = [UIColor clearColor];
    self.pointsTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pointsTV.delegate = self;
    self.pointsTV.dataSource = self;
    
    [self.view addSubview:self.pointsTV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Button Aciton

- (void)backBtnAtion:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 
#pragma mark - UITableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pointsSourceArr.count;
}

- (PointsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfifier = @"cell";
    
    PointsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfifier];
    
    if (!cell)
    {
        cell = [[PointsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfifier];
    }
    
    
    cell.pointsLable.text = [NSString stringWithFormat:@"第%@关", (pointsSourceArr[indexPath.row])[POINTS_KEY]];
    cell.countLable.text = [NSString stringWithFormat:@"30/%@", (pointsSourceArr[indexPath.row])[COMPLETED_KEY]];
    
    PointsStatus ps = [(pointsSourceArr[indexPath.row])[GAME_STATUS_KEY]integerValue];
    cell.pointsStatus = ps;
    
    cell.userInteractionEnabled = (ps == kPointsStatusLock ? NO : YES);
    
//    cell.accessoryType = UITableViewCellAccessory;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PointsTaskViewController *vc = [[PointsTaskViewController alloc]init];
    vc.points = (pointsSourceArr[indexPath.row])[POINTS_KEY];
    vc.modeType = self.modeType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tap");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}
@end
