//
//  PointsTaskViewController.m
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "PointsTaskViewController.h"
#import "GameScreenViewController.h"
#import "RemenberScreenViewController.h"

@interface PointsTaskViewController ()
{
    NSMutableArray *pointsTaskArr;
}
@end

@implementation PointsTaskViewController
@synthesize points;
@synthesize modeType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromDB];
    [self setupView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self loadDataFromDB];
}

- (void)loadDataFromDB
{
    pointsTaskArr = [NSMutableArray array];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translaiton.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    NSString *tSQL = @"select count(gr.right_num) as count, l.game_status from word w left join game_result gr on gr.word_id = w.id and gr.right_num > 0 left join level l on w.level_id = l.id where w.mission_id = ? and w.level_id = ?";
 
    NSString *tUpdatePointsCompleteStatusSQL = @"update mission set game_status = 2 where mission_no = ? and (select count() from level where game_status = 1 and mission_id = ?) = 5";
    
    NSString *tUpdatePointsRunStatusSQL = @"update mission set game_status = 1 where mission_no = ? and (select count() from level where game_status = 1 and mission_id = ?) < 5 and  (select count()  from level where game_status = 1 and mission_id = ?) > 0";
    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    
    [fmdb beginTransaction];
    BOOL isRollBack = NO;
    
    @try
    {
        if (![fmdb executeUpdate:tUpdatePointsCompleteStatusSQL withArgumentsInArray:@[self.points, self.points]])
        {
            NSLog(@"update points completed status lose");
        }
        
        if (![fmdb executeUpdate:tUpdatePointsRunStatusSQL withArgumentsInArray:@[self.points, self.points, self.points, ]])
        {
            NSLog(@"update points run status lose");
        }
        
        for (NSInteger i = 1; i < 6; i++)
        {
            FMResultSet *set = [fmdb executeQuery:tSQL withArgumentsInArray:@[self.points, @(i)]];
            
            while ([set next])
            {
                NSString *tCompleted = [set stringForColumn:@"count"];
                NSString *tPoints = [NSString stringWithFormat:@"%ld", (long)i];
                NSDictionary *tDic = @{POINTS_KEY: tPoints,
                                       TASK_KEY: tCompleted};
                
                NSLog(@"point task:%@", tDic);
                
                [pointsTaskArr addObject:tDic];
            }
            
        }
    }
    @catch (NSException *exception)
    {
        if (exception)
        {
            isRollBack = YES;
            [fmdb rollback];
            [pointsTaskArr removeAllObjects];
        }
    }
    @finally
    {
        if (!isRollBack)
        {
            [fmdb commit];
        }
    }
    
    [fmdb close];

}

