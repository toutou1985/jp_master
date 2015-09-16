//
//  DictionaryNewViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-10.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "DictionaryNewViewController.h"
#import "SearchView.h"
#import "AllWordsView.h"
#import "Tools.h"
#import "FMDatabase.h"
#import "Config.h"
#import "AutocompletionTableView.h"
#import "DetailViewController.h"
@interface DictionaryNewViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic,strong) NSMutableArray * searchResultArr;
@end

@implementation DictionaryNewViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserverToNotification];
    // Do any additional setup after loading the view from its nib.
    UIImageView * titleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/320*50)];
    [titleImageview setImage:[UIImage imageNamed:@"navView"]];
    [self.view addSubview:titleImageview];
    
    UIButton * backbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
//    NSArray *array=@[@"查询",@"所有单词"];
//    self.segment=[[UISegmentedControl alloc]initWithItems:array];
    self.segment.selectedSegmentIndex = 0;
    self.segment.tintColor = [UIColor colorWithRed:59/255.0 green:178/255.0 blue:218/255.0 alpha:1];
    
    
    NSArray * allwords = [[NSBundle mainBundle]loadNibNamed:@"AllWordsView" owner:nil options:nil];
    self.allwordsView = [allwords firstObject];
    self.allwordsView.frame =CGRectMake(0, self.segment.frame.origin.y, kScreenWidth, kScreenHeight-self.segment.frame.origin.y);
    [self.view addSubview:self.allwordsView];
    
    
    
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:nil options:nil];
    self.searchView = [apparray firstObject];
    self.searchView.frame = CGRectMake(0, self.segment.frame.origin.y, kScreenWidth, kScreenHeight-self.segment.frame.origin.y);
    [self.searchView.searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[self.searchView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.searchView];

    
    

}
#pragma mark
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
        _allWords = [[NSMutableArray alloc] init];
        FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
        NSString * pianSql = @"select w.kanji from word as w";
        if (![fmdb open])
        {
            NSLog(@"open db lose in game points");
        }
        FMResultSet *set = [fmdb executeQuery:pianSql];
        while ([set next]) {
            NSString *tPianJiaMin = [set stringForColumn:@"kanji"];
            [_allWords addObject:tPianJiaMin];
            
        }
        [fmdb close];
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.searchView.searchTextfield inViewController:self withOptions:options];
        _autoCompleter.suggestionsDictionary = [NSArray arrayWithArray:_allWords];
    }
    return _autoCompleter;
}
- (void)deleteBtn:(id)sender
{
    self.searchView.searchTextfield.text = @"";
}
- (void)searchBtn:(id)sender
{
    [self.searchView.searchTextfield resignFirstResponder];
    
    if (self.searchView.searchTextfield.text == nil)
    {
        UIAlertView *errAV = [[UIAlertView alloc]initWithTitle:nil message:@"空串有没有" delegate:self cancelButtonTitle:@"有" otherButtonTitles:@"没有", nil];
        [errAV show];
        
        return ;
    }
    
    NSMutableString *tEnterStr = [NSMutableString stringWithString:self.searchView.searchTextfield.text];
    
    for (NSInteger i = 0; i < tEnterStr.length; i++)
    {
        id tObj = [tEnterStr substringWithRange:NSMakeRange(i, 1)];
        
        if ([tObj isEqualToString:@" "])
        {
            [tEnterStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
        }
    }
    NSLog(@"tstr:%@", tEnterStr);
    _searchResultArr = [NSMutableArray array];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    NSString *tSQL = @"select kanji, kana, chinese_means from word where kanji like ? or kana like ? or chinese_means like ?";
    
    //        NSString *tSQL = [NSString stringWithFormat:@"select kanji, kana, chinese_means from word where kanji like '%@' or kana like '%@' or chinese_means like '%@'", tEnterStr, tEnterStr, tEnterStr];
    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    
    NSString *tEnterStrtEnterStr = [NSString stringWithFormat:@"%%%@%%",tEnterStr];
    FMResultSet *set = [fmdb executeQuery:tSQL withArgumentsInArray:@[tEnterStrtEnterStr, tEnterStrtEnterStr, tEnterStrtEnterStr]];
    
    while ([set next])
    {
        NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
        
        //            NSString *tWordID = [set stringForColumn:@"id"];
        NSString *tPianJiaMin = [set stringForColumn:@"kanji"];
        NSString *tPingJiaMin = [set stringForColumn:@"kana"];
        NSString *tChinese = [set stringForColumn:@"chinese_means"];
        
        //            tDic[WORD_ID_KEY] = tWordID;
        tDic[PIAN_JIA_MIN_KEY] = tPianJiaMin;
        tDic[PING_JIA_MIN_KEY] = tPingJiaMin;
        tDic[CHINESE_MENNS_KEY] = tChinese;
        
        [_searchResultArr addObject:tDic];
    }
    
    [fmdb close];
    [self configLabel];
}
- (void)configLabel
{
    NSMutableDictionary *tDic = [_searchResultArr firstObject];
    
    self.searchView.chineseLabel.text = tDic[CHINESE_MENNS_KEY];
    self.searchView.japaneseLabel.text = tDic[PING_JIA_MIN_KEY];
    //self.pianjiamingLabel.text = tDic[PIAN_JIA_MIN_KEY];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSLog(@"change");
    NSLog(@"%@",self.searchView.searchTextfield.text);
    [self.searchView.searchTextfield addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    //DB检索
    // @["生きる","生ビール","生活"]
    
    
    return YES;
    
}
- (void)backbtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)segment:(UISegmentedControl *)sender {
    int selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [self.view bringSubviewToFront:self.searchView];
    } else {
        [self.view bringSubviewToFront:self.allwordsView];
    }
}
-(void)addObserverToNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginInfo:) name:@"detailWord" object:nil];
}
-(void)updateLoginInfo:(NSNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
    DetailViewController * detailVC = [[DetailViewController alloc] init];
    detailVC.wordsArr = [userInfo objectForKey:@"word"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
