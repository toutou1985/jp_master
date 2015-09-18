//
//  RemenberScreenNewViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-9.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "RemenberScreenNewViewController.h"
#import "FMDatabase.h"
#import "Config.h"
@interface RemenberScreenNewViewController ()
{
    NSMutableArray * displayWordsArr;
    NSTimer *displayTimer;
    NSTimeInterval displayInterval;
    NSInteger displayIndex;

}
@end

@implementation RemenberScreenNewViewController
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
    [self loadDataFromDB];
    UIImageView * titleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/320*50)];
    [titleImageview setImage:[UIImage imageNamed:@"navView"]];
    [self.view addSubview:titleImageview];
    
    UIButton * backbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];

    // Do any additional setup after loading the view from its nib.
    
    displayInterval = 1;
    displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    displayIndex = -1;
    [self.lineView setBackgroundColor:[UIColor colorWithRed:199/255.0 green:198/255.0 blue:204/255.0 alpha:1]];
    self.japaneseLabel.textColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1];
    
    self.speedSlider.minimumTrackTintColor = [UIColor colorWithRed:58/255.0 green:175/255.0 blue:218/255.0 alpha:1];
    self.speedSlider.maximumTrackTintColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1];
    self.speedSlider.minimumValue = 1;
    self.speedSlider.maximumValue = 10;
    self.speedSlider.value = 1;


}
- (void)loadDataFromDB
{
    displayWordsArr = [NSMutableArray array];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    NSString * tql = [NSString stringWithFormat:@"select id,kanji,kana,chinese_means from word where mission_id=%@ and level_id=%@",self.mission_id,self.points];

    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    
    FMResultSet *set = [fmdb executeQuery:tql];
    
    while ([set next])
    {
        NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
        
        NSString *tWordID = [set stringForColumn:@"id"];
        NSString *tPianJiaMin = [set stringForColumn:@"kanji"];
        NSString *tPingJiaMin = [set stringForColumn:@"kana"];
        NSString *tChinese = [set stringForColumn:@"chinese_means"];
        
        tDic[WORD_ID_KEY] = tWordID;
        tDic[PIAN_JIA_MIN_KEY] = tPianJiaMin;
        tDic[PING_JIA_MIN_KEY] = tPingJiaMin;
        tDic[CHINESE_MENNS_KEY] = tChinese;
        
        [displayWordsArr addObject:tDic];
    }
    
    [fmdb close];
}

- (void)timerAction
{
    NSLog(@"timer");
    if (++displayIndex > displayWordsArr.count - 1)
    {
        displayIndex = 0;
    }
    
    self.chineseLabel.text = displayWordsArr[displayIndex][CHINESE_MENNS_KEY];
    self.japaneseLabel.text = displayWordsArr[displayIndex][PING_JIA_MIN_KEY];
}

- (IBAction)upBtn:(id)sender {
    NSLog(@"previous");
    displayIndex--;
    displayIndex = displayIndex < 0 ? displayWordsArr.count - 1 : displayIndex;
    self.chineseLabel.text = displayWordsArr[displayIndex][CHINESE_MENNS_KEY];
    self.japaneseLabel.text = displayWordsArr[displayIndex][PING_JIA_MIN_KEY];

}
- (IBAction)playBtn:(id)sender {
    NSLog(@"pause");
    if (displayTimer.isValid)
    {
        [displayTimer invalidate];
        [self.playBtn setImage:[UIImage imageNamed:@"playbtn"] forState:UIControlStateNormal];
    }
    else
    {
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }

}
- (IBAction)nextBtn:(id)sender {
    NSLog(@"next");
    displayIndex++;
    displayIndex = displayIndex > displayWordsArr.count - 1 ? 0 : displayIndex;
    
    self.chineseLabel.text = displayWordsArr[displayIndex][CHINESE_MENNS_KEY];
    self.japaneseLabel.text = displayWordsArr[displayIndex][PING_JIA_MIN_KEY];
}
- (IBAction)speedSlider:(UISlider *)sender {
    NSLog(@"slider:%f", sender.value);
    [displayTimer invalidate];
    
    
    displayInterval = (NSInteger)sender.value;
    
    if (!displayTimer.isValid )
    {
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }

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
