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
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    
//    NSString *imagePath = [mainBundle pathForResource:@"nbg" ofType:@"png"];
//    //NSLog(@"imagePath=============%@", imagePath);
//    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
//    UIImageView *bgIV = [[UIImageView alloc]initWithImage:image];
//    bgIV.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    bgIV.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:bgIV];
        UIImageView *logoIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleViewbar"]];
    logoIV.backgroundColor = [UIColor clearColor];
    logoIV.frame = CGRectMake(0 , 0, kScreenWidth, kScreenWidth/320*50);
    [self.view addSubview:logoIV];
    
    UIButton *gameModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[gameModeBtn setTitle:@"游戏模式" forState:UIControlStateNormal];
    [gameModeBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    gameModeBtn.tag = SELECTED_TAG + 3;
    UIImage * gameImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"game" ofType:@"png"]];
    [gameModeBtn setBackgroundImage:gameImage forState:UIControlStateNormal];
    gameModeBtn.frame = CGRectMake(kScreenWidth/4, kScreenWidth/2.7, kScreenWidth/2 ,kScreenWidth/2);
    [self.view addSubview:gameModeBtn];
    
    UIButton *testModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[testModeBtn setTitle:@"词典模式" forState:UIControlStateNormal];
    [testModeBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    testModeBtn.tag = TESTMODE_BTN_TAG;
    UIImage * dicImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"n2-2" ofType:@"png"]];
    [testModeBtn setBackgroundImage:dicImage forState:UIControlStateNormal];
    testModeBtn.frame = CGRectMake(80, 200, 160, 53);
    //[self.view addSubview:testModeBtn];
    
    UIButton *rememberModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[rememberModeBtn setTitle:@"记忆模式" forState:UIControlStateNormal];
    [rememberModeBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    rememberModeBtn.tag = REMEMBERMODE_BTN_TAG;
    [rememberModeBtn setBackgroundImage:[UIImage imageNamed:@"n2-3"] forState:UIControlStateNormal];
    rememberModeBtn.frame = CGRectMake(80, 280, 160, 53);
    //[self.view addSubview:rememberModeBtn];
    
    UIButton *staticticsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[staticticsBtn setTitle:@"计数统计" forState:UIControlStateNormal];
    [staticticsBtn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
    staticticsBtn.tag = STATICTICS_BTN_TAG;
    [staticticsBtn setBackgroundImage:[UIImage imageNamed:@"n2-4"] forState:UIControlStateNormal];
    staticticsBtn.frame = CGRectMake(80, 360, 160, 53);
    //[self.view addSubview:staticticsBtn];
    
    NSArray * selectArray = [[NSArray alloc] initWithObjects:@"dictionary",@"learnning",@"account", nil];
    for (int i = 0; i<3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWidth/7*(1+2*i), kScreenWidth, kScreenWidth/7, kScreenWidth/7);
        button.tag = SELECTED_TAG + i;
        [button setBackgroundImage:[UIImage imageNamed:[selectArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UIImageView * aboutImage = [[UIImageView alloc] initWithFrame:CGRectMake( kScreenWidth/7,kScreenWidth*9/7 ,kScreenWidth/7*5 ,72*5/7)];
    [aboutImage setBackgroundColor:[UIColor whiteColor]];
    [aboutImage setImage:[UIImage imageNamed:@"abountus"]];
    [self.view addSubview:aboutImage];
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
        case 103:
        {
            GamePointsViewController *vc = [[GamePointsViewController alloc]init];
            vc.modeType = kModeTypeGame;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 100:
        {
            DictionaryViewController *vc = [[DictionaryViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:
        {
            GamePointsViewController *vc = [[GamePointsViewController alloc]init];
            vc.modeType = kModeTypeRemeber;
            [self.navigationController pushViewController:vc animated:YES];
//            RemenberScreenViewController *vc = [[RemenberScreenViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
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
