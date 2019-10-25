//
//  QuestListCell.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableView.h"
@class NewQuestionCellFrame;
@interface QuestListCell : UITableViewCell

@property (nonatomic,strong)UIView *infoView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *questionContentLabel;
@property (nonatomic,strong)UIView *questionContentBgView;
@property (nonatomic,strong)UILabel *leftSubDesLabel;

@property (nonatomic,strong)NewQuestionCellFrame *homeNewQuestionCellFrame;
/**
 *  返回复用的HUserStatusCell
 *
 *  @param tableView 当前展示的tableView
 */
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
