//
//  ExpertTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"
//@protocol CLTagButtonDelegate <NSObject>
//
//@optional
//
//// 菜单栏删除按钮回调
//- (void)tagButtonDelete:(CLTagButton *)tagBtn;
//
//
//
//@end

@interface ExpertTableViewCell : BaseTableViewCell

@property (nonatomic,strong)UIImageView *headerImageView,*headerFlagImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *expertDesLAbel;
@property (nonatomic,strong)UIButton *expertButton;
@property (nonatomic,strong)UIImageView *lineImageView;

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,assign)NSInteger question_id;



@property(nonatomic,strong)UIViewController *superVC;
@end
