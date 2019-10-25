//
//  AddPolicyTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeTableItem.h"

@interface AddPolicyTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UITextField *ValueLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;
/**
 *  返回复用的HUserStatusCell
 *
 *  @param tableView 当前展示的tableView
 */
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
