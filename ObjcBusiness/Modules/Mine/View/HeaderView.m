//
//  HeaderView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/25.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        [self initViews];
    }
    return self;
}



-(void)initViews{
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.expertFlagImageView];
    [self addSubview:self.companyFlagImageView];
    [self addSubview:self.userSubLabel];
    [self addSubview:self.AttentLabel];
    [self addSubview:self.personalPageLabel];
    
//    [self addSubview:self.tabbarView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(55*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(25*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(15*AUTO_SIZE_SCALE_X);
    }];
        
    [self.expertFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(27*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(11*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X));
    }];
    
    [self.companyFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expertFlagImageView.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(27*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(11*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X));
    }];
    
    [self.userSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(90+15)*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    
    [self.personalPageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(30.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(78*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
    }];
    
    [self.AttentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(30.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(78*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
    }];
//    [self.tabbarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(0*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.mas_top).offset(85*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 78*AUTO_SIZE_SCALE_X));
//    }];
    
}


- (UIImageView *)expertFlagImageView {
    if (_expertFlagImageView == nil) {
        _expertFlagImageView = [UIImageView new];
        _expertFlagImageView.image =[UIImage imageNamed:@"me_icon_expert_certification"];
        _expertFlagImageView.hidden = YES;
    }
    return _expertFlagImageView;
}

- (UIImageView *)companyFlagImageView {
    if (_companyFlagImageView == nil) {
        _companyFlagImageView = [UIImageView new];
        _companyFlagImageView.image =[UIImage imageNamed:@"me_icon_enterprise_certification"];
        _companyFlagImageView.hidden = YES;
    }
    return _companyFlagImageView;
}

- (UIImageView *)headerImageView {
    if (_headerImageView == nil) {
        self.headerImageView = [UIImageView new];
        self.headerImageView.image =[UIImage imageNamed:@"img-defult-account"];
        self.headerImageView.layer.cornerRadius = 55/2*AUTO_SIZE_SCALE_X;
        self.headerImageView.layer.borderWidth=1.0;
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.headerImageView.backgroundColor = [UIColor clearColor];
    }
    return _headerImageView;
}

- (UILabel *)userNameLabel {
    if (_userNameLabel == nil) {
        self.userNameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
        self.userNameLabel.numberOfLines =1;
    }
    return _userNameLabel;
}

- (UILabel *)userSubLabel {
    if (_userSubLabel == nil) {
        self.userSubLabel =  [CommentMethod initLabelWithText:@"用一句话介绍一下你自己吧" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorGray];
    }
    return _userSubLabel;
}

- (UILabel *)personalPageLabel {
    if (_personalPageLabel == nil) {
        self.personalPageLabel = [CommentMethod initLabelWithText:@"个人主页" textAlignment:NSTextAlignmentCenter font:12 TextColor:FontUIColorBlack];
        self.personalPageLabel.layer.masksToBounds = YES;
        self.personalPageLabel.backgroundColor = UIColorFromRGB(0xF4F5F7);
        self.personalPageLabel.layer.cornerRadius = 15;
        self.personalPageLabel.userInteractionEnabled = YES;
        self.personalPageLabel.font = [UIFont boldSystemFontOfSize:12*AUTO_SIZE_SCALE_X];
    }
    return _personalPageLabel;
}


- (UILabel *)AttentLabel {
    if (_AttentLabel == nil) {
        _AttentLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:14 TextColor:FontUIColorBlack];
        _AttentLabel.layer.masksToBounds = YES;
        _AttentLabel.font = [UIFont boldSystemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _AttentLabel.backgroundColor = UIColorFromRGB(0xF4F5F7);
        _AttentLabel.layer.cornerRadius = 15;
        _AttentLabel.userInteractionEnabled = YES;
        _AttentLabel.hidden = YES;
    }
    return _AttentLabel;
}
@end
