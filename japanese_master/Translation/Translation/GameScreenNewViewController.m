        //
//  GameScreenNewViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-7.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "GameScreenNewViewController.h"

@interface GameScreenNewViewController ()
{
    NSInteger col;
    NSInteger row;
    NSInteger timerCount;
    NSTimer   *keyBordTimer;
    NSMutableArray *taskArr;
    NSInteger wordOrder;
    NSMutableArray *inputArr;
    NSMutableDictionary *keyBordTextDic;
}

@end

@implementation GameScreenNewViewController
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
    // Do any additional setup after loading the view from its nib.
    self.transType = transTypeSystem;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameView"]]];
    
    UIButton * backbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];

    [self.japaneseLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chineseview"]]];
    
//    self.chineseLabel.lineBreakMode = UILineBreakModeWordWrap;
//    self.chineseLabel.numberOfLines = 0;
    
    [self.keyboradView setBackgroundColor:[UIColor redColor]];
    [self loadDataFromDB];
    [self configKeyBord];
}
- (void)loadDataFromDB
{
    taskArr = [NSMutableArray array];
    NSString * tql = [NSString stringWithFormat:@"select id,kanji,kana,chinese_means,right_num from word where mission_id=%@ and level_id=%@",self.mission_id,self.points];
    NSString * maxLevel = [NSString stringWithFormat:@"select max(level_no)as maxlevel from level where mission_id=%@",self.mission_id];
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    NSLog(@"dbpath====================%@",DBPath);
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    FMResultSet * setMaxlevle = [fmdb executeQuery:maxLevel];
    while ([setMaxlevle next]) {
        self.maxLevel_on = [setMaxlevle stringForColumn:@"maxlevel"];
    }
    FMResultSet *set = [fmdb executeQuery:tql];
    while ([set next])
    {
        NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
        
        NSString *tWordID = [set stringForColumn:@"id"];
        NSString *tPianJiaMin = [set stringForColumn:@"kanji"];
        NSString *tPingJiaMin = [set stringForColumn:@"kana"];
        NSString *tChinese = [set stringForColumn:@"chinese_means"];
        NSString *tWrongSum = [set stringForColumn:@"wrong_num"];
        if (!tWrongSum) {
            tWrongSum = @"0";
        }
        NSString *tRightSum = [set stringForColumn:@"right_num"];
        if (!tRightSum) {
            tRightSum = @"0";
        }
        
        tDic[WORD_ID_KEY] = tWordID;
        tDic[PIAN_JIA_MIN_KEY] = tPianJiaMin;
        tDic[PING_JIA_MIN_KEY] = tPingJiaMin;
        tDic[CHINESE_MENNS_KEY] = tChinese;
        tDic[WORD_IS_COMPLETE_KEY] = @NO;
        tDic[WORD_WRONG_SUM_KEY] = tWrongSum;
        tDic[WORD_RIGHT_SUM_KEY] = tRightSum;
        
        [taskArr addObject:tDic];
    }
    
    NSLog(@"load:%@", taskArr);
    
    [fmdb close];

    
}
//加载界面
- (void)configKeyBord
{
    col = -1;
    row = 0;
    timerCount = 0;
    
    self.tellBtn.enabled = NO;
    self.nextBtn.enabled = NO;
    self.pointBtn.enabled = NO;
    //    self.japaneseLabel.text = @"";
    
    
    [self configKeyBordText];
    if (self.tempArr.count == 0) {
        return;
    }
    NSLog(@"self.keyboardview----%f",self.keyboradView.frame.size.width);
    if (kScreenHeight<500) {
        self.keyboradView = [[UIView alloc]initWithFrame:CGRectMake(0, self.pointBtn.frame.origin.y + self.pointBtn.frame.size.height+20, kScreenWidth, 180)];
    } else {
        self.keyboradView = [[UIView alloc]initWithFrame:CGRectMake(0, self.pointBtn.frame.origin.y + self.pointBtn.frame.size.height+20, kScreenWidth, 200)];

    }
    
    self.keyboradView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.keyboradView];
    
    keyBordTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                    target:self
                                                  selector:@selector(keyBordAnimation)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)keyBordAnimation
{
    timerCount++;
    
    col++;
    
    if (col == 6)
    {
        row++;
    }
    
    col = col > 5 ? 0 : col;
    
    if (row > 2)
    {
        [keyBordTimer invalidate];
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             
                             CGRect frame = self.keyboradView.frame;
                             frame.origin.y += 20.0f;
                             self.keyboradView.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                             if (finished)
                             {
                                 self.tellBtn.enabled = YES;
                                 self.nextBtn.enabled = YES;
                                 self.pointBtn.enabled = YES;
                             }
                         }];
        return;
    }
    
    self.chineseLabel.text = keyBordTextDic[CHINESE_MENNS_KEY];
    self.japaneseLabel.text = keyBordTextDic[PIAN_JIA_MIN_KEY];
    UIImageView *tapIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part7_2"]];
    if (kScreenHeight<500) {
        tapIV.frame = CGRectMake(10 + 51 * col, row * 47, 45, 45);
    } else {
        tapIV.frame = CGRectMake(5+((kScreenWidth-50*6-10)/5+50)*col, row*52, 50, 50);
    }
    
    UILabel *tapLable = [[UILabel alloc]init];
    tapLable.backgroundColor = [UIColor clearColor];
    tapLable.text = (keyBordTextDic[SINGLE_WORD_KEY])[timerCount - 1];
    tapLable.textAlignment = NSTextAlignmentCenter;
    tapLable.frame = tapIV.bounds;
    [tapIV addSubview:tapLable];
    
    tapIV.userInteractionEnabled = YES;
    tapIV.tag = timerCount;
    UITapGestureRecognizer *tapIVGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBordTap:)];
    tapIVGesture.delegate = self;
    [tapIV addGestureRecognizer:tapIVGesture];
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         
                         tapIV.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                         tapLable.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                         
                         
                         
                     }];
    
    [self.keyboradView addSubview:tapIV];
}

