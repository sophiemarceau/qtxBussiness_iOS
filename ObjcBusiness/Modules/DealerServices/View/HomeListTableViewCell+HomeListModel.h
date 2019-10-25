//
//  HomeListTableViewCell+HomeListModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "HomeListTableViewCell.h"
#import "HomeListModel.h"
@class HomeListModel;
@interface HomeListTableViewCell (HomeListModel)
- (void)configureWithHomeListEntity:(NSDictionary *)homeListModel;
@end
