//
//  PersonalHeaderView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PersonalHeaderView.h"

@implementation PersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = BGColorGray;
        [self InitViews];
    }
    return self;
}
- (void)InitViews{
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.arrowImageView];
    [self.headerView addSubview:self.headerLabel];
    [self.headerView addSubview:self.headerImageView];
    
    [self addSubview:self.userNameView];
    [self.userNameView addSubview:self.userNameLabel];
    [self.userNameView addSubview:self.userNameTextField];
    [self addSubview:self.lineImageView];
    
    [self addSubview:self.introduceView];
    [self.introduceView addSubview:self.introduceLabel];
    [self.introduceView addSubview:self.introduceTextField];
    [self addSubview:self.lineImageView1];
    
    [self addSubview:self.locationView];
    [self.locationView addSubview:self.locationLabel];
    [self.locationView addSubview:self.locationdTextField];
    [self.locationView addSubview:self.locationdButton];
    
    
    [self addSubview:self.remarkBgView];
    [self.remarkBgView addSubview:self.remarksLabel];
    [self.remarkBgView addSubview:self.lastlineImageViewlast];
    [self.remarkBgView addSubview:self.remarksTextView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 85*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(35*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-34*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(55*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_top).offset(35.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(15)*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];

    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headerView.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.userNameView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userNameView.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.userNameView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - (15+15+50)*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.userNameView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];

    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.introduceView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];

    [self.introduceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.introduceView.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.introduceView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - (15+15+80+15)*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.introduceView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.lineImageView1.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.locationView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.locationdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.introduceView.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.locationView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - (15+15+80+15)*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.locationdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.locationView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.remarkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.locationView.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 224*AUTO_SIZE_SCALE_X));
    }];
    [self.remarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.remarkBgView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 49.5*AUTO_SIZE_SCALE_X));
    }];
    [self.lastlineImageViewlast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.remarksLabel.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    [self.remarksTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.lastlineImageViewlast.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 130*AUTO_SIZE_SCALE_X));
    }];
}



-(void)setWithViewMoel:(PersonalVIewModel *)viewModel WithSuperViewController:(UIViewController *)vc{
    self.superViewController = vc;
}


- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"list_icon_more"];
    }
    return _arrowImageView;
}

-(UILabel *)headerLabel{
    if (_headerLabel == nil) {
        _headerLabel = [CommentMethod initLabelWithText:@"头像" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _headerLabel;
}

- (UIImageView *)headerImageView{
    if (_headerImageView == nil) {
        _headerImageView = [UIImageView new];
        self.headerImageView.layer.cornerRadius = 55/2*AUTO_SIZE_SCALE_X;
        
        self.headerImageView.layer.masksToBounds = YES;

        self.headerImageView.backgroundColor = [UIColor clearColor];
               
    }
    return _headerImageView;
}


- (UIView *)userNameView{
    if (_userNameView == nil) {
        _userNameView = [UIView new];
        _userNameView.backgroundColor = [UIColor whiteColor];
    }
    return _userNameView;
}

-(UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        _userNameLabel = [CommentMethod initLabelWithText:@"姓名" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _userNameLabel;
}

- (UITextField *)userNameTextField{
    if (_userNameTextField == nil) {
        _userNameTextField = [[UITextField alloc] init];
        _userNameTextField.placeholder = @"请输入姓名";
        _userNameTextField.textAlignment = NSTextAlignmentRight;
        _userNameTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _userNameTextField.tintColor = RedUIColorC1;
        _userNameTextField.textColor = FontUIColorBlack;
    }
    return _userNameTextField;
}

- (UIView *)introduceView{
    if (_introduceView == nil) {
        _introduceView = [UIView new];
        _introduceView.backgroundColor = [UIColor whiteColor];
    }
    return _introduceView;
}

-(UILabel *)introduceLabel{
    if (_introduceLabel == nil) {
        _introduceLabel = [CommentMethod initLabelWithText:@"一句话介绍" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _introduceLabel;
}

- (UITextField *)introduceTextField{
    if (_introduceTextField == nil) {
        _introduceTextField = [[UITextField alloc] init];
        _introduceTextField.placeholder = @"请输入您的自我介绍";
        _introduceTextField.textAlignment = NSTextAlignmentRight;
        _introduceTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _introduceTextField.tintColor = RedUIColorC1;
        _introduceTextField.textColor = FontUIColorBlack;
    }
    return _introduceTextField;
}

- (UIView *)locationView{
    if (_locationView == nil) {
        _locationView = [UIView new];
        _locationView.backgroundColor = [UIColor whiteColor];
        _locationView.userInteractionEnabled = YES;
    }
    return _locationView;
}

-(UILabel *)locationLabel{
    if (_locationLabel == nil) {
        _locationLabel = [CommentMethod initLabelWithText:@"您的位置" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _locationLabel;
}

- (UITextField *)locationdTextField{
    if (_locationdTextField == nil) {
        _locationdTextField = [[UITextField alloc] init];
        _locationdTextField.placeholder = @"请选择您的位置";
        _locationdTextField.textAlignment = NSTextAlignmentRight;
        _locationdTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _locationdTextField.tintColor = RedUIColorC1;
        _locationdTextField.textColor = FontUIColorBlack;
        _locationdTextField.userInteractionEnabled = NO;
    }
    return _locationdTextField;
}


-(UIButton *)locationdButton{
    if (_locationdButton == nil) {
        _locationdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationdButton.backgroundColor = [UIColor clearColor];
        _locationdButton.userInteractionEnabled = YES;
        _locationdButton.enabled = YES;
    }
    return _locationdButton;
}


-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        _lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 51*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    }
    return _lineImageView;
}

-(UIView *)remarkBgView{
    if (_remarkBgView == nil) {
        _remarkBgView = [UIView new];
        _remarkBgView.backgroundColor = [UIColor whiteColor];
    }
    return _remarkBgView;
}

-(UILabel *)remarksLabel{
    if (_remarksLabel == nil) {
        _remarksLabel = [CommentMethod initLabelWithText:@"详细介绍（可选）" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
        _remarksLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth - 30*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
    }
    return _remarksLabel;
}

-(UITextView *)remarksTextView{
    if (_remarksTextView == nil) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _remarksTextView.layer.borderWidth = 0;
        _remarksTextView.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _remarksTextView.layer.borderColor = [UIColor clearColor].CGColor;
        _remarksTextView.zw_placeHolder = @"请详细介绍一下您的个人信息，例如当前从事的行业以及经验，或者您未来希望从事的行业或者项目，让与您直聊的用户可以更快的了解您；如果您是某个品牌的创建人，请填写您的成就或资源，让客户更快的了解您";
        _remarksTextView.zw_placeHolderColor = FontUIColor999999Gray;
        _remarksTextView.textColor = FontUIColorBlack;
        _remarksTextView.tintColor = RedUIColorC1;
        _remarksTextView.userInteractionEnabled = YES;
    }
    return _remarksTextView;
}

-(UIImageView *)lastlineImageViewlast{
    if (_lastlineImageViewlast == nil) {
        _lastlineImageViewlast = [UIImageView new];
        _lastlineImageViewlast.backgroundColor = lineImageColor;
    }
    return _lastlineImageViewlast;
}

-(UIImageView *)lineImageView1{
    if(_lineImageView1 == nil){
        _lineImageView1 = [UIImageView new];
        _lineImageView1.backgroundColor = lineImageColor;
        _lineImageView1.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 51*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    }
    return _lineImageView1;
}

@end
