//
//  AboutusViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/2.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "AboutusViewController.h"

@interface AboutusViewController ()<UIWebViewDelegate>{
    UIWebView * webView;
    
}
@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *appversion = [NSString stringWithFormat:@"%@%@",@"?versionName=",app_Version];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",BaseURLHTMLString,@"aboutUs",appversion];
//    NSLog(@"path----%@",path);
    
    self.view.backgroundColor =[UIColor whiteColor];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, self.view.frame.size.width, self.view.frame.size.height-kNavHeight)];
    
    webView.scrollView.bounces = NO;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    
    webView.delegate = self;
    
    [self.view addSubview:webView];

}


- (BOOL)shouldShowGobackButton{
    return  YES;
}
- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kAboutUsPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAboutUsPage];
}
@end
