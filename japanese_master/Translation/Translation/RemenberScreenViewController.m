//
//  RemenberScreenViewController.m
//  Translation
//
//  Created by monst on 13-12-24.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "RemenberScreenViewController.h"
#import "FMDatabase.h"
#import "Config.h"

@interface RemenberScreenViewController ()
{
    NSMutableArray *displayWordsArr;
    NSTimer *displayTimer;
    NSTimeInterval displayInterval;
    NSInteger displayIndex;
}

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *preWordBtn;
@property (nonatomic, strong) UIButton *nextWordBtn;
@property (nonatomic, strong) UIButton *pauseBtn;

@property (nonatomic, strong) UILabel *pingjiamingLabel;
@property (nonatomic, strong) UILabel *pianjiamingLabel;
@property (nonatomic, strong) UILabel *chineseLabel;

@property (nonatomic, strong) UIButton *playModeBtn;
@property (nonatomic, strong) UIProgressView *speedPV;
@property (nonatomic, strong) UILabel *speedDisplayLabel;
@property (nonatomic, strong) UISlider *speedSlider;
@end

@implementation RemenberScreenViewController

@synthesize points;
@synthesize task;

@synthesize preWordBtn;
@synthesize nextWordBtn;
@synthesize pauseBtn;
@synthesize pingjiamingLabel;
@synthesize pianjiamingLabel;
@synthesize chineseLabel;
@synthesize playModeBtn;
@synthesize speedPV;
@synthesize speedDisplayLabel;
@synthesize speedSlider;

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
	// Do any additional setup after loading the view.
    [self setupView];
    [self loadDataFromDB];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [displayTimer invalidate];
}

- (void)setupView
{
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part_c_1"]];
    bgIV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgIV];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backBtn.frame = CGRectMake(0, 20, 40, 40);
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"part6_3"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.preWordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.preWordBtn.frame = CGRectMake(70, 20, 60, 40);
    self.preWordBtn.backgroundColor = [UIColor orangeColor];
    [self.preWordBtn setTitle:@"上一个" forState:UIControlStateNormal];
    [self.preWordBtn setBackgroundImage:[UIImage imageNamed:@"part6_3"] forState:UIControlStateNormal];
    [self.preWordBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.preWordBtn.hidden = YES;
    [self.view addSubview:self.preWordBtn];
    
    self.nextWordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextWordBtn.frame = CGRectMake(150, 20, 60, 40);
    self.nextWordBtn.backgroundColor = [UIColor orangeColor];
    [self.nextWordBtn setTitle:@"下一个" forState:UIControlStateNormal];
    [self.nextWordBtn setBackgroundImage:[UIImage imageNamed:@"part6_3"] forState:UIControlStateNormal];
    [self.nextWordBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.nextWordBtn.hidden = YES;
    [self.view addSubview:self.nextWordBtn];
    
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.pauseBtn.frame = CGRectMake(230, 20, 60, 40);
    [self.pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"part6_3"] forState:UIControlStateNormal];
    [self.pauseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseBtn];
    
    self.chineseLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 150, 240, 30)];
    self.chineseLabel.backgroundColor = [UIColor grayColor];
//    self.chineseLabel.text = @"zhongwen ceshi";
    self.chineseLabel.numberOfLines = 0;
    self.chineseLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chineseLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.chineseLabel];
    
    self.pingjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 180, 240, 30)];
    self.pingjiamingLabel.backgroundColor = [UIColor orangeColor];
//    self.pingjiamingLabel.text = @"pingjiaming ceshi";
    self.pingjiamingLabel.numberOfLines = 0;
    self.pingjiamingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.pingjiamingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pingjiamingLabel];
    
    self.pianjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 210, 240, 60)];
    self.pianjiamingLabel.backgroundColor = [UIColor orangeColor];
//    self.pianjiamingLabel.text = @"pianjiaming ceshi";
    self.pianjiamingLabel.numberOfLines = 0;
    self.pianjiamingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.pianjiamingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pianjiamingLabel];
    
    self.playModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.playModeBtn.frame = CGRectMake(200, CGRectGetHeight(self.view.frame) - 150, 80, 40);
    [self.playModeBtn setTitle:@"手动模式" forState:UIControlStateNormal];
    self.pauseBtn.tag = 0;
    [self.playModeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playModeBtn];
    
    self.speedPV = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    self.speedPV.progress = 100.0f;
    self.speedPV.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 80, 80, 30);
    [self.speedPV setProgress:1 animated:YES];
