//
//  YXTabItemBaseView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
@interface YXTabItemBaseView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSDictionary *cellHeightDic;
-(void)renderUIWithInfo:(NSDictionary *)info;


-(void)renderUIWithInfo:(NSDictionary *)info WithHeight:(CGFloat)height;
@end
