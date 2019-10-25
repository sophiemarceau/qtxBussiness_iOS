//
//  ClientView.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/23.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTabItemBaseView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSDictionary *cellHeightDic;
-(void)renderUIWithInfo:(NSDictionary *)info;
@end