//    [self.view addSubview:self.speedPV];
    self.speedSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.frame) - 80, 200, 30)];
    self.speedSlider.minimumTrackTintColor = [UIColor orangeColor];
    self.speedSlider.maximumTrackTintColor = [UIColor redColor];
    self.speedSlider.minimumValue = 1;
    self.speedSlider.maximumValue = 10;
    self.speedSlider.value = 1;
    [self.speedSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.speedSlider];
    
    self.speedDisplayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.frame) - 35, 80, 30)];
    self.speedDisplayLabel.text = @"1秒/个";
    self.speedDisplayLabel.backgroundColor = [UIColor orangeColor];
    self.speedDisplayLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.speedDisplayLabel];
    
    displayInterval = 1;
    displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    displayIndex = -1;
}

- (void)timerAction
{
    NSLog(@"timer");
    if (++displayIndex > displayWordsArr.count - 1)
    {
        displayIndex = 0;
    }
    
    self.chineseLabel.text = displayWordsArr[displayIndex][CHINESE_MENNS_KEY];
    self.pianjiamingLabel.text = displayWordsArr[displayIndex][PIAN_JIA_MIN_KEY];
    self.pingjiamingLabel.text = displayWordsArr[displayIndex][PING_JIA_MIN_KEY];
}

- (void)loadDataFromDB
{
    displayWordsArr = [NSMutableArray array];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translaiton.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    NSString *tSQL = @"select w.id as id, w.kanji as kanji, w.kana as kana, w.chinese_means as chinese_means from level l left join word w on l.id = w.level_id where w.mission_id = ? and w.level_id = ?";
    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }

    FMResultSet *set = [fmdb executeQuery:tSQL withArgumentsInArray:@[self.points, self.task]];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Button Ation

- (void)buttonAction:(UIButton *)sender
{
    if (sender == self.backBtn)
    {
        NSLog(@"back");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender == self.preWordBtn)
    {
        NSLog(@"previous");
        displayIndex--;
        displayIndex = displayIndex < 0 ? displayWordsArr.count - 1 : displayIndex;
        self.chineseLabel.text = displayWordsArr[displayIndex][CHINESE_MENNS_KEY];
        self.pianjiamingLabel.text = displayWordsArr[displayIndex][PIAN_JIA_MIN_KEY];
        self.pingjiamingLabel.text = displayWordsArr[displayIndex][PING_JIA_MIN_KEY];
        
    }
    else if (sender == self.nextWordBtn)
    {
        NSLog(@"next");
        displayIndex++;
        displayIndex = displayIndex > displayWordsArr.count - 1 ? 0 : displayIndex;
        
        self.chineseLabel.text = displayWordsArr[displayIndex][CHINESE_MENNS_KEY];
        self.pianjiamingLabel.text = displayWordsArr[displayIndex][PIAN_JIA_MIN_KEY];
        self.pingjiamingLabel.text = displayWordsArr[displayIndex][PING_JIA_MIN_KEY];
    }
    else if (sender == self.pauseBtn)
    {
        NSLog(@"pause");
        if (displayTimer.isValid)
        {
            [displayTimer invalidate];
            [self.pauseBtn setTitle:@"play" forState:UIControlStateNormal];
        }
        else
        {
            displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [self.pauseBtn setTitle:@"pause" forState:UIControlStateNormal];
        }
    }
    else if (sender == self.playModeBtn)
    {
        if (sender.tag == 0)
        {//手动模式
            self.preWordBtn.hidden = NO;
            self.nextWordBtn.hidden = NO;
            self.pauseBtn.hidden = YES;
            
            sender.tag = 1;
            [sender setTitle:@"自动模式" forState:UIControlStateNormal];
            if (displayTimer.isValid)
            {
                [displayTimer invalidate];
            }
        }
        else if (sender.tag == 1)
        {
            self.preWordBtn.hidden = YES;
            self.nextWordBtn.hidden = YES;
            self.pauseBtn.hidden = NO;
            
            sender.tag = 0;
            [sender setTitle:@"手动模式" forState:UIControlStateNormal];
            if (!displayTimer.isValid)
            {
                displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            }
        }
    }
}

#pragma mark
#pragma mark - Slider Actinon

- (void)sliderAction:(UISlider *)sender
{
    NSLog(@"slider:%f", sender.value);
    [displayTimer invalidate];
    
    self.speedDisplayLabel.text = [NSString stringWithFormat:@"%d秒/个", (NSInteger)sender.value];
    displayInterval = (NSInteger)sender.value;
    
    if (!displayTimer.isValid )
    {
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}

@end
