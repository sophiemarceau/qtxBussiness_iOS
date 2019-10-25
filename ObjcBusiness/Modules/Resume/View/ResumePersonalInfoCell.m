//
//  ResumePersonalInfoCell.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/9/10.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ResumePersonalInfoCell.h"
#import "ResumeTableItem.h"
#import "UIImageView+WebCache.h"
@implementation ResumePersonalInfoCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(ResumeTableItem *)object{
    
    return 105*AUTO_SIZE_SCALE_X;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        
    }
    return self;
}
- (void)initSubViews{
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.arrowImageView];
    [self.headerView addSubview:self.userNameLabel];
    [self.headerView addSubview:self.headerImageView];
    [self.headerView addSubview:self.oneMoreIntroduceLabel];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 85*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(55*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(80+45)*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(35*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.oneMoreIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(48*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(80+45)*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
}

- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"list_icon_more"];
    }
    return _arrowImageView;
}

- (UIImageView *)headerImageView{
    if (_headerImageView == nil) {
        _headerImageView = [UIImageView new];
        self.headerImageView.layer.cornerRadius = 55/2*AUTO_SIZE_SCALE_X;
        
        self.headerImageView.layer.masksToBounds = YES;
        
        
    }
    return _headerImageView;
}

-(UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        _userNameLabel = [CommentMethod initLabelWithText:@"头像" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorBlack];
    }
    return _userNameLabel;
}

-(UILabel *)oneMoreIntroduceLabel{
    if (_oneMoreIntroduceLabel == nil) {
        _oneMoreIntroduceLabel = [CommentMethod initLabelWithText:@"一句话介绍你自己" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorGray];
    }
    return _oneMoreIntroduceLabel;
}
- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem{

    self.userNameLabel.text = [DEFAULTS objectForKey:@"userNickName"];
    [self.headerImageView sd_setImageWithURL:[DEFAULTS objectForKey:@"userPortraitUri"] placeholderImage:[UIImage imageNamed:@"me_head_default"]];
    NSString *profiles =[DEFAULTS objectForKey:@"c_profiles"];
//    NSLog(@"profiles----->%@",profiles);
    if (![profiles isEqualToString:@""]) {
        self.oneMoreIntroduceLabel.text = profiles;
    }
}



@end
