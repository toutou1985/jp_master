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
        _isclick = @"1";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self loadDataFromDB];
    [self setupView];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingString:@"/string.txt"];
    NSError * error = nil;
    NSString * str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if ([str isEqualToString:@"1"]) {
        _firstPoints.backgroundColor = [UIColor blueColor];
    } else if ([str isEqualToString:@"2"]){
        _secondPoints.backgroundColor = [UIColor blueColor];
    } else if ([str isEqualToString:@"3"]){
        _thirdPoints.backgroundColor = [UIColor blueColor];
    } else if ([str isEqualToString:@"4"]){
        _forthPoints.backgroundColor = [UIColor blueColor];
    } else {
        _fifthPoints.backgroundColor = [UIColor blueColor];
    }
        
    NSLog(@" str ===== %@",str);

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
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    NSString *tSQL = @"select count(gr.right_num) as count, l.game_status from word w left join game_result gr on gr.word_id = w.id and gr.right_num > 0 left join level l on w.level_id = l.id where w.mission_id = ? and w.level_id = ?";
 
    NSString *tUpdatePointsCompleteStatusSQL = @"update mission set game_status = 2 where mission_no = ? and (select count() from level where game_status = 1 and mission_id = ?) = 5";
    
    NSString *tUpdatePointsRunStatusSQL = @"update mission set game_status = 1 where mission_no = ? and (select count() from level where game_status = 1 and mission_id = ?) < 5 and  (select count()  from level where game_status = 1 and mission_id = ?) > 0";
    
    NSString *tUpdateNextPointRunStatusSQL = @"update mission set game_status = 1 where mission_no = ? and (select count() from level where game_status = 1 and mission_id = ?) < 5 and (select count() from level where game_status = 1 and mission_id = ?) = 5";
    
    NSString *tresetNextPointRunStatusSQL = @"update mission set game_status = 0 where mission_no = ? and (select count() from level where game_status = 1 and mission_id = ?) < 5 and (select count() from level where game_status = 1 and mission_id = ?) < 5";
    
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
        else
        {
            NSLog(@"update points completed status success");
        }
        
        if (![fmdb executeUpdate:tUpdatePointsRunStatusSQL withArgumentsInArray:@[self.points, self.points, self.points, ]])
        {
            NSLog(@"update points run status lose");
        }
        else
        {
            NSLog(@"update points run status success!");
        }
        
        int points2 = [self.points intValue] +1;
        NSString *nextPoint = [NSString stringWithFormat:@"%d", points2];
        if (![fmdb executeUpdate:tUpdateNextPointRunStatusSQL withArgumentsInArray:@[nextPoint, nextPoint, self.points,]])
        {
            NSLog(@"update points run status lose");
        }
        else
        {
            NSLog(@"update next points run status success!");
        }
        
        
        
        if( points2 ==2 )
        {
        for (int i = 3; i <= 5; i++)
        {
            NSString *tnextPoint = [NSString stringWithFormat:@"%d", i];
            NSString *tforwordPoint = [NSString stringWithFormat:@"%d", i-1];
            if (![fmdb executeUpdate:tresetNextPointRunStatusSQL withArgumentsInArray:@[tnextPoint, tnextPoint, tforwordPoint,]])
            {
                NSLog(@"update points run status lose");
            }
            else
            {
                NSLog(@"modify next points run status success!!!");
            }

            
        }
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
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3-0"]];
    bgIV.backgroundColor = [UIColor clearColor];
    bgIV.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bgIV];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[backBtn setTitle:@"<" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"3-4.png"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, 20, 40, 40);
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
    _firstPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstPoints.frame = CGRectMake(110, 70, 40, 40);
    [_firstPoints setTitle:@"1" forState:UIControlStateNormal];
    [_firstPoints setBackgroundImage:[UIImage imageNamed:@"part4_2"] forState:UIControlStateNormal];

    _firstPoints.tag = FIRST_TASK_BTN_TAG;
    [_firstPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_firstPoints];
    
    _firstPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 70, 80, 40)];
    _firstPointsCountLable.backgroundColor = [UIColor greenColor];
    _firstPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[0])[TASK_KEY]];
    
  
    _firstPointsCountLable.textAlignment = NSTextAlignmentCenter;
    _firstPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_firstPointsCountLable];
    
    _firstPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstPointsNoteBtn.frame = CGRectMake(280, 70, 35, 35);
    //_firstPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [_firstPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    if (_firstPointsNoteBtn.backgroundColor == [UIColor blueColor]) {
        
    } else {
    [_firstPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    }
    _firstPointsNoteBtn.tag = FIRST_TASK_BTN_NOTE_TAG;
    [_firstPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:_firstPointsNoteBtn];
    //second
    _secondPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondPoints.frame = CGRectMake(105, 150, 50, 50);
    [_secondPoints setTitle:@"2" forState:UIControlStateNormal];
    [_secondPoints setBackgroundImage:[UIImage imageNamed:@"part4_3"] forState:UIControlStateNormal];
    _secondPoints.tag = SECOND_TASK_BTN_TAG;
    [_secondPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_secondPoints];
    
    _secondPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 155, 80, 40)];
    _secondPointsCountLable.backgroundColor = [UIColor greenColor];
    _secondPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[1])[TASK_KEY]];
    
    _secondPointsCountLable.textAlignment = NSTextAlignmentCenter;
    _secondPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_secondPointsCountLable];
    
    UIButton *secondPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondPointsNoteBtn.frame = CGRectMake(280, 155, 35, 35);
    secondPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [secondPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [secondPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    secondPointsNoteBtn.tag = SECOND_TASK_BTN_NOTE_TAG;
    [secondPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:secondPointsNoteBtn];
    //third
    _thirdPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdPoints.frame = CGRectMake(100, 240, 60, 60);
    [_thirdPoints setTitle:@"3" forState:UIControlStateNormal];
    [_thirdPoints setBackgroundImage:[UIImage imageNamed:@"part4_4"] forState:UIControlStateNormal];
    _thirdPoints.tag = THIRD_TASK_BTN_TAG;
    [_thirdPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_thirdPoints];
    
    _thirdPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 250, 80, 40)];
    _thirdPointsCountLable.backgroundColor = [UIColor greenColor];
    _thirdPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[2])[TASK_KEY]];
    _thirdPointsCountLable.textAlignment = NSTextAlignmentCenter;
    _thirdPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_thirdPointsCountLable];
    
    UIButton *thirdPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdPointsNoteBtn.frame = CGRectMake(280, 250, 35, 35);
    thirdPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [thirdPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [thirdPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    thirdPointsNoteBtn.tag = THIRD_TASK_BTN_NOTE_TAG;
    [backBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:thirdPointsNoteBtn];
    // forth
   _forthPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    _forthPoints.frame = CGRectMake(95, 330, 70, 70);
    [_forthPoints setTitle:@"4" forState:UIControlStateNormal];
    [_forthPoints setBackgroundImage:[UIImage imageNamed:@"part4_5"] forState:UIControlStateNormal];
    _forthPoints.tag = FORTH_TASK_BTN_TAG;
    [_forthPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forthPoints];
    
    _forthPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 345, 80, 40)];
    _forthPointsCountLable.backgroundColor = [UIColor greenColor];
    _forthPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[3])[TASK_KEY]];
    _forthPointsCountLable.textAlignment = NSTextAlignmentCenter;
    _forthPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_forthPointsCountLable];
    
    UIButton *forthPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forthPointsNoteBtn.frame = CGRectMake(280, 345, 35, 35);
    forthPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [forthPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [forthPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    forthPointsNoteBtn.tag = FORTH_TASK_BTN_NOTE_TAG;
    [forthPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forthPointsNoteBtn];
    //fifth
    _fifthPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    _fifthPoints.frame = CGRectMake(90, 430, 80, 80);
    [_fifthPoints setTitle:@"5" forState:UIControlStateNormal];
    [_fifthPoints setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    _fifthPoints.tag = FIFTH_TASK_BTN_TAG;
    [_fifthPoints addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fifthPoints];
    
    _fifthPointsCountLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 450, 80, 40)];
    _fifthPointsCountLable.backgroundColor = [UIColor greenColor];
    _fifthPointsCountLable.text = [NSString stringWithFormat:@"6/%@",(pointsTaskArr[4])[TASK_KEY]];
    _fifthPointsCountLable.textAlignment = NSTextAlignmentCenter;
    _fifthPointsCountLable.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_fifthPointsCountLable];
    
    UIButton *fifthPointsNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fifthPointsNoteBtn.frame = CGRectMake(280, 450, 35, 35);
    fifthPointsNoteBtn.backgroundColor = [UIColor clearColor];
    [fifthPointsNoteBtn setTitle:@"!" forState:UIControlStateNormal];
    [fifthPointsNoteBtn setBackgroundImage:[UIImage imageNamed:@"part4_6"] forState:UIControlStateNormal];
    fifthPointsNoteBtn.tag = FIRST_TASK_BTN_NOTE_TAG;
    [fifthPointsNoteBtn addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:fifthPointsNoteBtn];
    //[self colorButton];
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
        gameVC.task = [NSString stringWithFormat:@"%ld", sender.tag - 150 + 1];
    }
    else if (modeType == kModeTypeRemeber)
    {
        remenberVC = [[RemenberScreenViewController alloc]init];
        remenberVC.points = self.points;
        remenberVC.task = [NSString stringWithFormat:@"%ld", sender.tag - 150 + 1];
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
            _isclick = @"1";
            //[_firstPoints setBackgroundColor:[UIColor blueColor]];
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
            _isclick = @"2";
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
            _isclick = @"3";
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
            _isclick = @"4";
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
            _isclick = @"5";
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
    [self stringWrite];

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
            UIAlertView *errAV = [[UIAlertView alloc]initWithTitle:nil message:@"游戏模式完成本关-->浏览" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [errAV show];
        }
    }
}
#pragma mark-
#pragma mark-状态写入
- (void)stringWrite
{
    NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [pathArray lastObject];
    //给文件起名字
    path = [path stringByAppendingString:@"/string.txt"];
    //想要写入的内容
    NSString * str = _isclick;
    NSError * error = nil;
    BOOL judge = [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (judge) {
        NSLog(@"存储chengg");
    } else {
        NSLog(@"error == %@",error);
    }
}

@end
