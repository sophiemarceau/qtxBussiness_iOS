//
//  MineCollectionViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MineCollectionViewCell.h"

@implementation MineCollectionViewCell
//创建自定义cell时调用该方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.functionNamelabel];
    }
    return self;
}

- (UILabel *)functionNamelabel {
    if (_functionNamelabel == nil) {
        _functionNamelabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:13 TextColor:FontUIColorBlack];
        _functionNamelabel.frame = CGRectMake(56*AUTO_SIZE_SCALE_X,26*AUTO_SIZE_SCALE_X ,self.frame.size.width-56*AUTO_SIZE_SCALE_X, 18.5*AUTO_SIZE_SCALE_X);
        _functionNamelabel.font = [UIFont boldSystemFontOfSize:13*AUTO_SIZE_SCALE_X];
    }
    return _functionNamelabel;
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((25*AUTO_SIZE_SCALE_X), 24*AUTO_SIZE_SCALE_X,22*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X)];
        
    }
    return _iconImageView;
}
@end
