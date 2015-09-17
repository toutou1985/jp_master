//
//  GamePointsNewViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-3.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "GamePointsNewViewController.h"
#import "GameCollectionViewCell.h"
#import "FMDatabase.h"
#import "PointTaskNewViewController.h"
@interface GamePointsNewViewController ()
{
    NSMutableArray *pointsSourceArr;
    NSMutableArray *pointsMissionStatus;
}

@end
static NSString * cellIdentifier =@"cell";
@implementation GamePointsNewViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
    [self loaddataformDB];
    [self loadMissionstatus];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenWidth/320*50, kScreenWidth, kScreenHeight-kScreenWidth/320*50-80) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[GameCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.collectionView];

    [self.collectionView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [pointsSourceArr removeAllObjects];
    [pointsMissionStatus removeAllObjects];
    [self.view removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView * titleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/320*50)];
    [titleImageview setImage:[UIImage imageNamed:@"navView"]];
    [self.view addSubview:titleImageview];
    
    UIButton * backbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    

    
    
    UIImageView * reward = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-283*40/50)/2, kScreenHeight-70, 283*40/50, 40)];
    [reward setImage:[UIImage imageNamed:@"reward"]];
    [self.view addSubview:reward];
}
- (void)loaddataformDB{
    NSString *tSQL = nil;
    pointsSourceArr = [[NSMutableArray alloc] init];
    tSQL = @"select mission_no,game_status from mission";
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
    FMResultSet * set = [fmdb executeQuery:tSQL];
    while ([set next]) {
        //获取字符串
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSString *tGameStatus = [set stringForColumn:@"game_status"];
        NSLog(@"tgamestatus----%@",tGameStatus);
        NSString *missonid = [set stringForColumn:@"mission_no"];
        NSLog(@"tgamestatus----%@",missonid);
        [dic setObject:tGameStatus forKey:GAME_STATUS_KEY];
        [dic setObject:missonid forKey:POINTS_KEY];
        [pointsSourceArr addObject:dic];
    
        
    }
    NSLog(@"pointarray-----%@",pointsSourceArr);
    [fmdb close];
}
- (void)loadMissionstatus
{
    NSString *tSQL = nil;
    pointsMissionStatus = [[NSMutableArray alloc] init];
    tSQL = @"select  allcnt.mission_id,allcnt,rightcnt from (select mission_id,count(id) as allcnt from word group by mission_id) allcnt left join (select mission_id,count(id)  as rightcnt from word where right_num>0 group by mission_id) rightcnt on allcnt.mission_id=rightcnt.mission_id";
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    //创建数据库
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    //判断数据库是否打开
    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    [fmdb beginTransaction];
    FMResultSet * set = [fmdb executeQuery:tSQL];
    while ([set next]) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSString * mission_id = [set stringForColumn:@"mission_id"];
        NSString * allcnt = [set stringForColumn:@"allcnt"];
        NSString * rightcnt = [set stringForColumn:@"rightcnt"];
        if (!rightcnt) {
            rightcnt = @"0";
        }
        [dic setObject:mission_id forKey:@"mission_id"];
        [dic setObject:allcnt forKey:@"allcount"];
        [dic setObject:rightcnt forKey:@"rightcount"];
        [pointsMissionStatus addObject:dic];

    }
    [fmdb close];
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return pointsSourceArr.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 35,0,35);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-100)/2, (kScreenWidth-100)/2+15);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic1 = [pointsSourceArr objectAtIndex:indexPath.row];
    NSDictionary * dic2 = [pointsMissionStatus objectAtIndex:indexPath.row];
    GameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    


    NSString * gamestatus = [dic1 objectForKey:GAME_STATUS_KEY];
    if ([gamestatus isEqualToString:@"0"]) {
        cell.missionLabel.textColor = [UIColor grayColor];
        cell.percentLabel.textColor = [UIColor grayColor];
        cell.circleView.progressBackgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    } else if ([gamestatus isEqualToString:@"1"]) {
            cell.missionLabel.textColor = [UIColor colorWithRed:230.0/255.0 green:77/255.0 blue:101/255.0 alpha:1];
            cell.percentLabel.textColor = [UIColor colorWithRed:230.0/255.0 green:77/255.0 blue:101/255.0 alpha:1];
            cell.circleView.percentage = [[dic2 objectForKey:@"rightcount"]floatValue]/[[dic2 objectForKey:@"allcount"]floatValue];
        cell.circleView.progressBackgroundColor = [UIColor colorWithRed:59.0/255.0 green:175/255.0 blue:218/255.0 alpha:1];
    } else {
       
      
            cell.missionLabel.textColor = [UIColor greenColor];
            cell.percentLabel.textColor = [UIColor greenColor];
            cell.circleView.progressBackgroundColor = [UIColor colorWithRed:59.0/255.0 green:175/255.0 blue:218/255.0 alpha:1];

    }
    
    cell.missionLabel.text = [dic2 objectForKey:@"mission_id"];
    cell.percentLabel.text = [NSString stringWithFormat:@"%@/%@",[dic2 objectForKey:@"rightcount"],[dic2 objectForKey:@"allcount"]];
    
    
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([pointsSourceArr[indexPath.row][GAME_STATUS_KEY]isEqualToString:@"0"]) {
        return ;
    }
    PointTaskNewViewController * pointVC = [[PointTaskNewViewController alloc] initWithNibName:@"PointTaskNewViewController" bundle:nil];
    pointVC.mission_id = (pointsSourceArr[indexPath.row])[POINTS_KEY];
    pointVC.modeType = self.modeType;
    [self.navigationController pushViewController:pointVC animated:YES];
}
- (void)backbtn:(id)sender
{
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
