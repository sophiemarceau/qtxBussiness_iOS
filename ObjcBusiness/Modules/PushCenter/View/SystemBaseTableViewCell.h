//
//  SystemBaseTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SystemTableItem;
@interface SystemBaseTableViewCell : UITableViewCell
@property (nonatomic,strong) SystemTableItem *item;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(SystemTableItem *)object;
- (void)setResumeTableItem:(SystemTableItem *)resumTableItem;
@end
