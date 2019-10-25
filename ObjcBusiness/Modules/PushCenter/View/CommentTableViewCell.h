//
//  CommentTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"
@class CommentFrame;
@protocol  CommentHeaderViewDelegate<NSObject>
- (void)didSelectHeaderGotoHomePage:(NSInteger)userID;
@end
@interface CommentTableViewCell : BaseTableViewCell

@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIImageView *headerFlagImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *jobDesLabel;
@property(nonatomic,strong)UILabel *commentFromLabel;
@property(nonatomic,strong)UILabel *replyLabel;
@property(nonatomic,strong)UIView *replybgView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic, weak)id <CommentHeaderViewDelegate>delegate;
@property(nonatomic,strong)NSDictionary *mydictionary;

@property(nonatomic,strong)CommentFrame *commentFrame;

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;
@end
