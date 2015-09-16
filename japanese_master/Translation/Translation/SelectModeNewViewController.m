//
//  SelectModeNewViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-2.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "SelectModeNewViewController.h"
#import "Config.h"
#import "GamePointsNewViewController.h"
#import "RemenberScreenViewController.h"
#import "StatisticsNewViewController.h"
#import "DictionaryViewController.h"
#import "DictionaryNewViewController.h"
@interface SelectModeNewViewController ()
{
    IBOutlet UIScrollView *bgscrollView;
    
    IBOutlet UIImageView *bgimageView;
    
    
    IBOutlet UIButton *gameBtn;
    
    
    IBOutlet UIButton *learnBtn;
    
    IBOutlet UIButton *accountBtn;
    
    IBOutlet UIImageView *introductionView;
    
    IBOutlet UIButton *dictionaryBtn;
    
    
    
    
    
}

@end

@implementation SelectModeNewViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView * titleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/320*50)];
    [titleImageview setImage:[UIImage imageNamed:@"navView"]];
    [self.view addSubview:titleImageview];

}
- (IBAction)allbtnTapped:(UIButton *)sender {
    
    switch (sender.tag)
    {
        case 100:
        {
            GamePointsNewViewController *vc = [[GamePointsNewViewController alloc]init];
            vc.modeType = kModeTypeGame;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:
        {
            DictionaryNewViewController *vc = [[DictionaryNewViewController alloc]initWithNibName:@"DictionaryNewViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
        {
            GamePointsNewViewController *vc = [[GamePointsNewViewController alloc]init];
            vc.modeType = kModeTypeRemeber;
            [self.navigationController pushViewController:vc animated:YES];
            //            RemenberScreenViewController *vc = [[RemenberScreenViewController alloc]init];
            //            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 103:
        {
            StatisticsNewViewController *vc = [[StatisticsNewViewController alloc]initWithNibName:@"StatisticsNewViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
