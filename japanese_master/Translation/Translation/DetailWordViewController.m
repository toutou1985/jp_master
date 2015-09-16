//
//  DetailWordViewController.m
//  Translation
//
//  Created by monstarlab6 on 15-9-16.
//  Copyright (c) 2015年 monstar. All rights reserved.
//

#import "DetailWordViewController.h"

@interface DetailWordViewController ()

@end

@implementation DetailWordViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView * titleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/320*50)];
    [titleImageview setImage:[UIImage imageNamed:@"navView"]];
    [self.view addSubview:titleImageview];
    
    UIButton * backbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    self.chineseLabel.text = [self.wordsArr objectAtIndex:2];
    self.pianLabel.text = [self.wordsArr objectAtIndex:0];
    self.pianLabel.textColor = [UIColor colorWithRed:59/255.0 green:178/255.0 blue:215/255.0 alpha:1];
    self.pianLabel.textAlignment = NSTextAlignmentCenter;
    self.chineseLabel.textAlignment = NSTextAlignmentCenter;
    

}
- (void)backbtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)voicebtn:(id)sender {
    NSString *searchWord = [_wordsArr objectAtIndex:0];
    NSString *urlString = [NSString stringWithFormat:@"http://fanyi.baidu.com/#jp/zh/%@",searchWord];
    //NSString * urlString = @"http://fanyi.baidu.com/#jp/zh/生きる";
    //NSString * urlString = @"https://www.google.co.jp/#q=生きる";
    //NSString *url2 =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *url3 =[url2 stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
    
    //stringByReplacingOccurrencesOfString:@"" withString:[@"%23"];
    
    // ブラウザで開く
    NSURL *url = [NSURL URLWithString:[[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"%23" withString:@"#"]];
    //NSURL *url = [NSURL URLWithString:url3];
    //NSURL *url = [NSURL URLWithString:urlString];//创建URL
    
    if(url == nil){
        NSLog(@"NSURL is nil");
    } else {
        [[UIApplication sharedApplication] openURL:url];
        
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
