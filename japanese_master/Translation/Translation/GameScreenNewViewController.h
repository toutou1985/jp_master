//
//  GameScreenNewViewController.h
//  Translation
//
//  Created by monstarlab6 on 15-9-7.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Tools.h"

@interface GameScreenNewViewController : UIViewController<UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *japaneseLabel;
@property (strong, nonatomic) IBOutlet UILabel *chineseLabel;
@property (strong, nonatomic)  UIView *inputView;

@property (strong, nonatomic)  UIView *keyboradView;

@property (strong, nonatomic) IBOutlet UIButton *pointBtn;
@property (strong, nonatomic) IBOutlet UIButton *tellBtn;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong,nonatomic) NSString * points;
@property (nonatomic,strong) NSString * mission_id;
@property (nonatomic,strong) NSString * levelStatus;
@property (nonatomic,assign) BOOL uporDown;
@property (nonatomic,assign) TransType  transType;
@property (nonatomic,strong) NSMutableArray * tempArr;
@property (nonatomic,strong) NSString * maxLevel_on;
@property (nonatomic,strong) NSMutableArray * backArr;
@property (nonatomic,strong) NSMutableArray * wrongArr;
@property (nonatomic,strong) NSMutableArray * origionArr;
@property (nonatomic,assign) int wrongNum;
@property (nonatomic,assign) int wrongNewnum;
@end
