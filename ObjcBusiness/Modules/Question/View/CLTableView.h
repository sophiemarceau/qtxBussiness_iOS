//
//  CLTableView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/17.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableView.h"
@protocol CLTableViewDelegate <NSObject>

@optional



// 展示标签页displayTagView 上的标签点击事件(状态变化已经在内部处理)
- (void)tagtableDidSelected:(NSDictionary *)tagBtn;



@end

@interface CLTableView : BaseTableView
@property (weak, nonatomic) id<CLTableViewDelegate> tagBtnDelegate;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end
