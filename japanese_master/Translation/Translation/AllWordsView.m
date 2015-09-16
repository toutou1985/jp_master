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
@implementation AllWordsView
- (void)awakeFromNib {
    
    [self loadDataFromDB];
    self.sectionArray = [[NSMutableArray alloc] initWithObjects:@"A",@"K",@"S",@"T",@"N",@"H",@"M",@"",@"Y",@"R",@"W", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.sendArr = [NSMutableArray array];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
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
    cell.pianLabel.text = [dic objectForKey:@"kana"];
    
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.00];
    
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dic = [_tableArray objectAtIndex:indexPath.row];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
