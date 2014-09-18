//
//  DictionaryViewController.m
//  Translation
//
//  Created by monst on 13-12-26.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "DictionaryViewController.h"
#import "Tools.h"
#import "FMDatabase.h"
#import "Config.h"
#import "AutocompletionTableView.h"
#import "AllDicViewController.h"
@interface DictionaryViewController ()
{
    NSMutableArray *searchResultArr;
}
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *pingjiamingLabel;
@property (nonatomic, strong) UILabel *pianjiamingLabel;
@property (nonatomic, strong) UILabel *chineseLabel;
@property (nonatomic, strong) UITextField *enterTF;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, strong) NSMutableArray * dicArr;
@end

@implementation DictionaryViewController

@synthesize backBtn;
@synthesize pingjiamingLabel;
@synthesize pianjiamingLabel;
@synthesize chineseLabel;
@synthesize enterTF;
@synthesize enterBtn;
@synthesize autoCompleter = _autoCompleter;
@synthesize dicArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.enterTF inViewController:self withOptions:options];
        _autoCompleter.suggestionsDictionary = [NSArray arrayWithArray:_allWords];
    }
    return _autoCompleter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupView];
    

   }

- (void)setupView
{
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nbg"]];
    bgIV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgIV];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(10, 20, 40, 23);
    //[self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"n3-4.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.enterTF = [[UITextField alloc]init];
    self.enterTF.frame = CGRectMake(50, 60, 150, 40);
    self.enterTF.borderStyle = UITextBorderStyleRoundedRect;
    self.enterTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.enterTF.delegate = self;
    [self.view addSubview:self.enterTF];
   
    
    self.enterBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.enterBtn.frame = CGRectMake(230, 60, 60, 40);
    self.enterBtn.layer.borderWidth = 1.0f;
    self.enterBtn.layer.borderColor = [[UIColor redColor]CGColor];
    self.enterBtn.layer.cornerRadius = 10;
    [self.enterBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.enterBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterBtn];
    
    self.chineseLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 150, 240, 30)];
    self.chineseLabel.backgroundColor = [UIColor colorWithRed:220/255.0 green:0 blue:17/255.0 alpha:1];
    self.chineseLabel.numberOfLines = 0;
    self.chineseLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chineseLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.chineseLabel];
    
    self.pingjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 180, 240, 30)];
    self.pingjiamingLabel.backgroundColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:227/255.0 alpha:1];
    self.pingjiamingLabel.numberOfLines = 0;
    self.pingjiamingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.pingjiamingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pingjiamingLabel];
    
    self.pianjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 210, 240, 60)];
    self.pianjiamingLabel.backgroundColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:227/255.0 alpha:1];
    self.pianjiamingLabel.numberOfLines = 0;
    self.pianjiamingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.pianjiamingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pianjiamingLabel];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(70, 300, 180, 30)];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"查看所有词" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dicbutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

- (void)dicbutton:(id)sender
{
    AllDicViewController * alldic = [[AllDicViewController alloc] init];
    [self.navigationController pushViewController:alldic animated:YES];
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
    else if (sender == self.enterBtn)
    {
        [self.enterTF resignFirstResponder];
        
        if (self.enterTF.text == nil)
        {
            UIAlertView *errAV = [[UIAlertView alloc]initWithTitle:nil message:@"空串有没有" delegate:self cancelButtonTitle:@"有" otherButtonTitles:@"没有", nil];
            [errAV show];
            
            return ;
        }
        
        NSMutableString *tEnterStr = [NSMutableString stringWithString:self.enterTF.text];
        
        for (NSInteger i = 0; i < tEnterStr.length; i++)
        {
            id tObj = [tEnterStr substringWithRange:NSMakeRange(i, 1)];
            
            if ([tObj isEqualToString:@" "])
            {
                [tEnterStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
            }
        }
        NSLog(@"tstr:%@", tEnterStr);
        searchResultArr = [NSMutableArray array];
        
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
            
            [searchResultArr addObject:tDic];
        }
        
        [fmdb close];
        [self configLabel];
    }
}

- (void)configLabel
{
    NSMutableDictionary *tDic = [searchResultArr firstObject];
    
    self.chineseLabel.text = tDic[CHINESE_MENNS_KEY];
    self.pingjiamingLabel.text = tDic[PING_JIA_MIN_KEY];
    self.pianjiamingLabel.text = tDic[PIAN_JIA_MIN_KEY];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSLog(@"change");
    NSLog(@"%@",self.enterTF.text);
    [self.enterTF addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    //DB检索
    // @["生きる","生ビール","生活"]
    
    
    return YES;
    
}


@end
