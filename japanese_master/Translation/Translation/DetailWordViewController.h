//
//  DetailWordViewController.h
//  Translation
//
//  Created by monstarlab6 on 15-9-16.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWordViewController : UIViewController
@property (nonatomic,strong) NSMutableArray * wordsArr;
@property (strong, nonatomic) IBOutlet UILabel *chineseLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollview;
@property (strong, nonatomic) IBOutlet UILabel *pianLabel;
@property (strong, nonatomic) IBOutlet UIButton *voiceBtn;

@end
