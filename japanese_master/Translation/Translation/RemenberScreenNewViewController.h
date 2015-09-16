//
//  RemenberScreenNewViewController.h
//  Translation
//
//  Created by monstarlab6 on 15-9-9.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemenberScreenNewViewController : UIViewController
@property (strong,nonatomic) NSString * points;
@property (nonatomic,strong) NSString * mission_id;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollview;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageview;
@property (strong, nonatomic) IBOutlet UILabel *japaneseLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *chineseLabel;
@property (strong, nonatomic) IBOutlet UISlider *speedSlider;
@property (strong, nonatomic) IBOutlet UIButton *upBtn;

@property (strong, nonatomic) IBOutlet UIButton *playBtn;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;



@end