- (void)configKeyBordText
{
    //    NSString *tOrder = [NSString stringWithFormat:@"%d", wordOrder];
    keyBordTextDic = nil;
    keyBordTextDic = [NSMutableDictionary dictionary];
    self.tempArr = [NSMutableArray array];

    for (NSInteger i = 0; i < taskArr.count; i++)
    {
        NSMutableDictionary *tDic = taskArr[i];
        
        if (![tDic[WORD_IS_COMPLETE_KEY] boolValue])
        {
            [self.tempArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }

        
       
    }
    
    if (self.tempArr.count == 0&&[self.levelStatus isEqualToString:@"1"])
    {
        NSLog(@"通关");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"本关已通关" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 10000;
        [alert show];
        return;
    } else {
        
    }
    if (self.keyboradView)
    {
        [self.keyboradView removeFromSuperview];
        self.keyboradView = nil;
        
        [self.inputView removeFromSuperview];
        self.inputView = nil;
    }

    //    NSLog(@"temp:%@", taskArr);
    if (self.transType == transTypeRight) {
        wordOrder++;
        self.pointBtn.enabled = YES;
    } else if (self.transType == transTypeLeft){
        wordOrder--;
        self.nextBtn.enabled = YES;
    } else {
        if (wordOrder > taskArr.count-1) {
             wordOrder = [[self.tempArr firstObject]intValue]+1;
        } else {
            wordOrder++;
        }
       
    }
    
    if (wordOrder>taskArr.count&&self.tempArr.count>0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"已经最后一个" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
        [alert show];
        wordOrder = taskArr.count;
        self.nextBtn.enabled = NO;
    } else if(wordOrder<1&&self.tempArr.count>0) {
        wordOrder = 1;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"已经是第一个" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
        [alert show];
        self.pointBtn.enabled = NO;
        
    }
    NSLog(@"wordorder------%ld",(long)wordOrder);
    //wordOrder = wordOrder > tempArr.count - 1 ? 0 : wordOrder;
    
    NSMutableDictionary *tDic = taskArr[wordOrder-1];
    NSString *pingJiaMing = tDic[PING_JIA_MIN_KEY];
    NSArray *tSingleArr = [[self randomString:pingJiaMing] allObjects];
    
    keyBordTextDic[WORD_ID_KEY] = tDic[WORD_ID_KEY];
    keyBordTextDic[SINGLE_WORD_KEY] = tSingleArr;
    keyBordTextDic[PIAN_JIA_MIN_KEY] = tDic[PIAN_JIA_MIN_KEY];
    keyBordTextDic[PING_JIA_MIN_KEY]  = tDic[PING_JIA_MIN_KEY];
    keyBordTextDic[CHINESE_MENNS_KEY] = tDic[CHINESE_MENNS_KEY];
    
    [self configInputField:pingJiaMing.length];
    
    for (NSString *t in tSingleArr)
    {
        NSLog(@"t:%@", t);
    }
}
- (void)configInputField:(NSInteger)theCount
{
    self.inputView = [[UIView alloc]init];
    self.inputView.frame = CGRectMake(40, self.chineseLabel.frame.origin.y+self.chineseLabel.frame.size.height+20, kScreenWidth-80, self.pointBtn.frame.origin.y-20-self.chineseLabel.frame.origin.y-self.chineseLabel.frame.size.height);
    self.inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.inputView];

    inputArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < theCount; i++)
    {
        [inputArr addObject:@" "];
    }
    
    float width = (kScreenWidth-80)/8;
    if (theCount == 1) {
        UILabel * tempLable = [[UILabel alloc] initWithFrame:CGRectMake(self.inputView.frame.size.width/2-width/2, 0, width, width)];
        tempLable.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        //tempLable.layer.borderColor = [[UIColor redColor]CGColor];
        tempLable.layer.borderWidth = 1.0;
        tempLable.layer.cornerRadius = 10;
        //tempLable.backgroundColor = [UIColor whiteColor];
        tempLable.textColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1];
        tempLable.textAlignment = NSTextAlignmentCenter;
        tempLable.tag = INPUT_FILED_BASE_TAG ;
        tempLable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *inputCancelGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputCancelGesture:)];
        
        [tempLable addGestureRecognizer:inputCancelGesture];
        [self.inputView addSubview:tempLable];

    } else {
        CGFloat rate = (kScreenWidth-80 - theCount * width)/(theCount - 1);
        
        for (NSInteger i = 0; i < theCount; i++)
        {
            UILabel *tempLable = [[UILabel alloc]initWithFrame:CGRectMake(i * (width + rate), 0, width, width)];
            tempLable.layer.backgroundColor = [[UIColor whiteColor] CGColor];
            //tempLable.layer.borderColor = [[UIColor redColor]CGColor];
            tempLable.layer.borderWidth = 1.0;
            tempLable.layer.cornerRadius = 10;
            //tempLable.backgroundColor = [UIColor whiteColor];
            tempLable.textColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1];
            tempLable.textAlignment = NSTextAlignmentCenter;
            tempLable.tag = INPUT_FILED_BASE_TAG + i;
            tempLable.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *inputCancelGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputCancelGesture:)];
            
            [tempLable addGestureRecognizer:inputCancelGesture];
            [self.inputView addSubview:tempLable];
        }

    }
}

