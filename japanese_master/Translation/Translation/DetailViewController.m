//
//  DetailViewController.m
//  Translation
//
//  Created by monst on 14-9-5.
//  Copyright (c) 2014年 monstar. All rights reserved.
//

#import "DetailViewController.h"
#import "FMDatabase.h"
#import "Config.h"
#import "WebViewController.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:196/255.0 green:213/255.0 blue:53/255.0 alpha:1]];
    NSLog(@"_wordsArr===========%@",_wordsArr);
    NSLog(@"_row===========%d",_row);
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backBtn.frame = CGRectMake(10, 20, 40, 40);
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"part6_3"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];

    
    self.chineseLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 150, 240, 30)];
    self.chineseLabel.backgroundColor = [UIColor grayColor];
    //    self.chineseLabel.text = @"zhongwen ceshi";
    self.chineseLabel.numberOfLines = 0;
    self.chineseLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chineseLabel.textAlignment = NSTextAlignmentCenter;
    self.chineseLabel.text = [_wordsArr objectAtIndex:0];
    
    [self.view addSubview:self.chineseLabel];
    
    self.pingjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 180, 240, 30)];
    self.pingjiamingLabel.backgroundColor = [UIColor orangeColor];
    //    self.pingjiamingLabel.text = @"pingjiaming ceshi";
    self.pingjiamingLabel.numberOfLines = 0;
    self.pingjiamingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.pingjiamingLabel.textAlignment = NSTextAlignmentCenter;
    self.pingjiamingLabel.text = [_wordsArr objectAtIndex:2];
    [self.view addSubview:self.pingjiamingLabel];
    
    self.pianjiamingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 210, 240, 60)];
    self.pianjiamingLabel.backgroundColor = [UIColor orangeColor];
    //    self.pianjiamingLabel.text = @"pianjiaming ceshi";
    self.pianjiamingLabel.numberOfLines = 0;
    self.pianjiamingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.pianjiamingLabel.textAlignment = NSTextAlignmentCenter;
    self.pianjiamingLabel.text = [_wordsArr objectAtIndex:1];
  
    [self.view addSubview:self.pianjiamingLabel];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(70, 300, 180, 30)];
    [button setTitle:@"点击搜索网络发音" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:136/255.0 green:0 blue:6/255.0 alpha:1]];
    [button addTarget:self action:@selector(netsearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    
}

- (void)netsearch:(id)sender
{
//    WebViewController * webView = [[WebViewController alloc] init];
//    webView.receiveStr = [_wordsArr objectAtIndex:_row * 3];
//    [self.navigationController pushViewController:webView animated:YES];
    NSString *searchWord = [_wordsArr objectAtIndex:_row * 3];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [_wordsArr removeAllObjects];
    
    
}

- (void)buttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
