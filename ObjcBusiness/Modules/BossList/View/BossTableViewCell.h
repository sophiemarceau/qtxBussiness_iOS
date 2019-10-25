//
//  BossTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BossCellFrame;

@interface BossTableViewCell : UITableViewCell
@property (nonatomic,strong)BossCellFrame *bossCellFrame;

@property (nonatomic,strong)UIView *CellBGView;
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UIImageView *bossFlagImageView;
@property (nonatomic,strong)UILabel *nameAndJobLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,strong)UIImageView *locationImageView;
@property (nonatomic,strong)UILabel *locationLabel;
@property (nonatomic,strong)UIButton *directChatImageView;
@property (nonatomic,strong)UIImageView *tradeImageView;
@property (nonatomic,strong)UILabel *tradeLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UIImageView *companyPicImageView;
@property (nonatomic,strong)UILabel *companyNameLabel;
@property (nonatomic,strong)UIImageView *identifyIconImageView;
@property (nonatomic,strong)UILabel *companySubLabel;
@property (nonatomic,strong)UIViewController *superVC;

@property (nonatomic,assign)NSString *user_id_str;
@property (nonatomic,assign)NSInteger userID;
@property (nonatomic,assign)NSString *bossName;
/**
 *  返回复用的HUserStatusCell
 *
 *  @param tableView 当前展示的tableView
 */
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
