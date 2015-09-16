//
//  TitleView.h
//  Translation
//
//  Created by monstarlab6 on 15-9-8.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THCircularProgressView;
@interface TitleView : UIView
@property (strong,nonatomic) THCircularProgressView * example2;
@property (strong, nonatomic) IBOutlet UIView *circleView;
@property (strong, nonatomic) IBOutlet UILabel *bigLockLable;
@property (strong, nonatomic) IBOutlet UILabel *passLabel;
@property (strong, nonatomic) IBOutlet UILabel *allLabel;
@property (strong, nonatomic) UILabel * percentLabel;

@end
