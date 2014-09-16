//
//  StatisticsViewController.m
//  Translation
//
//  Created by monst on 13-12-26.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StatisticsCell.h"
#import "FMDatabase.h"
#import "Config.h"
#import "DetailViewController.h"
@interface StatisticsViewController ()
{
    NSMutableArray *displayWordsArr;
    SortType sortType;
}
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *asendBtn;
@property (nonatomic, strong) UIButton *desendBtn;
@property (nonatomic, strong) UILabel *readedLabel;
@property (nonatomic, strong) UITableView *dataTV;

@end

@implementation StatisticsViewController
@synthesize backBtn;
@synthesize asendBtn;
@synthesize desendBtn;
@synthesize readedLabel;
@synthesize dataTV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sendArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadDataFromDB];
    [self setupView];
}

- (void)setupView
{
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part_c_2"]];
    bgIV.backgroundColor = [UIColor clearColor];
    bgIV.frame = self.view.bounds;
    [self.view addSubview:bgIV];
    
    UILabel *numberTitleLabel = [[UILabel alloc]init];
    numberTitleLabel.frame = CGRectMake(10, 140, 50, 40);
    numberTitleLabel.backgroundColor = [UIColor redColor];
    numberTitleLabel.text = @"No.";
    numberTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:numberTitleLabel];
    
    UILabel *wordTitleLabel = [[UILabel alloc]init];
    wordTitleLabel.frame = CGRectMake(60, 140, 190, 40);
    wordTitleLabel.backgroundColor = [UIColor orangeColor];
    wordTitleLabel.textAlignment = NSTextAlignmentCenter;
    wordTitleLabel.text = @"单词";
    [self.view addSubview:wordTitleLabel];
    
    UILabel *resultTitleLabel = [[UILabel alloc]init];
    resultTitleLabel.frame = CGRectMake(240, 140, 70, 40);
    resultTitleLabel.backgroundColor = [UIColor greenColor];
    resultTitleLabel.text = @"错/对";
    resultTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:resultTitleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backBtn.frame = CGRectMake(0, 20, 40, 40);
    [self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.desendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.desendBtn.frame = CGRectMake(20, 70, 80, 44);
    [self.desendBtn setTitle:@"降序" forState:UIControlStateNormal];
    [self.desendBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.desendBtn];
    
    self.asendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.asendBtn.frame = CGRectMake(100, 70, 80, 44);
    [self.asendBtn setTitle:@"升序" forState:UIControlStateNormal];
    [self.asendBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.asendBtn];
    
    self.dataTV = [[UITableView alloc]initWithFrame:CGRectMake(10, 180, 300, CGRectGetHeight(self.view.frame) - 180) style:UITableViewStylePlain];
    self.dataTV.backgroundColor = [UIColor clearColor];
    self.dataTV.delegate = self;
    self.dataTV.dataSource = self;
    
    [self.view addSubview:self.dataTV];
}

- (void)loadDataFromDB
{
    displayWordsArr = [NSMutableArray array];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    NSLog(@"dbpath====================%@",DBPath);
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    NSString *tSQL = @"SELECT gr.word_id as id, gr.right_num as right_num, gr.wrong_num as wrong_num, w.kanji as kanji, w.kana as kana, w.chinese_means as chinese_means FROM game_result gr, word w where w.id = gr.word_id and (gr.right_num != 0 or gr.wrong_num != 0) order by gr.wrong_num desc ,gr.right_num asc";
    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    
    FMResultSet *set = [fmdb executeQuery:tSQL];
    
    while ([set next])
    {
        NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
        
        NSString *tWordID = [set stringForColumn:@"id"];
        NSString *tRightSum = [set stringForColumn:@"right_num"];
        NSString *tWrongSum = [set stringForColumn:@"wrong_num"];
        NSString *tPianJiaMin = [set stringForColumn:@"kanji"];
        NSString *tPingJiaMin = [set stringForColumn:@"kana"];
        NSString *tChinese = [set stringForColumn:@"chinese_means"];
        
        
        tDic[WORD_ID_KEY] = tWordID;
        tDic[WORD_RIGHT_SUM_KEY] = tRightSum;
        tDic[WORD_WRONG_SUM_KEY] = tWrongSum;
        tDic[PIAN_JIA_MIN_KEY] = tPianJiaMin;
        tDic[PING_JIA_MIN_KEY] = tPingJiaMin;
        tDic[CHINESE_MENNS_KEY] = tChinese;
        
        [displayWordsArr addObject:tDic];
    }
    
    [fmdb close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Button Action

- (void)buttonAction:(UIButton *)sender
{
    if (sender == self.backBtn)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender == self.asendBtn)
    {
        sortType = kSortTypeAsend;
        [dataTV reloadData];
    }
    else if (sender == self.desendBtn)
    {
        sortType = kSortTypeDesend;
        [dataTV reloadData];
    }
}

#pragma mark
#pragma mark - UITbaleView delegate datesource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayWordsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    StatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[StatisticsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger tIndex = 0;
    if (sortType == kSortTypeDesend)
    {
        tIndex = displayWordsArr.count - indexPath.row - 1;
    }
    else if (sortType == kSortTypeAsend)
    {
        tIndex = indexPath.row;
    }
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    cell.wordLabel.text = displayWordsArr[tIndex][PIAN_JIA_MIN_KEY];
//    NSString * chinese = displayWordsArr[tIndex][CHINESE_MENNS_KEY];
//    NSString * pingjiaming = displayWordsArr[tIndex][PING_JIA_MIN_KEY];
//    [_sendArr addObject:cell.wordLabel.text];
//    [_sendArr addObject:chinese];
//    [_sendArr addObject:pingjiaming];
//    NSLog(@"_sendArr==========%@",_sendArr);
//    NSLog(@"chinese ========= %@",chinese);
//    NSLog(@"pingjiaming ======= %@",pingjiaming);
    cell.reslutLabel.text = [NSString stringWithFormat:@"%@ / %@", displayWordsArr[tIndex][WORD_WRONG_SUM_KEY], displayWordsArr[tIndex][WORD_RIGHT_SUM_KEY]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * pian = displayWordsArr[indexPath.row][PIAN_JIA_MIN_KEY];
    NSString * chinese = displayWordsArr[indexPath.row][CHINESE_MENNS_KEY];
    NSString * pingjiaming = displayWordsArr[indexPath.row][PING_JIA_MIN_KEY];
    [_sendArr addObject:pian];
    [_sendArr addObject:chinese];
    [_sendArr addObject:pingjiaming];
    NSLog(@"_sendArr==========%@",_sendArr);
    NSLog(@"chinese ========= %@",chinese);
    NSLog(@"pingjiaming ======= %@",pingjiaming);
    DetailViewController * detail = [[DetailViewController alloc] init];
    detail.wordsArr = _sendArr;
    //detail.row = indexPath.row;
    NSLog(@"row==========%d",detail.row);
    [self.navigationController pushViewController:detail animated:YES];
    
    
    
}
@end
