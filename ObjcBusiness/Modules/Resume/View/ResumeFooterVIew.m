//
//  ResumeFooterVIew.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ResumeFooterVIew.h"

@implementation ResumeFooterVIew

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = BGColorGray;
        [self InitViews];
    }
    return self;
}

- (void)InitViews{
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.lineImageView];
    [self.whiteView addSubview:self.plusImageView];
    [self.whiteView addSubview:self.addPlaceLabel];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.whiteView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.plusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView.mas_left).offset(133.5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.whiteView.mas_top).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.addPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView.mas_left).offset(157.5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.whiteView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-157.5*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
}

- (UIView *)whiteView{
    if (_whiteView == nil) {
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

- (UIImageView *)plusImageView{
    if (_plusImageView == nil) {
        _plusImageView = [UIImageView new];
        _plusImageView.image = [UIImage imageNamed:@"me_resume_icon_add_to_information"];
    }
    return _plusImageView;
}

-(UILabel *)addPlaceLabel{
    if (_addPlaceLabel == nil) {
        _addPlaceLabel = [CommentMethod initLabelWithText:@"添加经营场所" textAlignment:NSTextAlignmentLeft font:14 TextColor:RedUIColorC1];
    }
    return _addPlaceLabel;
}




@end
