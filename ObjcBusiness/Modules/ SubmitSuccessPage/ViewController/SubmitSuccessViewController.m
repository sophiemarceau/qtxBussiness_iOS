//
//  SubmitSuccessViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/22.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SubmitSuccessViewController.h"

@interface SubmitSuccessViewController ()
@property(nonatomic,strong)UIImageView *correctImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIButton *returnButton;
@property(nonatomic,strong)UIButton *finishPersonalInfoButton;
@end

@implementation SubmitSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交成功";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.correctImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.finishPersonalInfoButton];
    
    
    [self.correctImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(157.5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.view.mas_top).offset(139*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.view.mas_top).offset(224*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.view.mas_top).offset(266*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X));
    }];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(155*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
    }];
    
    [self.finishPersonalInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(155*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return YES;
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (void)goBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)OnClick:(UIButton *)sender{
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kLeaveMessageSubmitSuccessPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:kLeaveMessageSubmitSuccessPage];
}

-(UIImageView *)correctImageView{
    if (_correctImageView == nil) {
        _correctImageView = [UIImageView new];
        _correctImageView.image = [UIImage imageNamed:@"form_icon_complete"];
    }
    return _correctImageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [CommentMethod createLabelWithText:@"您成功提交了项目留言" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter Font:17];
    }
    return _titleLabel;
}

-(UILabel *)descLabel{
    if (_descLabel == nil) {
        _descLabel = [CommentMethod createLabelWithText:@"请保持电话通畅，项目方将会尽快与您联系，同时为了给您推荐更加精准的好生意，您可以去完善个人资料" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:14];
    }
    return _descLabel;
}

-(UIButton *)returnButton{
    if (_returnButton == nil) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_returnButton setTitle:@"返回项目列表" forState:UIControlStateNormal];
        _returnButton.layer.cornerRadius = 8;
        _returnButton.layer.masksToBounds = YES;
        [_returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_returnButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_returnButton setBackgroundImage:[CommentMethod createImageWithColor: [UIColor colorWithRed:249/255.0 green:54/255.0 blue:48/255.0 alpha:0.5/1.0]] forState:UIControlStateDisabled];
        [_returnButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _returnButton;
}

-(UIButton *)finishPersonalInfoButton{
    if (_finishPersonalInfoButton == nil) {
        _finishPersonalInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishPersonalInfoButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_finishPersonalInfoButton setTitle:@"完善个人信息" forState:UIControlStateNormal];
        _finishPersonalInfoButton.layer.cornerRadius = 8;
        _finishPersonalInfoButton.layer.masksToBounds = YES;
        _finishPersonalInfoButton.layer.borderWidth =1;
        _finishPersonalInfoButton.layer.borderColor = UIColorFromRGB(0xF93630).CGColor;
        [_finishPersonalInfoButton setTitleColor:UIColorFromRGB(0xF93630) forState:UIControlStateNormal];
        [_finishPersonalInfoButton setBackgroundImage:[CommentMethod createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_finishPersonalInfoButton setBackgroundImage:[CommentMethod createImageWithColor: [UIColor colorWithRed:249/255.0 green:54/255.0 blue:48/255.0 alpha:0.5/1.0]] forState:UIControlStateDisabled];
        [_finishPersonalInfoButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishPersonalInfoButton;
}

@end
