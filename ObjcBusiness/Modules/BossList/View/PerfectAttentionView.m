//
//  PerfectAttentionView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PerfectAttentionView.h"

@implementation PerfectAttentionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled  = YES;
        self.backgroundColor = [XNColor(0, 0, 0, 1) colorWithAlphaComponent:0.5];
        self.userInteractionEnabled = YES;
        [self initShareUI];
    }
    return self;
}

/**
 *  初始化视图
 */
- (void)initShareUI{
    CGRect orginRect = CGRectMake(50*AUTO_SIZE_SCALE_X, kScreenHeight, kScreenWidth-100*AUTO_SIZE_SCALE_X, 283*AUTO_SIZE_SCALE_X);
    CGRect finaRect = orginRect;
    finaRect.origin.y =  192*AUTO_SIZE_SCALE_X;
    /***************************** 添加底层self ********************************************/
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)];
    [self addGestureRecognizer:tap1];
    
    _shareBGView = [[UIView alloc] init];
    _shareBGView.frame = orginRect;
    _shareBGView.userInteractionEnabled = YES;
    _shareBGView.layer.masksToBounds = YES;
    _shareBGView.layer.cornerRadius = 5.0f;
    _shareBGView.backgroundColor =  [UIColor whiteColor];
    [self addSubview:_shareBGView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(18.5*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, _shareBGView.width - 37*AUTO_SIZE_SCALE_X, (48)*AUTO_SIZE_SCALE_X);
    self.titleLabel.backgroundColor =[UIColor whiteColor];
    self.titleLabel.userInteractionEnabled = YES;
    self.titleLabel.text = @"想让其他用户可以更快的了解您去完善我的详细介绍";
    self.titleLabel.textColor = FontUIColorBlack;
    self.titleLabel.font = XNFont(16*AUTO_SIZE_SCALE_X);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 2;
    [_shareBGView addSubview:self.titleLabel];
    
//    self.headView = [UIImageView new];
//    self.headView .frame = CGRectMake(115.5*AUTO_SIZE_SCALE_X, 98*AUTO_SIZE_SCALE_X, (44)*AUTO_SIZE_SCALE_X, (44)*AUTO_SIZE_SCALE_X);
//    self.headView.image = [UIImage imageNamed:@"settled_icon_logo"];
//    [_shareBGView addSubview:self.headView];
//
//
//
    self.headView = [UIImageView new];
    self.headView .frame = CGRectMake(87.5*AUTO_SIZE_SCALE_X, 98*AUTO_SIZE_SCALE_X, (100)*AUTO_SIZE_SCALE_X, (100)*AUTO_SIZE_SCALE_X);
    self.headView.image = [UIImage imageNamed:@"boss_icon_prompt"];
    [_shareBGView addSubview:self.headView];
    
   
    
    self.horizontalLineImageView = [UIImageView new];
    self.horizontalLineImageView.frame = CGRectMake(0, 233*AUTO_SIZE_SCALE_X - 1, _shareBGView.width, (0.5)*AUTO_SIZE_SCALE_X);
    self.horizontalLineImageView.backgroundColor =lineImageColor;
    [_shareBGView addSubview:self.horizontalLineImageView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
    UIColor *titleColor = FontUIColorBlack;
    [self.cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[titleColor colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(tapNoe) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.frame = CGRectMake(0, _shareBGView.frame.size.height -50*AUTO_SIZE_SCALE_X,  _shareBGView.frame.size.width/2, 50*AUTO_SIZE_SCALE_X);
    [_shareBGView addSubview:self.cancelButton];
    
    self.gotoPersonalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gotoPersonalButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
    UIColor *titleColor1 = RedUIColorC1;
    [self.gotoPersonalButton setTitleColor:titleColor1 forState:UIControlStateNormal];
    [self.gotoPersonalButton setTitleColor:[titleColor1 colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [self.gotoPersonalButton setTitle:@"去完善" forState:UIControlStateNormal];
    [self.gotoPersonalButton addTarget:self action:@selector(gotoPersonalButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.gotoPersonalButton.frame = CGRectMake(_shareBGView.frame.size.width/2, _shareBGView.frame.size.height -50*AUTO_SIZE_SCALE_X,  _shareBGView.frame.size.width/2, 50*AUTO_SIZE_SCALE_X);
    [_shareBGView addSubview:self.gotoPersonalButton];
    
    self.horizontalLineImageView = [UIImageView new];
    self.horizontalLineImageView.frame = CGRectMake(_shareBGView.frame.size.width/2, _shareBGView.frame.size.height -50*AUTO_SIZE_SCALE_X, (0.5)*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.horizontalLineImageView.backgroundColor =lineImageColor;
    [_shareBGView addSubview:self.horizontalLineImageView];
    
    /****************************** 动画 ********************************************/
    _shareBGView.alpha = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                         _shareBGView.frame = finaRect;
                         _shareBGView.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)dismissShareView{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0;
                         CGRect blackFrame = [self frame];
                         blackFrame.origin.y = XNWindowHeight;
                         self.frame = blackFrame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)tapNoe{
    [self dismissShareView];
}

- (void)gotoPersonalButtonOnClick:(UIButton *)sender{
    [self tapNoe];
    [self.delegate BackPersonViewDelegateReturnPage];
    
}

@end
