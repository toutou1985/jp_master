//
//  GamePointsNewViewController.h
//  Translation
//
//  Created by monstarlab6 on 15-9-3.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface GamePointsNewViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic, assign) ModeType modeType;

@end
