//
//  BottomButtonView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BottomButtonView.h"

@implementation BottomButtonView

-(instancetype)initWithFrame:(CGRect)frame target:(id)target
                      action:(SEL)action Title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.bottomPostButton];
    }
    return self;
}

-(UIButton *)bottomPostButton{
    if (_bottomPostButton == nil) {
        _bottomPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_bottomPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomPostButton setBackgroundColor:RedUIColorC1];
        _bottomPostButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        _bottomPostButton.layer.cornerRadius = 4;
        _bottomPostButton.layer.masksToBounds = YES;
        [_bottomPostButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        
        _bottomPostButton.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, self.frame.size.height-16*AUTO_SIZE_SCALE_X);
    }
    return _bottomPostButton;
}
@end
