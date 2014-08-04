//
//  GamePointsViewController.h
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface GamePointsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, assign) ModeType modeType;
@end