- (void)setupView
{
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part_c_1"]];
    bgIV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgIV];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"<" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 20, 40, 40);
    backBtn.tag = POINT_TASK_BACK_BTN_TAG;
    [backBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *pointsLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 50, 200)];
    pointsLable.backgroundColor = [UIColor lightGrayColor];
    pointsLable.numberOfLines = 0;
    pointsLable.textAlignment = NSTextAlignmentCenter;
    pointsLable.text = [NSString stringWithFormat:@"第\n%@\n关", self.points];
    [self.view addSubview:pointsLable];
    
    UIImageView *lineIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part4_8"]];
    lineIV.backgroundColor = [UIColor clearColor];
    lineIV.frame = CGRectMake(110, 80, 40, 350);
    [self.view addSubview:lineIV];
    
    //first
    UIButton *firstPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    firstPoints.frame = CGRectMake(110, 70, 40, 40);
    [firstPoints setTitle:@"1" forState:UIControlStateNormal];
    [firstPoints setBackgroundImage:[UIImage imageNamed:@"part4_2"] forState:UIControlStateNormal];
    firstPoints.tag = FIRST_TASK_BTN_TAG;
    [firstPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstPoints];
    
    UILabel *firstPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 70, 80, 40)];
    firstPointsCountLable.backgroundColor = [UIColor greenColor];
    firstPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[0])[TASK_KEY]];
  
    firstPointsCountLable.textAlignment = NSTextAlignmentCenter;
    firstPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:firstPointsCountLable];
    
    UIButton *firstPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstPointsNoteBtn.frame = CGRectMake(280, 70, 35, 35);
    firstPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [firstPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [firstPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    firstPointsNoteBtn.tag = FIRST_TASK_BTN_NOTE_TAG;
    [firstPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:firstPointsNoteBtn];
    //second
    UIButton *secondPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    secondPoints.frame = CGRectMake(105, 150, 50, 50);
    [secondPoints setTitle:@"2" forState:UIControlStateNormal];
    [secondPoints setBackgroundImage:[UIImage imageNamed:@"part4_3"] forState:UIControlStateNormal];
    secondPoints.tag = SECOND_TASK_BTN_TAG;
    [secondPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondPoints];
    
    UILabel *secondPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 155, 80, 40)];
    secondPointsCountLable.backgroundColor = [UIColor greenColor];
    secondPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[1])[TASK_KEY]];
    
    secondPointsCountLable.textAlignment = NSTextAlignmentCenter;
    secondPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:secondPointsCountLable];
    
    UIButton *secondPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondPointsNoteBtn.frame = CGRectMake(280, 155, 35, 35);
    secondPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [secondPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [secondPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    secondPointsNoteBtn.tag = SECOND_TASK_BTN_NOTE_TAG;
    [secondPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:secondPointsNoteBtn];
    //third
    UIButton *thirdPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdPoints.frame = CGRectMake(100, 240, 60, 60);
    [thirdPoints setTitle:@"3" forState:UIControlStateNormal];
    [thirdPoints setBackgroundImage:[UIImage imageNamed:@"part4_4"] forState:UIControlStateNormal];
    thirdPoints.tag = THIRD_TASK_BTN_TAG;
    [thirdPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdPoints];
    
    UILabel *thirdPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 250, 80, 40)];
    thirdPointsCountLable.backgroundColor = [UIColor greenColor];
    thirdPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[2])[TASK_KEY]];
    thirdPointsCountLable.textAlignment = NSTextAlignmentCenter;
    thirdPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:thirdPointsCountLable];
    
    UIButton *thirdPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdPointsNoteBtn.frame = CGRectMake(280, 250, 35, 35);
    thirdPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [thirdPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [thirdPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    thirdPointsNoteBtn.tag = THIRD_TASK_BTN_NOTE_TAG;
    [backBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:thirdPointsNoteBtn];
    // forth
    UIButton *forthPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    forthPoints.frame = CGRectMake(95, 330, 70, 70);
    [forthPoints setTitle:@"4" forState:UIControlStateNormal];
    [forthPoints setBackgroundImage:[UIImage imageNamed:@"part4_5"] forState:UIControlStateNormal];
    forthPoints.tag = FORTH_TASK_BTN_TAG;
    [forthPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forthPoints];
    
    UILabel *forthPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 345, 80, 40)];
    forthPointsCountLable.backgroundColor = [UIColor greenColor];
    forthPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[3])[TASK_KEY]];
    forthPointsCountLable.textAlignment = NSTextAlignmentCenter;
    forthPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:forthPointsCountLable];
    
    UIButton *forthPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forthPointsNoteBtn.frame = CGRectMake(280, 345, 35, 35);
    forthPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [forthPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [forthPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    forthPointsNoteBtn.tag = FORTH_TASK_BTN_NOTE_TAG;
    [forthPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forthPointsNoteBtn];
    //fifth
    UIButton *fifthPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    fifthPoints.frame = CGRectMake(90, 430, 80, 80);
    [fifthPoints setTitle:@"5" forState:UIControlStateNormal];
    [fifthPoints setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    fifthPoints.tag = FIFTH_TASK_BTN_TAG;
    [fifthPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fifthPoints];
    
    UILabel *fifthPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 450, 80, 40)];
    fifthPointsCountLable.backgroundColor = [UIColor greenColor];
    fifthPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[4])[TASK_KEY]];
    fifthPointsCountLable.textAlignment = NSTextAlignmentCenter;
    fifthPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:fifthPointsCountLable];
    
    UIButton *fifthPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fifthPointsNoteBtn.frame = CGRectMake(280, 450, 35, 35);
    fifthPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [fifthPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [fifthPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    fifthPointsNoteBtn.tag = FIRST_TASK_BTN_NOTE_TAG;
    [fifthPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:fifthPointsNoteBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Button Action

- (void)buttonAciton:(UIButton *)sender
{
    GameScreenViewController *gameVC = nil;
    RemenberScreenViewController *remenberVC = nil;
    
    if (modeType == kModeTypeGame)
    {
        gameVC = [[GameScreenViewController alloc]init];
        gameVC.points = self.points;
        gameVC.task = [NSString stringWithFormat:@"%d", sender.tag - 150 + 1];
    }
    else if (modeType == kModeTypeRemeber)
    {
        remenberVC = [[RemenberScreenViewController alloc]init];
        remenberVC.points = self.points;
        remenberVC.task = [NSString stringWithFormat:@"%d", sender.tag - 150 + 1];
    }
    
    NSInteger pointTaskIndex = -1;
    
    switch (sender.tag)
    {
        case POINT_TASK_BACK_BTN_TAG:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case FIRST_TASK_BTN_TAG:
        {
            NSLog(@"first task");
            pointTaskIndex = 0;
//            if (modeType == kModeTypeGame)
//            {
//                [self.navigationController pushViewController:gameVC animated:YES];
//            }
//            else if (modeType == kModeTypeRemeber)
//            {
//                if ([pointsTaskArr[0][TASK_KEY] isEqualToString:@"6"])
//                {
//                    [self.navigationController pushViewController:remenberVC animated:YES];
//                }
//                else
//                {
//                    UIAlertView *errAV = [[UIAlertView alloc]initWithTitle:nil message:@"完成本关-->浏览" delegate:self cancelButtonTitle:@"抗议无效" otherButtonTitles: nil];
//                    [errAV show];
//                }
//            }
        }
            break;
        case SECOND_TASK_BTN_TAG:
        {
            pointTaskIndex = 1;
//            if (modeType == kModeTypeGame && [pointsTaskArr[0][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:gameVC animated:YES];
//            }
//            else if (modeType == kModeTypeRemeber && [pointsTaskArr[1][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:remenberVC animated:YES];
//            }
            
        }
            break;
        case THIRD_TASK_BTN_TAG:
        {
            pointTaskIndex = 2;
//            if (modeType == kModeTypeGame && [pointsTaskArr[1][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:gameVC animated:YES];
//            }
//            else if (modeType == kModeTypeRemeber && [pointsTaskArr[2][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:remenberVC animated:YES];
//            }
        }
            break;
        case FORTH_TASK_BTN_TAG:
        {
            pointTaskIndex = 3;
//            if (modeType == kModeTypeGame && [pointsTaskArr[2][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:gameVC animated:YES];
//            }
//            else if (modeType == kModeTypeRemeber && [pointsTaskArr[3][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:remenberVC animated:YES];
//            }
        }
            break;
        case FIFTH_TASK_BTN_TAG:
        {
            pointTaskIndex = 4;
//            if (modeType == kModeTypeGame && [pointsTaskArr[3][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:gameVC animated:YES];
//            }
//            else if (modeType == kModeTypeRemeber && [pointsTaskArr[4][TASK_KEY] isEqualToString:@"6"])
//            {
//                [self.navigationController pushViewController:remenberVC animated:YES];
//            }
            
        }
            break;
        case FIRST_TASK_BTN_NOTE_TAG:
        {}
            break;
        case SECOND_TASK_BTN_NOTE_TAG:
        {}
            break;
        case THIRD_TASK_BTN_NOTE_TAG:
        {}
            break;
        case FORTH_TASK_BTN_NOTE_TAG:
        {}
            break;
        case FIFTH_TASK_BTN_NOTE_TAG:
        {}
            break;
        default:
            break;
    }
    if (modeType == kModeTypeGame )
    {
        if (pointTaskIndex == 0)
        {
            [self.navigationController pushViewController:gameVC animated:YES];
        }
        else if (pointTaskIndex > 0 && [pointsTaskArr[pointTaskIndex - 1][TASK_KEY] isEqualToString:@"6"])
        {
            [self.navigationController pushViewController:gameVC animated:YES];
        }
    }
    else if (modeType == kModeTypeRemeber && pointTaskIndex >= 0)
    {
        if ([pointsTaskArr[pointTaskIndex][TASK_KEY] isEqualToString:@"6"])
        {
            [self.navigationController pushViewController:remenberVC animated:YES];
        }
        else
        {
            UIAlertView *errAV = [[UIAlertView alloc]initWithTitle:nil message:@"完成本关-->浏览" delegate:self cancelButtonTitle:@"抗议无效" otherButtonTitles: nil];
            [errAV show];
        }
    }
}

@end
