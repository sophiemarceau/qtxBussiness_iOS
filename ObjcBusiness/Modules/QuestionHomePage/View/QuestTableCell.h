//
//  QuestTableCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class  QuestModel;
@protocol  HeaderViewDelegate<NSObject>
- (void)didSelectHeaderGotoHomePage:(NSInteger)userID;
@end
@class QuestTableViewCellFrame;
@interface QuestTableCell : UITableViewCell
@property (nonatomic,strong)UIView *infoView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *headerImageView,*headerFlagImageView;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *jobDesLabel;
@property (nonatomic,strong)UILabel *questionContentLabel;
@property (nonatomic,strong)UIView *questionContentBgView;
@property (nonatomic,strong)UILabel *leftSubDesLabel;
//@property (nonatomic,strong)UILabel *rightSubDesLabel;
//@property (nonatomic,strong)QuestModel *model;


@property (nonatomic, weak)id <HeaderViewDelegate>delegate;
@property (nonatomic,strong)QuestTableViewCellFrame *questTableViewCellFrame;
/**
 *  返回复用的HUserStatusCell
 *
 *  @param tableView 当前展示的tableView
 */
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
