//
//  RemenberScreenViewController.m
//  Translation
//
//  Created by monst on 13-12-24.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "RemenberScreenViewController.h"

@interface RemenberScreenViewController ()
{
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
//@property (nonatomic, strong)
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
}

- (void)setupView
{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backBtn.frame = CGRectMake(0, 20, 40, 40);
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.preWordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.preWordBtn.frame = CGRectMake(70, 20, 60, 40);
    self.preWordBtn.backgroundColor = [UIColor orangeColor];
    [self.preWordBtn setTitle:@"pervious" forState:UIControlStateNormal];
    [self.preWordBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.preWordBtn];
    
    self.nextWordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextWordBtn.frame = CGRectMake(150, 20, 60, 40);
    self.nextWordBtn.backgroundColor = [UIColor orangeColor];
    [self.nextWordBtn setTitle:@"next" forState:UIControlStateNormal];
    [self.nextWordBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextWordBtn];
    
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.pauseBtn.frame = CGRectMake(230, 20, 60, 40);
    [self.pauseBtn setTitle:@"pause" forState:UIControlStateNormal];
    [self.pauseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseBtn];
    
    self.chineseLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 150, 240, 30)];
    self.chineseLabel.backgroundColor = [UIColor grayColor];
    self.chineseLabel.text = @"zhongwen ceshi";
    self.chineseLabel.numberOfLines = 0;
    self.chineseLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.chineseLabel];
    
    self.pingjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 180, 240, 30)];
    self.pingjiamingLabel.backgroundColor = [UIColor orangeColor];
    self.pingjiamingLabel.text = @"pingjiaming ceshi";
    self.pingjiamingLabel.numberOfLines = 0;
    self.pingjiamingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pingjiamingLabel];
    
    self.pianjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 210, 240, 60)];
    self.pianjiamingLabel.backgroundColor = [UIColor orangeColor];
    self.pianjiamingLabel.text = @"pianjiaming ceshi";
    self.pianjiamingLabel.numberOfLines = 0;
    self.pianjiamingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pianjiamingLabel];
    
    self.playModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.playModeBtn.frame = CGRectMake(200, CGRectGetHeight(self.view.frame) - 150, 80, 40);
    [self.playModeBtn setTitle:@"playmode" forState:UIControlStateNormal];
    [self.playModeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playModeBtn];
    
    self.speedPV = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    self.speedPV.progress = 100.0f;
    self.speedPV.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 80, 80, 30);
    [self.speedPV setProgress:1 animated:YES];
    [self.view addSubview:self.speedPV];
    
    self.speedDisplayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.frame) - 35, 80, 30)];
    self.speedDisplayLabel.text = @"speedlabel ceshi";
    self.speedDisplayLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.speedDisplayLabel];
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
    }
    else if (sender == self.nextWordBtn)
    {
        NSLog(@"next");
    }
    else if (sender == self.pauseBtn)
    {
        NSLog(@"pause");
    }
}

@end
