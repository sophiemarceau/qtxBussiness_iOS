//
//  SystemMessageTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SystemBaseTableViewCell.h"
#import "SystemTableItem.h"

@interface SystemMessageTableViewCell : SystemBaseTableViewCell
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UIImageView *picImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *checkLabel;
- (void)setResumeTableItem:(SystemTableItem *)resumTableItem;
@end
