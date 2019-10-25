//
//  ResumeHeaderView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ResumeHeaderView.h"
@interface ResumeHeaderView ()


@property (nonatomic,strong)UIImageView *arrowImageView;
@end
@implementation ResumeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = BGColorGray;
        [self InitViews];
    }
    return self;
}
- (void)InitViews{
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.arrowImageView];
    [self.headerView addSubview:self.userNameLabel];
    [self.headerView addSubview:self.headerImageView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 75*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(12.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(75*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(31.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(75+15)*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(30*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
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
        self.headerImageView.layer.cornerRadius = 50/2*AUTO_SIZE_SCALE_X;
        self.headerImageView.layer.borderWidth= 1.0;
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.headerImageView.backgroundColor = RedUIColorC1;
    }
    return _headerImageView;
}

-(UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        _userNameLabel = [CommentMethod initLabelWithText:@"头像" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorBlack];
    }
    return _userNameLabel;
}
@end
