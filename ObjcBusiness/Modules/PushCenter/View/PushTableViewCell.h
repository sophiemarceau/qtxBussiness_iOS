//
//  PushTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "WHC_BadgeView.h"
@interface PushTableViewCell : BaseTableViewCell{
    
}
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *arrowImageView;
@property(nonatomic,strong)UIImageView *lineImageView;

@property(nonatomic,strong)NSDictionary *mydictionary;
@property(nonatomic,strong)WHC_BadgeView *badgeView;
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