//先获取题目有的词 然后在随机生成其他词语
- (NSMutableSet *)randomString:(NSString *)theStr
{
    NSMutableSet *temp = [NSMutableSet set];
    NSInteger pingJiaMingCount = SPELL_LIST.length;
    
    for (NSInteger n = 0; n < theStr.length; n++)
    {
        id obj = [theStr substringWithRange:NSMakeRange(n, 1)];
        if (![temp containsObject:obj])
        {
            [temp addObject:obj];
            NSLog(@"thestr:%@", obj);
        }
    }
    
    //    NSInteger randomCount = 0;
    do
    {
        NSInteger j = arc4random() % pingJiaMingCount;
        id obj = [SPELL_LIST substringWithRange:NSMakeRange(j, 1)];
        NSLog(@"rand:%ld ---- %@", (long)j, obj);
        
        if (![temp containsObject:obj] && ![theStr containtObject:obj])
        {
            //            randomCount++;
            [temp addObject:obj];
        }
    }
    while (temp.count < 18);
    
    NSLog(@"temp array count:%lu", (unsigned long)temp.count);
    return temp;
}
- (void)keyBordTap:(UITapGestureRecognizer *)sender
{
    UIImageView *temp = (UIImageView *)(sender.view);
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         
                         temp.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                         temp.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                     }];
    
    if (![inputArr containsObject:@" "])
    {
        return;
    }
    
    NSInteger tIndex = [inputArr indexOfObject:@" "];
    [inputArr replaceObjectAtIndex:tIndex withObject:keyBordTextDic[SINGLE_WORD_KEY][temp.tag - 1]];
    
    NSLog(@"tapiv:%@",keyBordTextDic[PING_JIA_MIN_KEY]);
    
    UILabel *tempLable = (UILabel *)[self.view viewWithTag:INPUT_FILED_BASE_TAG + tIndex];
    tempLable.text = keyBordTextDic[SINGLE_WORD_KEY][temp.tag - 1];
    
    NSLog(@"tempstr:%@", tempLable.text);
    
    NSString *tInputString = [inputArr componentsJoinedByString:@""];
    tInputString = [tInputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"nest:%@", tInputString);
    
    
    if ([tInputString isEqualToString:keyBordTextDic[PING_JIA_MIN_KEY]])
    {//right
        for (NSMutableDictionary *tDic in taskArr)
        {
            if ([tDic[WORD_ID_KEY] isEqualToString:keyBordTextDic[WORD_ID_KEY]])
            {
                tDic[WORD_IS_COMPLETE_KEY] = @YES;
                tDic[WORD_RIGHT_SUM_KEY] = [NSString stringWithFormat:@"%d", [tDic[WORD_RIGHT_SUM_KEY]integerValue] + 1];
                self.transType = transTypeSystem;
//                if (self.tempArr.count == 0 &&) {
//                    <#statements#>
//                }
                
                    [self performSelector:@selector(configKeyBord) withObject:nil afterDelay:0.2f];
                
                break;
            } 
            //判断如果这一关都完成
//            if ([self taskIsCompleted])
//            {
//                NSLog(@"完成");
//            }
        }
        
    }else {
        if (![inputArr containsObject:@" "])//wrong count
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"填写错误" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            int inputarrCount = inputArr.count;
            [inputArr removeAllObjects];
            for (NSInteger i = 0; i < inputarrCount; i++)
            {
                UILabel *tempLable = (UILabel *)[self.view viewWithTag:INPUT_FILED_BASE_TAG + i];
                tempLable.text = nil;
                [inputArr addObject:@" "];
            }
            for (NSMutableDictionary *tDic in taskArr)
            {
                if ([tDic[WORD_ID_KEY] isEqualToString:keyBordTextDic[WORD_ID_KEY]])
                {
                    tDic[WORD_WRONG_SUM_KEY] = [NSString stringWithFormat:@"%d", [tDic[WORD_WRONG_SUM_KEY]integerValue] + 1];
                    break;
                }
            }
            NSLog(@"wrong:%@", taskArr);


        }
    }

}
//判断每个单词的完成状况
- (BOOL)taskIsCompleted
{
    for (NSMutableDictionary *tDic in taskArr)
    {
        if (![tDic[@"isComplete"]boolValue])
        {
            return NO;
        }
    }
    return YES;
}
- (IBAction)upBtn:(id)sender {
    self.transType = transTypeLeft;
    [self configKeyBord];
}
- (IBAction)pointBtn:(id)sender {
    NSString *pingJiaMing = keyBordTextDic[PING_JIA_MIN_KEY];
    
    if (![inputArr containsObject:@" "])
    {
        return;
    }
    
    NSInteger spaceIndex = [inputArr indexOfObject:@" "];
    
    NSString *firstPingJiaMing = [pingJiaMing substringWithRange:NSMakeRange(spaceIndex, 1)];
    
    for (UIView *tView in self.keyboradView.subviews)
    {
        if ([tView isKindOfClass:[UIImageView class]])
        {
            UIImageView *tIV = (UIImageView *)tView;
            UILabel *tLabel = [tIV.subviews firstObject];
            if ([firstPingJiaMing isEqualToString:tLabel.text])
            {
                [UIView animateWithDuration:0.01f
                                 animations:^{
                                     
                                     tIV.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                                 }completion:^(BOOL finished) {
                                     
                                     if (finished)
                                     {
                                         tIV.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                                     }
                                 }];
            }
        }
        
    }

}
//点击输入框之后输入框内容消失
- (void)inputCancelGesture:(UITapGestureRecognizer *)sender
{
    UILabel *tempLable = (UILabel *)(sender.view);
    NSLog(@"label.tag:%ld", (long)tempLable.tag);
    if (!tempLable.text || [tempLable.text isEqualToString:@""])
    {
        return;
    }
    
    NSInteger idx = tempLable.tag - INPUT_FILED_BASE_TAG;
    
    [inputArr replaceObjectAtIndex:idx withObject:@" "];
    tempLable.text = @"";
}

