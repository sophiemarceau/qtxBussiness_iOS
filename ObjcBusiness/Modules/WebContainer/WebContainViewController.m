//
//  WebContainViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "WebContainViewController.h"

@interface WebContainViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation WebContainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

-(void)initSubViews{
    self.title = self.webtitle;
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.frame =self.webView.frame;
    self.webView.backgroundColor = BGColorGray;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavHeight)];
    self.webView.delegate = self;
    NSString *reqeustURLStr = [NSString stringWithFormat:@"%@",self.webViewurl];
    
//    NSString *user_id = [DEFAULTS objectForKey:@"userId"];
    
//    [self addCookieToURL:[NSURL URLWithString:reqeustURLStr] key:@"user_id" value:user_id];
//    [self addCookieToURL:[NSURL URLWithString:reqeustURLStr] key:@"qtxsy_auth" value:[DEFAULTS objectForKey:@"qtxsy_auth"]];
    //发请求
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",reqeustURLStr]]];
    //    _webView.scalesPageToFit = YES;
    [ self.webView loadRequest:req];
    [self.view addSubview:self.webView];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    [LZBLoadingView dismissLoadingView];
    
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}
- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

//设置cookie 传入userid
-(void)addCookieToURL:(NSURL *)url key:(NSString *)key value:(NSString *)value{
    NSString *newValue = (value != nil) ? value : @"";
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookies = [NSMutableArray arrayWithArray:[cookieStorage cookiesForURL:url]];
    NSString *domian =  [url host];
    NSString *path =  [url path];
    NSMutableArray *tempCookies = [cookies copy];
    for (NSHTTPCookie *cookie in tempCookies) {
        if ([cookie.name isEqualToString:key]) {
            [cookies removeObject:cookie];
        }
    }
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:key forKey:NSHTTPCookieName];
    [properties setObject:newValue forKey:NSHTTPCookieValue];
    [properties setObject:domian forKey:NSHTTPCookieDomain];
    [properties setObject:path forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:properties];
    [cookies addObject:cookieuser];

    [cookieStorage setCookies:cookies forURL:url mainDocumentURL:nil];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
