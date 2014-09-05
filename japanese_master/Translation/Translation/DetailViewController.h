//
//  DetailViewController.h
//  Translation
//
//  Created by monst on 14-9-5.
//  Copyright (c) 2014年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{

    
}
@property (nonatomic,assign) int  row;
@property (nonatomic,strong) NSMutableArray *displayWordsArr;
@property (nonatomic,strong) NSMutableArray * wordsArr;
@property (nonatomic, strong) UILabel *pingjiamingLabel;
@property (nonatomic, strong) UILabel *pianjiamingLabel;
@property (nonatomic, strong) UILabel *chineseLabel;
@property (nonatomic, strong) UIButton *backBtn;
@end
