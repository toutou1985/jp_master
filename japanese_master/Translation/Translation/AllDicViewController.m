//
//  AllDicViewController.m
//  Translation
//
//  Created by monst on 14-9-5.
//  Copyright (c) 2014年 monstar. All rights reserved.
//

#import "AllDicViewController.h"
#import "FMDatabase.h"
#import "AllWordsTableViewCell.h"
#import "DetailViewController.h"
@interface AllDicViewController ()

@end

@implementation AllDicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sendArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromDB];
    [_tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backBtn.frame = CGRectMake(0, 20, 40, 40);
    [self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    [self setTableView];
    
}


- (void)loadDataFromDB
{
    NSString * tSQL = @"select word.id,word.kanji,word.kana,word.chinese_means from word";
    self.tableArray = [NSMutableArray array];
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    //创建数据库
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    //判断数据库是否打开
    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    [fmdb beginTransaction];
    FMResultSet *set = [fmdb executeQuery:tSQL];
     while ([set next])
        {
            //获取字符串
            NSString *wordid = [set stringForColumn:@"id"];
            NSString *kanji = [set stringForColumn:@"kanji"];
            NSString * kana = [set stringForColumn:@"kana"];
            NSString * chinese = [set stringForColumn:@"chinese_means"];
            NSMutableDictionary * tDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:wordid,@"id",kanji,@"kanji",kana,@"kana",chinese,@"chinese_means", nil];
            NSLog(@"tdic:%@", tDic);
            
            [self.tableArray addObject:tDic];
        }
    [fmdb close];
    
    
}
- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableArray.count == 0) {
        return 0;
    } else {
        return self.tableArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentity = @"cellIdentity";
    AllWordsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[AllWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    
    NSMutableDictionary * dic = [_tableArray objectAtIndex:indexPath.row];
    cell.pianLabel.text = [dic objectForKey:@"kanji"];
   
    cell.backgroundColor = [UIColor colorWithRed:196/255.0 green:213/255.0 blue:53/255.0 alpha:1];
  
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dic = [_tableArray objectAtIndex:indexPath.row];
    NSString * pian= [dic objectForKey:@"kanji"];
    NSString * ping = [dic objectForKey:@"kana"];
    NSString * chinese = [dic objectForKey:@"chinese_means"];
    [_sendArr addObject:pian];
    [_sendArr addObject:ping];
    [_sendArr addObject:chinese];
    DetailViewController * detailView = [[DetailViewController alloc] init];
    detailView.wordsArr = _sendArr;
    //detailView.row = indexPath.row;
    [self.navigationController pushViewController:detailView animated:YES];
    
}
- (void)buttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
