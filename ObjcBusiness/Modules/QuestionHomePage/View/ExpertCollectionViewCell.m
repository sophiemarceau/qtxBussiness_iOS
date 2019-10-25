//
//  ExpertCollectionViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ExpertCollectionViewCell.h"

@implementation ExpertCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor  = BGColorGray.CGColor;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headview];
        [self.contentView addSubview:self.headerFlagImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.btn];
    }
    return self;
}

-(UIImageView *)headview{
    if (_headview == nil) {
        _headview = [UIImageView new];
        _headview.layer.cornerRadius = 30*AUTO_SIZE_SCALE_X;
        _headview.layer.masksToBounds = YES;
        _headview.layer.borderWidth = 0;
        _headview.frame = CGRectMake(50*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X);
        _headview.backgroundColor =  [UIColor clearColor];
    }
    return _headview;
}

-(UIImageView *)headerFlagImageView{
    if (_headerFlagImageView == nil) {
        _headerFlagImageView = [UIImageView new];
        _headerFlagImageView.backgroundColor = [UIColor clearColor];
        _headerFlagImageView.frame = CGRectMake(92*AUTO_SIZE_SCALE_X, 57*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X);
        
    }
    return _headerFlagImageView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15*AUTO_SIZE_SCALE_X];
        _nameLabel.textColor = FontUIColorBlack;
        _nameLabel.frame = CGRectMake(0, 85*AUTO_SIZE_SCALE_X, self.frame.size.width, 15*AUTO_SIZE_SCALE_X);
    }
    return _nameLabel;
}

-(UILabel *)desLabel{
    if (_desLabel== nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _desLabel.textColor = FontUIColor999999Gray;
        _desLabel.numberOfLines = 2;
        _desLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 105*AUTO_SIZE_SCALE_X, self.frame.size.width-30*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X);
    }
    return _desLabel;
}

-(UIButton *)btn{
    if (_btn == nil) {
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 160*AUTO_SIZE_SCALE_X, self.frame.size.width-30*AUTO_SIZE_SCALE_X  , 28*AUTO_SIZE_SCALE_X)];
        _btn.titleLabel.font = [UIFont boldSystemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_btn setTitle:@"关注"  forState:(UIControlStateNormal)];
        [_btn setBackgroundImage:[CommentMethod createImageWithColor:RedUIColorC1] forState:UIControlStateNormal];
        [_btn setTitle:@"互相关注"  forState:(UIControlStateSelected)];
        [_btn setTitleColor:FontUIColor999999Gray forState:(UIControlStateSelected)];
        [_btn setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xdddddd)] forState:UIControlStateSelected];
        
        _btn.layer.cornerRadius = 4;
        _btn.layer.masksToBounds = YES;
    }
    return _btn;
}
@end
