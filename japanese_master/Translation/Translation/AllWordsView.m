//
//  AllWordsView.m
//  Translation
//
//  Created by monstarlab6 on 15-9-10.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "AllWordsView.h"
#import "FMDatabase.h"
#import "AllWordsTableViewCell.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
static const CGFloat MJDuration = 2.0;
@implementation AllWordsView
- (void)awakeFromNib {
    self.tableArray = [NSMutableArray array];
    [self loadDataFromDBmission_id:1 level_id:1];
    self.sectionArray = [[NSMutableArray alloc] initWithObjects:@"A",@"K",@"S",@"T",@"N",@"H",@"M",@"",@"Y",@"R",@"W", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.sendArr = [NSMutableArray array];
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

    
}
- (void)loadDataFromDBmission_id:(int)mission_id level_id:(int)levelid
{
    NSString * tSQL = [NSString stringWithFormat:@"select id,kanji,kana,chinese_means from word where mission_id=%d and level_id=%d",mission_id,levelid];
    
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
        CFStringRef pinyin = (__bridge CFStringRef)(kanji );
        
        CFMutableStringRef astring = CFStringCreateMutableCopy(NULL, 0, pinyin);
        CFStringTransform(astring, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform(astring, NULL, kCFStringTransformStripDiacritics, NO);
        NSString * kana = [set stringForColumn:@"kana"];
        NSString * chinese = [set stringForColumn:@"chinese_means"];
        NSMutableDictionary * tDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:wordid,@"id",kanji,@"kanji",kana,@"kana",chinese,@"chinese_means",pinyin,@"pinyin", nil];
        //NSLog(@"tdic:%@", tDic);
        
        [self.tableArray addObject:tDic];
    }
    [fmdb close];

}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 10;
//}
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
    cell.pianLabel.text = [dic objectForKey:@"kana"];
    
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.00];
    
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dic = [self.tableArray objectAtIndex:indexPath.row];
    self.sendArr = [[NSMutableArray alloc] init];
    NSString * pian= [dic objectForKey:@"kanji"];
    NSString * ping = [dic objectForKey:@"kana"];
    NSString * chinese = [dic objectForKey:@"chinese_means"];
    [self.sendArr addObject:pian];
    [self.sendArr addObject:ping];
    [self.sendArr addObject:chinese];
    NSDictionary *userInfo=[[NSDictionary alloc] initWithObjectsAndKeys:self.sendArr,@"word", nil];
    NSLog(@"%@",userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"detailWord" object:self userInfo:userInfo];


}
#pragma mark 只加载一次数据
- (void)loadMoreData
{
    // 1.添加数据
    static int mi = 1;
    static int li = 1;
    NSString * maxLevel = [NSString stringWithFormat:@"select max(level_no)as maxlevel from level where mission_id=%d",mi];
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    NSLog(@"dbpath====================%@",DBPath);
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    FMResultSet * setMaxlevle = [fmdb executeQuery:maxLevel];
    while ([setMaxlevle next]) {
       self.maxLevel = [setMaxlevle stringForColumn:@"maxlevel"];
    }
    [fmdb close];
    if (li <= [self.maxLevel intValue]) {
        mi = 1;
        li ++;
    } else {
        mi++;
        li = 1;
    }

    [self loadDataFromDBmission_id:mi level_id:li];
//    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    });
}
//
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
