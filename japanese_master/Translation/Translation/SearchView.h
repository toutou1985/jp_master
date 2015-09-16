//
//  SearchView.h
//  Translation
//
//  Created by monstarlab6 on 15-9-10.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextfield;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UILabel *chineseLabel;
@property (strong, nonatomic) IBOutlet UILabel *japaneseLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

@end
