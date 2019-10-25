//
//  ComingSuccedViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ComingSuccedViewController.h"

@interface ComingSuccedViewController ()
@property(nonatomic,strong)UIImageView *correctImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIButton *returnButton;
@end

@implementation ComingSuccedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交成功";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.correctImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.returnButton];
    
    
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
        make.size.mas_equalTo(CGSizeMake(325*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
    }];
}


- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.tabBarController.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        _titleLabel = [CommentMethod createLabelWithText:@"您成功提交了项目" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter Font:17];
    }
    return _titleLabel;
}

-(UILabel *)descLabel{
    if (_descLabel == nil) {
        _descLabel = [CommentMethod createLabelWithText:@"渠天下客服将会在一个工作日内为您审核" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter Font:14];
    }
    return _descLabel;
}

-(UIButton *)returnButton{
    if (_returnButton == nil) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_returnButton setTitle:@"返回直聊" forState:UIControlStateNormal];
        _returnButton.layer.cornerRadius = 8;
        _returnButton.layer.masksToBounds = YES;
        [_returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_returnButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_returnButton setBackgroundImage:[CommentMethod createImageWithColor: [UIColor colorWithRed:249/255.0 green:54/255.0 blue:48/255.0 alpha:0.5/1.0]] forState:UIControlStateDisabled];
        [_returnButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}


@end
