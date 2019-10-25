//
//  AttentionView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AttentionView.h"

@implementation AttentionView
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
    CGRect orginRect = CGRectMake(50*AUTO_SIZE_SCALE_X, kScreenHeight, kScreenWidth-100*AUTO_SIZE_SCALE_X, 341*AUTO_SIZE_SCALE_X);
    CGRect finaRect = orginRect;
    finaRect.origin.y =  168.5*AUTO_SIZE_SCALE_X;
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
    self.titleLabel.frame = CGRectMake(35.5*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, _shareBGView.width - 71*AUTO_SIZE_SCALE_X, (48)*AUTO_SIZE_SCALE_X);
    self.titleLabel.backgroundColor =[UIColor whiteColor];
    self.titleLabel.userInteractionEnabled = YES;
    self.titleLabel.text = @"为了更顺利的提交入驻信息请提前准备您的";
    self.titleLabel.textColor = FontUIColorBlack;
    self.titleLabel.font = XNFont(16*AUTO_SIZE_SCALE_X);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 2;
    [_shareBGView addSubview:self.titleLabel];
    
    self.headView = [UIImageView new];
    self.headView .frame = CGRectMake(115.5*AUTO_SIZE_SCALE_X, 98*AUTO_SIZE_SCALE_X, (44)*AUTO_SIZE_SCALE_X, (44)*AUTO_SIZE_SCALE_X);
    self.headView.image = [UIImage imageNamed:@"settled_icon_logo"];
     [_shareBGView addSubview:self.headView];

    self.headLabel = [[UILabel alloc] init];
    self.headLabel.frame = CGRectMake(0, 147*AUTO_SIZE_SCALE_X, _shareBGView.width, (21)*AUTO_SIZE_SCALE_X);
    self.headLabel .backgroundColor =[UIColor whiteColor];
    self.headLabel .userInteractionEnabled = YES;
    self.headLabel .text = @"个人头像";
    self.headLabel .textColor = FontUIColorBlack;
    self.headLabel .font = XNFont(15*AUTO_SIZE_SCALE_X);
    self.headLabel .textAlignment = NSTextAlignmentCenter;
    [_shareBGView addSubview:self.headLabel];
    
    self.projectView = [UIImageView new];
    self.projectView .frame = CGRectMake(115.5*AUTO_SIZE_SCALE_X, 196*AUTO_SIZE_SCALE_X, (44)*AUTO_SIZE_SCALE_X, (44)*AUTO_SIZE_SCALE_X);
    self.projectView.image = [UIImage imageNamed:@"settled_icon_head"];
    [_shareBGView addSubview:self.projectView];
    
    self.projectLabel = [[UILabel alloc] init];
    self.projectLabel.frame = CGRectMake(0, CGRectGetMaxY(self.projectView.frame)+5*AUTO_SIZE_SCALE_X, _shareBGView.width, (21)*AUTO_SIZE_SCALE_X);
    self.projectLabel.backgroundColor = [UIColor whiteColor];
    self.projectLabel.userInteractionEnabled = YES;
    self.projectLabel.text = @"项目LOGO";
    self.projectLabel.textColor = FontUIColorBlack;
    self.projectLabel.font = XNFont(15*AUTO_SIZE_SCALE_X);
    self.projectLabel.textAlignment = NSTextAlignmentCenter;
    [_shareBGView addSubview:self.projectLabel];
    
    self.lineImageView = [UIImageView new];
    self.lineImageView.frame = CGRectMake(0, 291*AUTO_SIZE_SCALE_X - 1, _shareBGView.width, (0.5)*AUTO_SIZE_SCALE_X);
    self.lineImageView.backgroundColor =lineImageColor;
    [_shareBGView addSubview:self.lineImageView];
    
    UILabel *cancelLabel = [[UILabel alloc] init];
    cancelLabel.frame = CGRectMake(0, _shareBGView.height-49.5*AUTO_SIZE_SCALE_X, _shareBGView.width, 49.5*AUTO_SIZE_SCALE_X);
    cancelLabel.backgroundColor =[UIColor whiteColor];
    cancelLabel.userInteractionEnabled = YES;
    cancelLabel.text = @"我知道了";
    cancelLabel.textColor = RedUIColorC1;
    cancelLabel.font = XNFont(16*AUTO_SIZE_SCALE_X);
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    _shareBGView.userInteractionEnabled = YES;
    [_shareBGView addSubview:cancelLabel];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNoe)];
    [cancelLabel addGestureRecognizer:tap2];
    
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




@end
