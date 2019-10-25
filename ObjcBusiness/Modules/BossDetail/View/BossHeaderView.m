//
//  BossHeaderView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/14.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossHeaderView.h"

@implementation BossHeaderView
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
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.expertFlagImageView];
    [self addSubview:self.enterpriseFlagImageView];
    
    [self addSubview:self.companyAndJobLabel];
    [self addSubview:self.introduceLabel];
    [self addSubview:self.locationImageView];
    [self addSubview:self.locationImageView];
    [self addSubview:self.locationLabel];
    [self addSubview:self.tradeImageView];
    [self addSubview:self.tradeLabel];
    [self addSubview:self.expertLabel];
    [self addSubview:self.jobLabel];
}

-(UIImageView *)headImageView{
    if(_headImageView == nil){
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 100/2*AUTO_SIZE_SCALE_X;
        _headImageView.layer.borderWidth= 0;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X);
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:20 TextColor:FontUIColorBlack];
        _nameLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 85*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
        
    }
    return _nameLabel;
}

- (UIImageView *)expertFlagImageView {
    if (_expertFlagImageView == nil) {
        _expertFlagImageView = [UIImageView new];
        _expertFlagImageView.image =[UIImage imageNamed:@"boss_details_icon_expert_certification"];
        _expertFlagImageView.hidden = YES;
        _expertFlagImageView.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+8*AUTO_SIZE_SCALE_X, 19*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _expertFlagImageView;
}

- (UIImageView *)enterpriseFlagImageView {
    if (_enterpriseFlagImageView == nil) {
        _enterpriseFlagImageView = [UIImageView new];
        _enterpriseFlagImageView.image =[UIImage imageNamed:@"boss_details_icon_enterprise_certification"];
        _enterpriseFlagImageView.hidden = YES;
        _enterpriseFlagImageView.frame = CGRectMake(CGRectGetMaxX(_expertFlagImageView.frame)+8*AUTO_SIZE_SCALE_X, 19*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _enterpriseFlagImageView;
}



- (UILabel *)companyAndJobLabel {
    if (_companyAndJobLabel == nil) {
        _companyAndJobLabel = [[UILabel alloc]init];
        _companyAndJobLabel.backgroundColor = [UIColor clearColor];
        _companyAndJobLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _companyAndJobLabel.textAlignment = NSTextAlignmentLeft;
        _companyAndJobLabel.numberOfLines = 0;
        _companyAndJobLabel.textColor = FontUIColorBlack;
        _companyAndJobLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_nameLabel.frame)+4*AUTO_SIZE_SCALE_X, kScreenWidth-125*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _companyAndJobLabel;
}

-(UILabel *)introduceLabel{
    if (_introduceLabel == nil) {
        _introduceLabel = [[UILabel alloc]init];
        _introduceLabel.textColor = FontUIColor757575Gray;
        _introduceLabel.textAlignment = NSTextAlignmentLeft;
        _introduceLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _introduceLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_companyAndJobLabel.frame)+5*AUTO_SIZE_SCALE_X, kScreenWidth-125*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
    }
    return _introduceLabel;
}

-(UIImageView *)locationImageView{
    if (_locationImageView == nil) {
        _locationImageView = [UIImageView new];
        _locationImageView.image = [UIImage imageNamed:@"boss_icon_label_position"];
        _locationImageView.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_introduceLabel.frame)+6.5*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _locationLabel.textColor = FontUIColor757575Gray;
    }
    return _locationLabel;
}

-(UIImageView *)tradeImageView{
    if (_tradeImageView == nil) {
        _tradeImageView = [UIImageView new];
        _tradeImageView.image = [UIImage imageNamed:@"boss_icon_label_industry"];
    }
    return _tradeImageView;
}

- (UILabel *)tradeLabel {
    if (_tradeLabel == nil) {
        _tradeLabel = [[UILabel alloc]init];
        _tradeLabel.backgroundColor = [UIColor clearColor];
        _tradeLabel.textAlignment = NSTextAlignmentLeft;
        _tradeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _tradeLabel.textColor = FontUIColor757575Gray;
    }
    return _tradeLabel;
}

-(UILabel *)expertLabel{
    if (_expertLabel == nil) {
        _expertLabel = [[UILabel alloc]init];
        _expertLabel.textColor = FontUIColorBlack;
        _expertLabel.textAlignment = NSTextAlignmentLeft;
        _expertLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    }
    return _expertLabel;
}

-(UILabel *)jobLabel{
    if (_jobLabel == nil) {
        _jobLabel = [[UILabel alloc]init];
        _jobLabel.textColor = FontUIColorBlack;
        _jobLabel.textAlignment = NSTextAlignmentLeft;
        _jobLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    }
    return _jobLabel;
}

@end
