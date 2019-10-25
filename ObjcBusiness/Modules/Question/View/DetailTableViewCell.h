//
//  DetailTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  DetailTableHeaderViewDelegate<NSObject>
- (void)didSelectHeaderGotoHomePage:(NSInteger)userID;
@end

@class DetailTableCellFrame;
@interface DetailTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView *infoView;
@property (nonatomic,strong)UIImageView *headerImageView,*headerFlagImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *jobDesLabel;
@property (nonatomic,strong)UILabel *questionContentLabel;
@property (nonatomic,strong)UILabel *leftSubDesLabel;
@property (nonatomic,strong)UILabel *rightSubDesLabel;

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)DetailTableCellFrame *detailTableViewFrame;
@property (nonatomic, weak)id <DetailTableHeaderViewDelegate>delegate;
@end
