//
//  noContent.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/11/7.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "noContent.h"

@implementation noContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}
- (void)initView {
    [self addSubview:self.noImageView];
    [self addSubview:self.noContentLabel];
    
    
    //约束
    [self.noImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(100*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 116*AUTO_SIZE_SCALE_X));
    }];
    
    [self.noContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.mas_right).offset(-10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.noImageView.mas_bottom).offset(25*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(17*AUTO_SIZE_SCALE_X);
    }];
  }

#pragma mark - 懒加载
- (UIImageView *)noImageView {
    if (_noImageView == nil) {
        self.noImageView = [UIImageView new];
        [self.noImageView setImage:[UIImage imageNamed:@"icon_no_content"]];
        self.noImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noImageView;
}
- (UILabel *)noContentLabel {
    if (_noContentLabel == nil) {
        self.noContentLabel = [CommentMethod initLabelWithText:@"这里什么都没有哦" textAlignment:NSTextAlignmentCenter font:17
                                                     TextColor:FontUIColor999999Gray];
        
    }
    return _noContentLabel;
}

@end
