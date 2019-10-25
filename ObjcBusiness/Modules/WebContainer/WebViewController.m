//
//  WebViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end



@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initSubViews];
}
    
-(void)initSubViews{
    self.title = self.webtitle;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.frame =self.webView.frame;
    _webView.backgroundColor = BGColorGray;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavHeight)];
    _webView.delegate = self;
    NSString *reqeustURLStr = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,self.webViewurl];
    
    NSString *user_id = [DEFAULTS objectForKey:@"userId"];
    
    [self addCookieToURL:[NSURL URLWithString:reqeustURLStr] key:@"user_id" value:user_id];
    [self addCookieToURL:[NSURL URLWithString:reqeustURLStr] key:@"qtxsy_auth" value:[DEFAULTS objectForKey:@"qtxsy_auth"]];
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
    [LZBLoadingView dismissLoadingView];

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
    [MobClick beginLogPageView:kMyScoresPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyScoresPage];
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
    /*The cookies will replace existing cookies with the same name, domain, and path, if one exists in the cookie storage. The cookie will be ignored if the receiver's cookie accept policy is NSHTTPCookieAcceptPolicyNever.
     To store cookies from a set of response headers, an application can use cookiesWithResponseHeaderFields:forURL: passing a header field dictionary and then use this method to store the resulting cookies in accordance with the receiver’s cookie acceptance policy.
     */
    //- (void)setCookie:(NSHTTPCookie *)aCookie
    [cookieStorage setCookies:cookies forURL:url mainDocumentURL:nil];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
