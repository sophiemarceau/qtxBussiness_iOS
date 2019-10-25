//
//  DetailTableViewCell+DetailModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DetailTableViewCell.h"
@class DetailCellModel;
@interface DetailTableViewCell (DetailModel)


- (void)configureWithHomeListEntity:(NSDictionary *)homeListModel;
@end
