//
//  SystemLabelCellTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SystemBaseTableViewCell.h"
#import "SystemTableItem.h"
@protocol  SystemLabelelegate<NSObject>

- (void)checkButtonOnclick:(NSInteger)index;


@end

@interface SystemLabelCellTableViewCell : SystemBaseTableViewCell
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *checkLabel;

@property (nonatomic,strong)SystemTableItem *resumTableItem;

@property (nonatomic, weak) id <SystemLabelelegate> delegate;

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
-(CGFloat)rowHeightForObject:(SystemTableItem *)resumTableItem;
@end
