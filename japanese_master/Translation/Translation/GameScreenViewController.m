//
//  GameScreenViewController.m
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "GameScreenViewController.h"
#import "Config.h"
#import "Tools.h"
#import "JHTickerView.h"
@interface GameScreenViewController ()
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

@property (nonatomic, strong) UILabel *chinaeseLabel;
@property (nonatomic, strong) UILabel *japaneseLabel;
@property (nonatomic, strong) UIView *keyBordView;
@property (nonatomic, strong) UIButton *noteBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView   *inputView;

@property (nonatomic,strong) NSString * japaneseStr;
@end

@implementation GameScreenViewController
@synthesize chinaeseLabel;
@synthesize japaneseLabel;
@synthesize keyBordView;
@synthesize points;
@synthesize task;
@synthesize noteBtn;
@synthesize nextBtn;
@synthesize inputView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self configKeyBord];
}
//加载界面
- (void)configKeyBord
{
    col = -1;
    row = 0;
    timerCount = 0;
    
    self.noteBtn.enabled = NO;
    self.nextBtn.enabled = NO;
//    self.japaneseLabel.text = @"";
    
    if (self.keyBordView)
    {
        [self.keyBordView removeFromSuperview];
        self.keyBordView = nil;
        
        [self.inputView removeFromSuperview];
        self.inputView = nil;
    }
    
    [self configKeyBordText];
    
    self.keyBordView = [[UIView alloc]initWithFrame:CGRectMake(4, CGRectGetHeight(self.view.frame) - 200, 320, 200)];
    self.keyBordView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.keyBordView];
    
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
                             
                             CGRect frame = keyBordView.frame;
                             frame.origin.y += 20.0f;
                             keyBordView.frame = frame;
                         }
                        completion:^(BOOL finished) {
                        
                            if (finished)
                            {
                                self.noteBtn.enabled = YES;
                                self.nextBtn.enabled = YES;
                            }
                        }];
        return;
    }
  
        
        self.chinaeseLabel.text = keyBordTextDic[PIAN_JIA_MIN_KEY];
        self.japaneseLabel.text = keyBordTextDic[CHINESE_MENNS_KEY];
    if (ticker) {
        [ticker removeFromSuperview];
        ticker = nil;
    }
        //跑马灯
        NSArray *tickerStrings = [NSArray arrayWithObjects:self.japaneseLabel.text, nil];
        
        ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(10, 260, 300, 50)];
        [ticker setDirection:JHTickerDirectionLTR];
        [ticker setTickerStrings:tickerStrings];
        [ticker setTickerSpeed:60.0f];
        [ticker start];
        
        [self.view addSubview:ticker];
   

    self.japaneseStr = keyBordTextDic[CHINESE_MENNS_KEY];
    

    
    

    
    UIImageView *tapIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part7_2"]];
    tapIV.frame = CGRectMake(2 + 52 * col, (CGRectGetHeight(self.keyBordView.frame) - 185) + row * 52, 50, 50);
    
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
    
    [self.keyBordView addSubview:tapIV];
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
    
    UIImageView *wrongIV = nil;
    
    if ([tInputString isEqualToString:keyBordTextDic[PING_JIA_MIN_KEY]])
    {//right
        for (NSMutableDictionary *tDic in taskArr)
        {
            if ([tDic[WORD_ID_KEY] isEqualToString:keyBordTextDic[WORD_ID_KEY]])
            {
                tDic[WORD_IS_COMPLETE_KEY] = @YES;
                tDic[WORD_RIGHT_SUM_KEY] = [NSString stringWithFormat:@"%d", [tDic[WORD_RIGHT_SUM_KEY]integerValue] + 1];
                
                break;
            }
        }
        
        if ([self taskIsCompleted])
        {
            NSLog(@"win");
            [self saveScheduleToDB];
          UIAlertView *nextAlerView = [[UIAlertView alloc]initWithTitle:@"成功通关！" message:@"本关已经通过，是否进入下一关？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            nextAlerView.tag = NEXT_POINTS_ALTERVIEW_TAG;
            nextAlerView.delegate = self;
            [nextAlerView show];
            
            noteBtn.enabled = NO;
            nextBtn.enabled = NO;
            //在闯完六关之后会走走这个方法
            UIImageView *completedIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part6_1"]];
            completedIV.frame = CGRectMake(50, CGRectGetMidY(self.view.frame), 5, 5);
            completedIV.backgroundColor = [UIColor clearColor];
            completedIV.center = self.view.center;
            [self.view addSubview:completedIV];
            
            
            [UIView animateWithDuration:0.01f
                             animations:^{
                                
                                 completedIV.transform = CGAffineTransformMakeScale(30, 30);
                             }
                             completion:^(BOOL finished) {
                             
                                 if (finished)
                                 {
//                                     [self.navigationController popViewControllerAnimated:YES];
                                 }
                             }];
            
            
            return;
        }
        
        [self performSelector:@selector(configKeyBord) withObject:nil afterDelay:0.2f];
//        NSLog(@"task:%@", taskArr);
    }
    else
    {
        if (![inputArr containsObject:@" "])//wrong count
        {
            NSLog(@"错误");
            
            wrongIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"part6_2"]];
            wrongIV.frame = CGRectMake(0, 0, 80, 80);
            wrongIV.center = self.view.center;
            wrongIV.backgroundColor = [UIColor clearColor];
            [self.view addSubview:wrongIV];
            
            CAKeyframeAnimation *frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            frameAnimation.values = @[@1, @1.3, @1, @1.3, @1];
            frameAnimation.duration = 1.0f;
            frameAnimation.removedOnCompletion = YES;
            frameAnimation.fillMode = kCAFillModeForwards;
            [wrongIV.layer addAnimation:frameAnimation forKey:@"scale"];
            
            for (NSMutableDictionary *tDic in taskArr)
            {
                if ([tDic[WORD_ID_KEY] isEqualToString:keyBordTextDic[WORD_ID_KEY]])
                {
                    tDic[WORD_WRONG_SUM_KEY] = [NSString stringWithFormat:@"%ld", [tDic[WORD_WRONG_SUM_KEY]integerValue] + 1];
                    break;
                }
            }
            NSLog(@"wrong:%@", taskArr);
        }
    }
    
    if (wrongIV)
    {
        [UIView animateWithDuration:2.0f
                         animations:^{
                             
                             wrongIV.alpha = 0.0f;
                             
                         }completion:^(BOOL finished) {
                             
                             if (finished)
                             {
                                 [wrongIV removeFromSuperview];
                             }
                         }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSArray *tArr = @[@"あ", @"い", @"う", @"え", @"お", @"か", @"き", @"く", @"け", @"こ", @"さ", @"し", @"す", @"せ", @"そ", @"た", @"ち", @"つ", @"て", @"と", @"な", @"に", @"ぬ", @"ね", @"の", @"は", @"ひ", @"ふ", @"へ", @"ほ", @"ま", @"み", @"む", @"め", @"も", @"や", @"ゆ", @"よ", @"ら", @"り", @"る", @"れ", @"ろ", @"わ", @"を", @"ん"];
	// Do any additional setup after loading the view.
    [self loadDataFromDB];
    [self setupView];
    [self move];
    wordOrder = 0;
}

- (void)configKeyBordText
{
//    NSString *tOrder = [NSString stringWithFormat:@"%d", wordOrder];
    
    keyBordTextDic = nil;
    keyBordTextDic = [NSMutableDictionary dictionary];
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < taskArr.count; i++)
    {
        NSMutableDictionary *tDic = taskArr[i];
        
        if (![tDic[WORD_IS_COMPLETE_KEY] boolValue])
        {
            [tempArr addObject:tDic];
        }
    }
    
    if (tempArr.count == 0)
    {
        return ;
    }
    
//    NSLog(@"temp:%@", taskArr);
    
    wordOrder++;
    
    wordOrder = wordOrder > tempArr.count - 1 ? 0 : wordOrder;
    
    NSMutableDictionary *tDic = tempArr[wordOrder];
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
//输入框
- (void)configInputField:(NSInteger)theCount
{
    self.inputView = [[UIView alloc]init];
    self.inputView.frame = CGRectMake(40, 180, 240, 100);
    self.inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.inputView];
    
    inputArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < theCount; i++)
    {
        [inputArr addObject:@" "];
    }
    
    CGFloat rate = (240 - theCount * 50)/(theCount - 1);
    
    for (NSInteger i = 0; i < theCount; i++)
    {
        UILabel *tempLable = [[UILabel alloc]initWithFrame:CGRectMake(i * (50 + rate), 0, 50, 50)];
        tempLable.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        tempLable.layer.borderColor = [[UIColor redColor]CGColor];
        tempLable.layer.borderWidth = 1.0;
        tempLable.layer.cornerRadius = 10;
        //tempLable.backgroundColor = [UIColor whiteColor];
        tempLable.textColor = [UIColor blackColor];
        tempLable.textAlignment = NSTextAlignmentCenter;
        tempLable.tag = INPUT_FILED_BASE_TAG + i;
        tempLable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *inputCancelGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputCancelGesture:)];
        
        [tempLable addGestureRecognizer:inputCancelGesture];
        [self.inputView addSubview:tempLable];
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

