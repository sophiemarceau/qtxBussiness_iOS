//
//  ResumeView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ResumeView.h"

@implementation ResumeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = BGColorGray;
        self.frame = frame;
        [self initViews];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.redAttentionImageView];
    
    [self addSubview:self.resumeTitleLabel];
//    [self addSubview:self.resumeButton];
    [self.redAttentionImageView mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(13*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(18*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X));
    }];

    [self.resumeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
        make.left.equalTo(self.mas_left).offset(43*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-63*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
    }];

//    [self.resumeButton mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
//        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.mas_top).offset(8*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(76*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X));
//    }];

    
}

//-(UIButton *)resumeButton{
//    if (_resumeButton == nil) {
//        _resumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _resumeButton.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
//        [_resumeButton setTitle:@"立即完善" forState:UIControlStateNormal];
//        _resumeButton.layer.cornerRadius = 4;
//        _resumeButton.layer.masksToBounds = YES;
//        _resumeButton.layer.borderColor = RedUIColorC1.CGColor;
//        _resumeButton.layer.borderWidth = 1;
//        [_resumeButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
//        [_resumeButton setBackgroundImage:[CommentMethod createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//
//
//    }
//    return _resumeButton;
//}

-(UIImageView *)redAttentionImageView{
    if (_redAttentionImageView == nil) {
        _redAttentionImageView = [UIImageView new];
        _redAttentionImageView.image = [UIImage imageNamed:@"me_icon_notice"];
    }
    return _redAttentionImageView;
}

-(UILabel *)resumeTitleLabel{
    if (_resumeTitleLabel == nil) {
        _resumeTitleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorBlack];
        NSString *jobStr = @"完善详细信息";
        NSString *jobString = [NSString stringWithFormat:@"想让其他用户可以更快的了解您？去%@",jobStr];
        NSMutableAttributedString *mutablestr1 = [[NSMutableAttributedString alloc] initWithString:jobString];
        [mutablestr1 addAttribute:NSForegroundColorAttributeName value:FontUIColorBlack range:NSMakeRange(0,jobString.length - jobStr.length)];
        [mutablestr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,jobString.length - jobStr.length)];
        [mutablestr1 addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(jobString.length - jobStr.length,[jobStr length])];
        [mutablestr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(jobString.length - jobStr.length,[jobStr length])];
        _resumeTitleLabel.attributedText = mutablestr1;
        
        
        
        
    }
    return _resumeTitleLabel;
}
@end
