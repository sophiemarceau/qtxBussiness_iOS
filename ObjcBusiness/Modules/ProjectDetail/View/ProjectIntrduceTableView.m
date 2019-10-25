//
//  ProjectIntrduceTableView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ProjectIntrduceTableView.h"

@implementation ProjectIntrduceTableView

-(void)renderUIWithInfo:(NSDictionary *)info{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kGoTopNotificationName object:nil];
    self.info = info;
    NSNumber *position = info[@"position"];
    int num = [position intValue];
    self.frame = CGRectMake(num*kScreenWidth, 0, kScreenWidth, kScreenHeight-kNavHeight-50-45);
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-50);
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.bounces=NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO; //去掉下面黑线
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    NSString *path = info[@"data"] ;
    
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webView sizeToFit];
    [self addSubview:self.webView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    //   NSLog(@"path------------项目介绍-----webViewHeight---------->%@",change);
    
//    self.webView.frame=CGRectMake(0, 0, kScreenWidth,[change[@"new"] CGSizeValue].height );
//    [self.tableView setTableHeaderView:self.webView];
    
    //    if ([keyPath isEqualToString:@"contentSize"]) {
    //        float  webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"getPheight();"] floatValue];
    //        NSLog(@"path------------项目介绍-----webViewHeight---------->%f",webViewHeight);
    //        self.webView.frame=CGRectMake(0, 0, kScreenWidth,webViewHeight );
    //        [self.tableView setTableHeaderView:self.webView];
    //
    //    }
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//       float webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//        CGRect newFrame       = self.webView.frame;
//        newFrame.size.height  = webViewHeight;
//        self.webView.frame = newFrame;
//        [self.tableView setTableHeaderView:self.webView];
//    }
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    self.webViewH = [change[@"new"] CGSizeValue].height;
//    [self.tableView reloadData];
//}

//-(void)loadHieght{
//    // 手动调用JS代码
//    // 每次页面完成都弹出来，大家可以在测试时再打开
//    NSString *js = @"getPheight();";
//    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        NSLog(@"项目介绍-------------------response: %@ error: %@",response,error);
//        if(![response isEqual:[NSNull null]] && response !=nil){
//            self.webView.frame=CGRectMake(0, 0, kScreenWidth,[response floatValue]);
//            self.tableView.tableHeaderView =  self.webView;
////            [self.tableView reloadData];
//
//             [[NSNotificationCenter defaultCenter]postNotificationName:kfinishLoadingView object:nil];
//        }
//    }];
//}
#pragma mark TableView代理


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kfinishLoadingView object:nil];
    
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
////    NSLog(@"path------------项目介绍--------------->webViewDidFinishLoad");
//    self.webView.frame=CGRectMake(0, 0, kScreenWidth,kScreenHeight);
//    [[NSNotificationCenter defaultCenter]postNotificationName:kfinishLoadingView object:nil];
//}

-(void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

-(void)acceptMsg:(NSNotification *)notification{
    NSLog(@"---projectintroducttable---acceptMsg----%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        self.canScroll = YES;
        self.webView.scrollView.scrollEnabled = YES;
        self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"---projectintroducttable---offsetY----%f",offsetY);
    if (offsetY==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
        [scrollView setContentOffset:CGPointZero];
        self.canScroll = NO;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
}
@end