- (void)saveNewsToDB
{
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    if (![fmdb open])
    {
        NSLog(@"save schedule to db lose");
    }

    for (NSMutableDictionary *tDic in taskArr){
        NSString *tWrongSum = tDic[WORD_WRONG_SUM_KEY];
        NSString *tRightSum = tDic[WORD_RIGHT_SUM_KEY];
        NSString *tWordID = tDic[WORD_ID_KEY];
        NSString * upNum = [NSString stringWithFormat:@"update word set right_num=%@,wrong_num=%@ where id=%@",tRightSum,tWrongSum,tWordID ];
        [fmdb executeUpdate:upNum];

    }
    NSString * upLevelstatus = [NSString stringWithFormat:@"update level set game_status=2 where mission_id=%@ and level_no=%@",self.mission_id,self.points];
    [fmdb executeUpdate:upLevelstatus];
    //select max(level_no) from level where mission_id=1;
    
    if ([self.points isEqualToString:self.maxLevel_on]) {
        NSString * currentMissionstatus = [NSString stringWithFormat:@"update mission set game_status=2 where id=%@",self.mission_id];
        
        /*更新下一个大关卡的状态*/
        NSString * nextMissionstatus = [NSString stringWithFormat:@"update mission set game_status=1 where id=%@",[NSString stringWithFormat:@"%d",[self.mission_id intValue]+1]] ;
        [fmdb executeUpdate:currentMissionstatus];
        [fmdb executeUpdate:nextMissionstatus];
        
        
    } else {
        NSString * upNextlevel = [NSString stringWithFormat:@"update level set game_status=1 where mission_id=%@ and level_no=%@",self.mission_id,[NSString stringWithFormat:@"%d",[self.points intValue]+1]];
        [fmdb executeUpdate:upNextlevel];

    }
    [fmdb commit];
    [fmdb close];
    if ([self.points isEqualToString:self.maxLevel_on]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
    } else {
    [self .navigationController popViewControllerAnimated:YES];
    }


}
- (IBAction)nextBtn:(id)sender {
    self.transType = transTypeRight;
    [self configKeyBord];
}
- (void)backbtn:(id)sender{
    self.backArr = [[NSMutableArray alloc] init];
    self.wrongArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < taskArr.count; i++)
    {
        NSMutableDictionary *tDic = taskArr[i];
        
        if (![tDic[WORD_IS_COMPLETE_KEY] boolValue])
        {
            [self.backArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        if ([tDic[WORD_WRONG_SUM_KEY] boolValue]) {
            [self.wrongArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        
        
        
    }
    if (self.backArr.count == taskArr.count&&self.wrongArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否保存记录" message:nil delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        alert.tag = 10001;
        [alert show];

    }

    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 10001:
            if (buttonIndex == 0) {
                NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
                FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
                
                if (![fmdb open])
                {
                    NSLog(@"save schedule to db lose");
                }
                
                for (NSMutableDictionary *tDic in taskArr){
                    NSString *tWrongSum = tDic[WORD_WRONG_SUM_KEY];
                    NSString *tRightSum = tDic[WORD_RIGHT_SUM_KEY];
                    NSString *tWordID = tDic[WORD_ID_KEY];
                    NSString * upNum = [NSString stringWithFormat:@"update word set right_num=%@,wrong_num=%@ where id=%@",tRightSum,tWrongSum,tWordID ];
                    [fmdb executeUpdate:upNum];
                    
                }
                //需要判断right_num的个数
                [fmdb commit];
                [fmdb close];
                
               [self.navigationController popViewControllerAnimated:YES];

                
            } else {
                [self .navigationController popViewControllerAnimated:YES];
            }
            
            break;
        case 10000:
            if (buttonIndex==0) {
                [self saveNewsToDB];
                

            } else {
                [self .navigationController popViewControllerAnimated:YES];
            }
            
            break;
        default:
            break;
    }
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
