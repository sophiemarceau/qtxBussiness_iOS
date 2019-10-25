
//  WXMovie
//
//  //  Copyright (c) All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"


@interface BaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *data;

//当前选中得单元格indexPath
@property(nonatomic,retain)NSIndexPath *selectIndexPath;




@end
