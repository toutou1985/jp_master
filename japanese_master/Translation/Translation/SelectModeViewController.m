//
//  SelectModeViewController.m
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "SelectModeViewController.h"
#import "Config.h"
#import "GamePointsViewController.h"
#import "RemenberScreenViewController.h"
#import "StatisticsViewController.h"
#import "DictionaryViewController.h"

@interface SelectModeViewController ()

@end

@implementation SelectModeViewController

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
    //self.view.backgroundColor = [UIColor colorWithRed:196/255.0 green:213/255.0 blue:53/255.0 alpha:1];
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part_c_1"]];
    bgIV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgIV];
    
    UIImageView *logoIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_big"]];
    logoIV.backgroundColor = [UIColor clearColor];
    logoIV.frame = CGRectMake(100, 20, 120, 120);
    [self.view addSubview:logoIV];
    
    UIButton *gameModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [gameModeBtn setTitle:@"游戏模式" forState:UIControlStateNormal];
    [gameModeBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    gameModeBtn.tag = GAMEMODE_BTN_TAG;
    [gameModeBtn setBackgroundImage:[UIImage imageNamed:@"part_c_2"] forState:UIControlStateNormal];
    gameModeBtn.frame = CGRectMake(80, 170, 160, 40);
    [self.view addSubview:gameModeBtn];
    
    UIButton *testModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testModeBtn setTitle:@"词典模式" forState:UIControlStateNormal];
    [testModeBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    testModeBtn.tag = TESTMODE_BTN_TAG;
    [testModeBtn setBackgroundImage:[UIImage imageNamed:@"part_c_2"] forState:UIControlStateNormal];
    testModeBtn.frame = CGRectMake(80, 250, 160, 40);
    [self.view addSubview:testModeBtn];
    
    UIButton *rememberModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rememberModeBtn setTitle:@"记忆模式" forState:UIControlStateNormal];
    [rememberModeBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    rememberModeBtn.tag = REMEMBERMODE_BTN_TAG;
    [rememberModeBtn setBackgroundImage:[UIImage imageNamed:@"part_c_2"] forState:UIControlStateNormal];
    rememberModeBtn.frame = CGRectMake(80, 330, 160, 40);
    [self.view addSubview:rememberModeBtn];
    
    UIButton *staticticsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [staticticsBtn setTitle:@"计数统计" forState:UIControlStateNormal];
    [staticticsBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    staticticsBtn.tag = STATICTICS_BTN_TAG;
    [staticticsBtn setBackgroundImage:[UIImage imageNamed:@"part_c_2"] forState:UIControlStateNormal];
    staticticsBtn.frame = CGRectMake(80, 410, 160, 40);
    [self.view addSubview:staticticsBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Button Action

- (void)btnAtion:(UIButton *)sender
{
    switch (sender.tag)
    {
        case GAMEMODE_BTN_TAG:
        {
            GamePointsViewController *vc = [[GamePointsViewController alloc]init];
            vc.modeType = kModeTypeGame;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TESTMODE_BTN_TAG:
        {
            DictionaryViewController *vc = [[DictionaryViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case REMEMBERMODE_BTN_TAG:
        {
            GamePointsViewController *vc = [[GamePointsViewController alloc]init];
            vc.modeType = kModeTypeRemeber;
            [self.navigationController pushViewController:vc animated:YES];
//            RemenberScreenViewController *vc = [[RemenberScreenViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case STATICTICS_BTN_TAG:
        {
            StatisticsViewController *vc = [[StatisticsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
