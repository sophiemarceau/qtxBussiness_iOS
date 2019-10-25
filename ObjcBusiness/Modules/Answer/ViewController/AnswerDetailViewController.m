//
//  AnswerDetailViewController.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/11/5.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AnswerDetailViewController.h"
#import "SharedView.h"
#import "ComplainViewController.h"
#import "QuestDetailViewController.h"
#import "PersonalHomePageViewController.h"
#import "IQKeyboardManager.h"
@interface AnswerDetailViewController ()<UIWebViewDelegate,SelectSharedTypeDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSString *answerTitle;
@property (nonatomic,strong)NSString *answerDesc;
@property (nonatomic,strong)NSString *nameStr;
@property (nonatomic,strong)NSString *namePhotoStr;
@end

@implementation AnswerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"答案详情";
    [self loadData];
    [self initNavgation];
    [self initSubViews];
}

-(void)loadData{
    NSDictionary *dic = @{@"answer_id":[NSString stringWithFormat:@"%ld",self.answer_id]};
    [[RequestManager shareRequestManager]  getAnswerDetail:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result---getAnswerDetail--->%@",result);
        if (IsSucess(result) == 1) {
            self.answerDesc = result[@"data"][@"result"][@"answer_content"];
            self.answerTitle= result[@"data"][@"result"][@"questionDto"][@"question_content"];
            self.nameStr = result[@"data"][@"result"][@"userCSimpleInfoDto"][@"c_nickname"];
            self.namePhotoStr = result[@"data"][@"result"][@"userCSimpleInfoDto"][@"c_photo"];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    } failuer:^(NSError *error) {
        
    }];
}
-(void)shareClick:(UIButton *)sender{
    NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:self.namePhotoStr]];
    id image = [UIImage imageWithData:data];
    if (image == nil) {
        image = @"";
    }
    NSDictionary *dic = @{@"title" :self.answerTitle,
                          @"desc" :[NSString stringWithFormat:@"%@回答:%@",self.nameStr,self.answerDesc],
                          @"image":image,
                          @"url"  :[NSString stringWithFormat:@"%@/%@",@"answer",[NSString stringWithFormat:@"%ld",self.answer_id]]};
    SharedView *sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    sharedView.fromWhereFlag = ShareTypeFromAnswerDetail;
    sharedView.answer_id = self.answer_id;
    sharedView.delegate = self;
    sharedView.currentVC = self;
    
    [sharedView initPublishContent:dic FlagWithDeleButton:0];
}

- (void)SelectSharedTypeDelegateReturnPage:(ShareType)returnShareType{
//    NSLog(@"SelectSharedTypeDelegateReturnPage-------");
    if (returnShareType == ShareTypeReport) {
        NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (userID) {
            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                ComplainViewController *vc = [[ComplainViewController alloc] init];
                vc.feedback_kind = 1;
                vc.reportType = 4;
                vc.reportFromID = self.answer_id;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
        }
        
    }
    
    if(returnShareType == ShareTypeDelete){
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (returnShareType == ShareTypeCopy) {
        [[RequestManager shareRequestManager] tipAlert:@"复制成功" viewController:self];
    }
}

#pragma mark -Navigation
- (void)initNavgation{
    UIImage *rightImage = nil;
    rightImage =[UIImage imageNamed:@"detail_pages_btn_more"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton sizeToFit];
    //点击事件
    [rightButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [rightBackItem setTitle:@""];
    self.navigationItem.rightBarButtonItem = rightBackItem;
}

-(void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.frame =self.webView.frame;
    _webView.backgroundColor = BGColorGray;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavHeight)];
    _webView.delegate = self;
    [self.view addSubview:self.webView];
//    NSLog(@"self.view----->%@",self.view);
//    NSLog(@"self.webView----->%@",self.webView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    // 将获取的cookie储存在沙盒中（ 通过 [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie: cookies]来保存cookies，但是我发现，即使这样设置之后再app退出之后，该cookies还是丢失了（其实是cookies过期的问题)
//    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    NSHTTPCookie *cookie;
//    for (id c in nCookies)
//    {
//        if ([c isKindOfClass:[NSHTTPCookie class]])
//        {
//            cookie=(NSHTTPCookie *)c;
//            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
//                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
//                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
//                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
//                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
//                break;
//            }
//        }
//    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"--------------%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"--------------%@",request.URL.absoluteString);
    if ([request.URL.absoluteString containsString:@"user:"]) {
        NSInteger userID =  [[[request.URL.absoluteString componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
//        NSLog(@"--------------%@",request.URL.absoluteString);
        PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
        vc.user_id = userID;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    if ([request.URL.absoluteString containsString:@"question:"]) {
        NSInteger questionID =  [[[request.URL.absoluteString componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
        QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
        vc.title = @"问题详情";
        vc.question_id =questionID;
        [self.navigationController pushViewController:vc animated:YES];
        ///不发起请求
        return NO;
    }
    if ([request.URL.absoluteString containsString:@"goAppLoingPage"]) {
//        NSLog(@"--------------%@",request.URL.absoluteString);
        NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (userID) {
            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
        }
        return NO;
    }
//    if ([request.URL.absoluteString containsString:@"goAppLoingPage"]) {
//        NSLog(@"--------------%@",request.URL.absoluteString);
//        ///获取到请求的 url中传回的信息 包含 jsBack 则返回上一级
//        [self.navigationController popViewControllerAnimated:YES];
//        ///不发起请求
//        return NO;
//    }
    return YES;
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}
- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [MobClick beginLogPageView:kAnswerDetailPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [MobClick endLogPageView:kAnswerDetailPage];
}





-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *reqeustURLStr = [NSString stringWithFormat:@"%@%@%ld",BaseURLHTMLString,@"answer4App?answer_id=",(long)self.answer_id];
//    NSString *reqeustURLStr = @"http:www.baidu.com";
//    NSLog(@"答案详情----reqeustURLStr---->%@",reqeustURLStr);
    NSString *user_id = [DEFAULTS objectForKey:@"userId"];
//    NSLog(@"user_id----reqeustURLStr---->%@",user_id);
    [self addCookieToURL:[NSURL URLWithString:reqeustURLStr] key:@"user_id" value:user_id];
    [self addCookieToURL:[NSURL URLWithString:reqeustURLStr] key:@"qtxsy_auth" value:[DEFAULTS objectForKey:@"qtxsy_auth"]];
    //发请求
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",reqeustURLStr]]];
//        _webView.scalesPageToFit = YES;
    [ self.webView loadRequest:req];
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


@end
