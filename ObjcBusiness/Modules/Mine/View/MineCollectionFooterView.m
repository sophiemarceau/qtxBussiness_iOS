//
//  MineCollectionFooterView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MineCollectionFooterView.h"

@implementation MineCollectionFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = BGColorGray;
        self.frame = CGRectMake(0, 0, kScreenWidth, (70)*AUTO_SIZE_SCALE_X);
        
        [self initViews];
    }
    return self;
}

- (void)initViews{
    [self addSubview:self.customServiceView];
    [self.customServiceView addSubview:self.iconImageView];
    [self.customServiceView addSubview:self.functionNamelabel];
}

-(UIView *)customServiceView{
    if (_customServiceView == nil) {
        _customServiceView = [UIView new];
        _customServiceView.backgroundColor= [UIColor whiteColor];
        _customServiceView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X, kScreenWidth, 60*AUTO_SIZE_SCALE_X);
    }
    return _customServiceView;
}

- (UILabel *)functionNamelabel {
    if (_functionNamelabel == nil) {
        _functionNamelabel = [CommentMethod initLabelWithText:@"客服电话" textAlignment:NSTextAlignmentLeft font:13 TextColor:FontUIColorBlack];
        _functionNamelabel.frame = CGRectMake(56*AUTO_SIZE_SCALE_X,21*AUTO_SIZE_SCALE_X ,self.frame.size.width-56*AUTO_SIZE_SCALE_X, 18.5*AUTO_SIZE_SCALE_X);
        _functionNamelabel.font = [UIFont boldSystemFontOfSize:13*AUTO_SIZE_SCALE_X];
    }
    return _functionNamelabel;
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((25*AUTO_SIZE_SCALE_X), 18.5*AUTO_SIZE_SCALE_X,22*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X)];
        _iconImageView.image = [UIImage imageNamed:@"me_icon_customer_service-1"];
        
    }
    return _iconImageView;
}
@end
