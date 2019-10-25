//
//  ProjectIntrduceTableView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "YXTabItemBaseView.h"
#import <WebKit/WebKit.h>

@interface ProjectIntrduceTableView : YXTabItemBaseView<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)WKWebView *webView;

@end
