//
//  BossProjectListViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossProjectListViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface BossProjectListViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>{
    NSHTTPCookieStorage *cookieStorage ;
}
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)JSContext *jsContext;
@property (nonatomic, assign) BOOL canScroll;
@end

@implementation BossProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-44*AUTO_SIZE_SCALE_X)];
//    nocontent.hidden = YES;
//    [self.view addSubview:nocontent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kGoTopNotificationName object:nil];
    
//    NSString *user_id = [DEFAULTS objectForKey:@"userId"];
//    NSString *qtxsy_auth = [DEFAULTS objectForKey:@"qtxsy_auth"];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSString *sourceStr = [NSString stringWithFormat:@"document.cookie ='user_id=%@';document.cookie = 'qtxsy_auth=%@';",user_id,qtxsy_auth];
//    //初始化
//    WKUserContentController* userContentController = WKUserContentController.new;
//    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:sourceStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//    [userContentController addUserScript:cookieScript];
//    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
//    webViewConfig.userContentController = userContentController;

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, scrollViewHeight)];
                    
//                    initWithFrame:CGRectMake(0, 0, kScreenWidth, scrollViewHeight) configuration:webViewConfig];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.delegate = self;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:self.reqeustURLStr] ;

//    [self addCookieToURL:url key:@"user_id" value:user_id];
//    [self addCookieToURL:url key:@"qtxsy_auth" value:qtxsy_auth];
//
//    NSMutableString *cookieString = [[NSMutableString alloc] init];
//    for (NSHTTPCookie*cookie in [cookieStorage cookies]) {
//        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
//    }
//    //删除最后一个“；”
//    [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
    
    [self.webView loadRequest:request];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)acceptMsg:(NSNotification *)notification{
//    NSLog(@"acceptMsg----%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        self.canScroll = YES;
        self.webView.scrollView.scrollEnabled = YES;
        self.webView.scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.DidScrollBlock) {
        self.DidScrollBlock(scrollView.contentOffset.y);
    }
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
        [scrollView setContentOffset:CGPointZero];
        self.canScroll = NO;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.scrollEnabled = NO;
    }
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

@end
