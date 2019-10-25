//
//  CompanyBaseCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterpriseItem.h"
@interface CompanyBaseCell : UITableViewCell
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(EnterpriseItem *)object;
@end
