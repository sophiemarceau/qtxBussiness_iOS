//
//  InvestmentDetailTableViw.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/12/10.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "YXTabItemBaseView.h"
#import <WebKit/WebKit.h>
@interface InvestmentDetailTableViw : YXTabItemBaseView<WKUIDelegate>

@property(nonatomic,strong)WKWebView *webView;

@end
