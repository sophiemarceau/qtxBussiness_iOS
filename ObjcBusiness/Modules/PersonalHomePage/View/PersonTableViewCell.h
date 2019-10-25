//
//  PersonTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PersonTableViewCell : BaseTableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIImageView *headerFlagImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *jobDesLabel;


@property(nonatomic,strong)UIImageView *lineImageView;

@property(nonatomic,strong)NSDictionary *mydictionary;

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
