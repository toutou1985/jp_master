//
//  GameScreenViewController.h
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameScreenViewController : UIViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *task;
@end
