//
//  TagTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TagTableViewCell : BaseTableViewCell

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UIImageView *lineImageView,*arrowImageView;
@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,assign)NSInteger question_id;

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
