//
//  HomeListView.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/8/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableView.h"
#import "HomeListTableViewCell.h"
#import "HomeListTableViewCell+HomeListModel.h"

@interface HomeListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *homeListArray;
@end
