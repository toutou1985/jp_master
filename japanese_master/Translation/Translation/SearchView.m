//
//  SearchView.m
//  Translation
//
//  Created by monstarlab6 on 15-9-10.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView
- (void)awakeFromNib
{
    [self.searchTextfield setBackgroundColor:[UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1]];
    [self.buttonView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1]];
    self.searchTextfield.delegate = self;
      self.chineseLabel.textColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1];
    [self.lineView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1]];
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+80, bounds.origin.y, bounds.size.width -60, bounds.size.height);//更好理解些
    
    return inset;
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +80, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
