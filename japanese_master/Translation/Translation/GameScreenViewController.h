//
//  GameScreenViewController.h
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTickerView.h"
@interface GameScreenViewController : UIViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    
	// The ticker
	JHTickerView *ticker;
}

@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *task;
@property (nonatomic,strong) NSString * isclicks;
@end
