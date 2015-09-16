//
//  DictionaryNewViewController.h
//  Translation
//
//  Created by monstarlab6 on 15-9-10.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchView;
@class AllWordsView;
@interface DictionaryNewViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic,strong) SearchView * searchView;
@property (nonatomic,strong) AllWordsView * allwordsView;
@property (nonatomic,strong)NSMutableArray * allWords;
@end
