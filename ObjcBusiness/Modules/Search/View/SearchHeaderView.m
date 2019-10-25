//
//  SearchHeaderView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/3.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SearchHeaderView.h"

@implementation SearchHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled =YES;
        self.searchImageView.userInteractionEnabled = YES;
        self.searchLabel.userInteractionEnabled = YES;
        [self addSubview:self.searchImageView];
        [self addSubview:self.searchLabel];
        [self addSubview:self.cancelButton];
        self.searchImageView.frame = CGRectMake(15, 11, 22, 22);
        self.searchLabel.frame = CGRectMake(CGRectGetMaxX(self.searchImageView.frame)+5*AUTO_SIZE_SCALE_X, 0, kScreenWidth-42*AUTO_SIZE_SCALE_X-60*AUTO_SIZE_SCALE_X, kNavHeight-kSystemBarHeight);
    }
    return self;
}

-(UILabel *)searchLabel{
    if (_searchLabel == nil) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.textColor = FontUIColorBlack;
        _searchLabel.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _searchLabel.backgroundColor = [UIColor clearColor];
        _searchLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _searchLabel;
}

-(UIImageView *)searchImageView{
    if (_searchImageView == nil) {
        _searchImageView = [UIImageView new];
        _searchImageView.image = [UIImage imageNamed:@"nav_btn_search_normal"];
    }
    return _searchImageView;
}

-(UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.frame = CGRectMake(kScreenWidth-45*AUTO_SIZE_SCALE_X, 0, 45*AUTO_SIZE_SCALE_X, self.frame.size.height);
        UILabel *cancelLabel = [[UILabel alloc] init];
        cancelLabel.textColor = FontUIColorBlack;
        cancelLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        cancelLabel.backgroundColor = [UIColor clearColor];
        cancelLabel.textAlignment = NSTextAlignmentLeft;
        cancelLabel.text = @"取消";
        cancelLabel.frame = CGRectMake(0, 0, 45*AUTO_SIZE_SCALE_X, self.frame.size.height);
        [_cancelButton addSubview:cancelLabel];
    }
    return _cancelButton;
}

-(void)setsearchContent:(NSString *)searchContent{
    self.searchLabel.text = searchContent;
}
@end
