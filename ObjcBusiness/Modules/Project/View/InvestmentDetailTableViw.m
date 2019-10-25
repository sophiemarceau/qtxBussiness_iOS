//
//  InvestmentDetailTableViw.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/12/10.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "InvestmentDetailTableViw.h"
#import "YX.h"

@implementation InvestmentDetailTableViw

-(void)renderUIWithInfo:(NSDictionary *)info{
    [super renderUIWithInfo:info];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.frame = CGRectMake(0, 0, kScreenWidth,0);
     self.webView.UIDelegate = self;
    self.webView.scrollView.bounces=NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO; //去掉下面黑线
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    NSString *path = self.info[@"data"] ;
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webView sizeToFit];
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    self.webView.frame=CGRectMake(0, 0, kScreenWidth,[change[@"new"] CGSizeValue].height );
    [self.tableView setTableHeaderView:self.webView];}

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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.webView.frame=CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    [[NSNotificationCenter defaultCenter]postNotificationName:kfinishLoadingView object:nil];
    
}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
////    NSLog(@"path------------招商详情--------------->webViewDidFinishLoad");
//    self.webView.frame=CGRectMake(0, 0, kScreenWidth,kScreenHeight);
//    [[NSNotificationCenter defaultCenter]postNotificationName:kfinishLoadingView object:nil];
//}

-(void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}
@end
