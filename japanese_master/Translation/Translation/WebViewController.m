//
//  WebViewController.m
//  Translation
//
//  Created by monst on 14-9-5.
//  Copyright (c) 2014年 monstar. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    [self.view setBackgroundColor:[UIColor orangeColor]];
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backBtn.frame = CGRectMake(10, 20, 40, 40);
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"part6_3"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
//    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 320, self.view.frame.size.height-70)];
//    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    
//    NSString * string = @"http://fanyi.baidu.com/#jp/zh";
//    NSLog(@"string ========== %@",string);
//    
//    //NSString * encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL* goodPattern = [NSURL URLWithString:
//                          [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURL* url = [NSURL URLWithString:string];//创建URL
//    //[[UIApplication sharedApplication] openURL:url];
//    NSURLRequest* request = [NSURLRequest requestWithURL:goodPattern];//创建NSURLRequest
//    [webView loadRequest:request];//加载
//    [self.view addSubview:webView];
    NSString *searchWord = _receiveStr;
    NSString *urlString = [NSString stringWithFormat:@"http://fanyi.baidu.com/#jp/zh/%@",searchWord];
    //NSString * urlString = @"http://fanyi.baidu.com/#jp/zh";
    
    // ブラウザで開く
    NSURL *url = [NSURL URLWithString:
                [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@url===============",url);
    //NSURL *url = [NSURL URLWithString:urlString];//创建URL
    if(url == nil){
        NSLog(@"NSURL is nil");
    } else {
        [[UIApplication sharedApplication] openURL:url];
    
}
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
