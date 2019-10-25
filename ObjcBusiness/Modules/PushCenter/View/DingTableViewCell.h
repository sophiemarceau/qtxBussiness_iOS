//
//  DingTableViewCell.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/31.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"
@class DingFrame;
@protocol  DingHeaderViewDelegate<NSObject>
- (void)didSelectHeaderGotoHomePage:(NSInteger)userID;
@end
@interface DingTableViewCell : BaseTableViewCell

@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIImageView *headerFlagImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *jobDesLabel;
@property(nonatomic,strong)UILabel *commentFromLabel;
@property(nonatomic,strong)UILabel *scoreLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic, weak)id <DingHeaderViewDelegate>delegate;
@property(nonatomic,strong)NSDictionary *mydictionary;
@property (nonatomic,strong)DingFrame *dingFrame;
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
