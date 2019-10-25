//
//  MyScoresViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MyScoresViewController.h"
#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface MyScoresViewController ()<WKUIDelegate,WKNavigationDelegate>{
    NSString *reqeustURLStr;
    NSHTTPCookieStorage *cookieStorage ;
}
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)JSContext *jsContext;
@end

@implementation MyScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgation];
    [self initSubViews];
}

-(void)shareClick:(UIButton *)sender{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.webtitle = @"积分规则";
    vc.webViewurl = @"exchange/rule4app";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -Navigation
- (void)initNavgation{
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"积分规则" style:UIBarButtonItemStylePlain target:self action:@selector(shareClick:)];
    rightBackItem.tintColor = RedUIColorC1;
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

-(void)initSubViews{
//    注意：
//
//    JS注入的Cookie，比如PHP代码在Cookie容器中取是取不到的， javascript document.cookie能读取到，浏览器中也能看到。
//
//    NSMutableURLRequest 注入的PHP等动态语言直接能从$_COOKIE对象中获取到，但是js读取不到，浏览器也看不到
//
//    所以合理的办法让js，php，浏览器都能读取到相同的Cookie方法就是创建WebView的时候javascript注入Cookie，一开始发送NSMutableURLRequest请求的时候也要加上Cookie，并且保证两个地方的设置的cookie一致。
    NSString *user_id = [DEFAULTS objectForKey:@"userId"];
    NSString *qtxsy_auth = [DEFAULTS objectForKey:@"qtxsy_auth"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *sourceStr = [NSString stringWithFormat:@"document.cookie ='user_id=%@';document.cookie = 'qtxsy_auth=%@';",user_id,qtxsy_auth];
    //初始化
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:sourceStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
    webViewConfig.userContentController = userContentController;

    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavHeight) configuration:webViewConfig];
    self.webView.backgroundColor = BGColorGray;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    reqeustURLStr = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"exchange/list4app"];
    NSURL *url = [NSURL URLWithString:reqeustURLStr] ;
    
    
    [self addCookieToURL:url key:@"user_id" value:user_id];
    [self addCookieToURL:url key:@"qtxsy_auth" value:qtxsy_auth];
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    NSMutableString *cookieString = [[NSMutableString alloc] init];
    for (NSHTTPCookie*cookie in [cookieStorage cookies]) {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    //删除最后一个“；”
    [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    
    [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView loadRequest:request];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            self.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     [LZBLoadingView dismissLoadingView];
}

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated{
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
    cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
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
    if (_webView !=nil && self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