- (void)loadDataFromDB
{
    taskArr = [NSMutableArray array];
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    NSString *tSQL = @"SELECT w.id as id, w.kanji as kanji, w.kana as kana, w.chinese_means as chinese_means, gr.wrong_num as wrong_num, gr.right_num as right_num FROM word w left join game_result gr on w.id = gr.word_id where w.mission_id = ? and w.level_id = ? and gr.complete_status = 0";
    NSString *tSelectWordStatusSQL = @"select game_status from level where mission_id = ? and level_no = ?";
    NSString *tUpdateWordStatusSQL = @"update game_result set complete_status = 0 where (select id from word where mission_id = ? and level_id = ?)";
//    NSString *tUpdateGameStatusSQL = @"update level set game_status = 0 where mission_id = ? and level_no = ?";
    
    if (![fmdb open])
    {
        NSLog(@"open db lose in game points");
    }
    
    NSLog(@"points:%@  task:%@", self.points, self.task);
    
    FMResultSet *wordStatusSet = [fmdb executeQuery:tSelectWordStatusSQL withArgumentsInArray:@[self.points, self.task]];
    
    if ([wordStatusSet next])
    {
        NSString *wordStatus = [wordStatusSet stringForColumn:@"game_status"];
        
        if ([wordStatus boolValue])
        {
            if (![fmdb executeUpdate:tUpdateWordStatusSQL withArgumentsInArray:@[self.points, self.task]])
            {
                NSLog(@"update word status lose where game status = 1");
            }
            
//            if (![fmdb executeUpdate:tUpdateGameStatusSQL withArgumentsInArray:@[self.points, self.task]])
//            {
//                NSLog(@"update game status lose where game status = 1");
//            }
        }
    }
    
    
    FMResultSet *set = [fmdb executeQuery:tSQL withArgumentsInArray:@[self.points, self.task]];
    
    while ([set next])
    {
        NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
        
        NSString *tWordID = [set stringForColumn:@"id"];
        NSString *tPianJiaMin = [set stringForColumn:@"kanji"];
        NSString *tPingJiaMin = [set stringForColumn:@"kana"];
        NSString *tChinese = [set stringForColumn:@"chinese_means"];
        NSString *tWrongSum = [set stringForColumn:@"wrong_num"];
        NSString *tRightSum = [set stringForColumn:@"right_num"];
        
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

- (void)setupView
{
    @autoreleasepool {
        UIImage * gameImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nbg" ofType:@"png"]];
        UIImageView *bgIV = [[UIImageView alloc]initWithImage:gameImage];
        bgIV.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:bgIV];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.tag = GAME_SCREEN_BACK_BTN_TAG;
        //[backBtn setTitle:@"<" forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(10, 30, 40, 20);
        [backBtn setImage:[UIImage imageNamed:@"n3-4"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
        self.noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.noteBtn.tag = NOTE_BTN_TAG;
        //[self.noteBtn setTitle:@"提示" forState:UIControlStateNormal];
        UIImage * noteImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"5-1" ofType:@"png"]];
        [self.noteBtn setBackgroundImage:noteImage forState:UIControlStateNormal];
        self.noteBtn.frame = CGRectMake(60, 20, 100, 50);
        [self.noteBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.noteBtn];
        
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextBtn.tag = NEXT_BTN_TAG;
        //[self.nextBtn setTitle:@"下一个" forState:UIControlStateNormal];
        UIImage * nextImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"5-21" ofType:@"png"]];
        [self.nextBtn setBackgroundImage:nextImage forState:UIControlStateNormal];
        self.nextBtn.frame = CGRectMake(180, 20, 100, 50);
        [self.nextBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.nextBtn];
        
        self.chinaeseLabel = [[UILabel alloc]init];
        self.chinaeseLabel.frame = CGRectMake(40, 100, 240, 50);
        
        //self.chinaeseLabel.backgroundColor = [UIColor colorWithRed:157/255.0 green:199/255.0 blue:8/255.0 alpha:1];
        self.chinaeseLabel.layer.borderColor = [[UIColor colorWithRed:157/255.0 green:199/255.0 blue:8/255.0 alpha:1]CGColor];
        self.chinaeseLabel.layer.cornerRadius = 10;
        self.chinaeseLabel.layer.borderWidth = 1.0;
        self.chinaeseLabel.layer.backgroundColor =[[UIColor colorWithRed:157/255.0 green:199/255.0 blue:8/255.0 alpha:1]CGColor];
        self.chinaeseLabel.font = [UIFont systemFontOfSize:16.0f];
        self.chinaeseLabel.textAlignment = NSTextAlignmentCenter;
        self.chinaeseLabel.textColor = [UIColor whiteColor];
        self.chinaeseLabel.numberOfLines = 0;
        [self.view addSubview:self.chinaeseLabel];
        
        
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 260, 300,50)];
        //[bgView setBackgroundColor:[UIColor redColor]];
        bgView.clipsToBounds = YES;
        
        self.japaneseLabel = [[UILabel alloc]init];
        self.japaneseLabel.frame = CGRectMake(0, 5, 360, 30);
        //self.japaneseLabel.backgroundColor = [UIColor redColor];
        self.japaneseLabel.font = [UIFont systemFontOfSize:15.0f];
        self.japaneseLabel.numberOfLines = 1;
        self.japaneseLabel.textAlignment = NSTextAlignmentCenter;
        //self.japaneseLabel.text = @"";
        self.japaneseLabel.textColor = [UIColor whiteColor];
        //    CGRect frame = self.japaneseLabel.frame;
        //	frame.origin.x = -330;
        //	self.japaneseLabel.frame = frame;
        //	//self.japaneseLabel.backgroundColor = [UIColor redColor];
        //	[UIView beginAnimations:@"testAnimation" context:NULL];
        //	[UIView setAnimationDuration:8.0f];
        //	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
        //	[UIView setAnimationDelegate:self];
        //	[UIView setAnimationRepeatAutoreverses:NO];
        //	[UIView setAnimationRepeatCount:999999];
        //
        //	frame = self.japaneseLabel.frame;
        //	frame.origin.x = 300;
        //	self.japaneseLabel.frame = frame;
        //	[UIView commitAnimations];
        
        [bgView addSubview:self.japaneseLabel];
        [self.view addSubview:bgView];

    }
    
   
    
    
    
    
    
}
- (void)move
{
     [ticker pause];
    
    
    
}
- (void)saveScheduleToDB
{
    BOOL isCompleted = [self taskIsCompleted];
    
    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
    
    
    

    
    NSString *tUpdateLevelSQL = @"update level set game_status = ?, game_word_id = ? where mission_id = ? and level_no = ? where game_status !=1";
    NSString *tUpdateGameResultSQL = @"update game_result set wrong_num = ?, right_num = ?, complete_status = ? where word_id = ?";
    
    if (![fmdb open])
    {
        NSLog(@"save schedule to db lose");
    }
    
    [fmdb beginTransaction];
    BOOL isRollBack = NO;
    
    @try
    {
        for (NSMutableDictionary *tDic in taskArr)
        {
            NSString *tWrongSum = tDic[WORD_WRONG_SUM_KEY];
            NSString *tRightSum = tDic[WORD_RIGHT_SUM_KEY];
            NSString *tWordID = tDic[WORD_ID_KEY];
            NSString *tWordIsComplete = tDic[WORD_IS_COMPLETE_KEY];
            
            NSLog(@"ponit:%@, task:%@, wrong sum:%@, right sum:%@, word id:%@", self.points, self.task, tWrongSum, tRightSum, tWordID);
//            NSInteger tgs = isCompleted ? 1 : 0;
            NSLog(@"save task:%@", taskArr);
            if (![fmdb executeUpdate:tUpdateLevelSQL withArgumentsInArray:@[@(isCompleted), @2, self.points, self.task]])
            {
                NSLog(@"save schedule update leve lose");
            }
            
            if (![fmdb executeUpdate:tUpdateGameResultSQL withArgumentsInArray:@[tWrongSum, tRightSum, tWordIsComplete, tWordID]])
            {
                NSLog(@"save schedule update game result lose");
            }
        }
    }
    @catch (NSException *exception)
    {
        if (exception)
        {
            [fmdb rollback];
            isRollBack = YES;
        }
    }
    @finally
    {
        [fmdb commit];
    }
    [fmdb close];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Button Action

- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case GAME_SCREEN_BACK_BTN_TAG:
        {
            UIAlertView *progressAV = [[UIAlertView alloc]initWithTitle:nil message:@"是否保存进度?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            progressAV.delegate = self;
            progressAV.tag = PROGRESS_ALTREVIEW_TAG;
            [progressAV show];
        }
            break;
        case NOTE_BTN_TAG:
        {
            NSString *pingJiaMing = keyBordTextDic[PING_JIA_MIN_KEY];
            
            if (![inputArr containsObject:@" "])
            {
                return;
            }
            
            NSInteger spaceIndex = [inputArr indexOfObject:@" "];
            
            NSString *firstPingJiaMing = [pingJiaMing substringWithRange:NSMakeRange(spaceIndex, 1)];
            
            for (UIView *tView in self.keyBordView.subviews)
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
            break;
        case NEXT_BTN_TAG:
        {
            [self configKeyBord];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSLog(@"0");
            //要进入下一关的 不不存的的
            if (alertView.tag == NEXT_POINTS_ALTERVIEW_TAG)
            {
                [self saveScheduleToDB];
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                path = [path stringByAppendingString:@"/string.txt"];
                NSError * error = nil;
                NSString * str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
                NSLog(@" str ===== %@",str);
                int b = [str intValue] + 1;
                NSString * str2 = [NSString stringWithFormat:@"%d",b];
                
                NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * path1 = [pathArray lastObject];
                //给文件起名字
                path1 = [path1 stringByAppendingString:@"/string.txt"];
                //想要写入的内容
                NSString * str1 = str2;
                NSError * error1 = nil;
                BOOL judge = [str1 writeToFile:path1 atomically:YES encoding:NSUTF8StringEncoding error:&error1];
                if (judge) {
                    NSLog(@"存储chengg");
                } else {
                    NSLog(@"error == %@",error1);
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"");
            
            [self saveScheduleToDB];
            //不要进入下一关的
            if (alertView.tag == NEXT_POINTS_ALTERVIEW_TAG)
            {
                [taskArr removeAllObjects];
            }
            //保存进度的
            else if (alertView.tag == PROGRESS_ALTREVIEW_TAG)
            {
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self move];
    [self.view removeFromSuperview];
    
//    NSString * sqlStr = @"<#string#>";
//    //在这加个判断条件从数据库中提取信息 如果所有的小关都通过了，则开启下一个大关
//    //获得存放数据库文件的沙盒地址
//    NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translation.sqlite"];
//    //创建数据库
//    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];
//    //判断数据库是否打开
//    
//    if (![fmdb open])
//    {
//        NSLog(@"open db lose in game points");
//    }
//    [fmdb beginTransaction];
//    se
//    
//    
//    
//    
//
//    
//    
//    
//    
//    
}

#pragma mark
#pragma mark - UIGesturDelegate


@end
