//
//  AccountBindingViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/6.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AccountBindingViewController.h"
#import "SelectTagViewController.h"
@interface AccountBindingViewController ()<UITextFieldDelegate>{
    NSInteger i;
}
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UILabel *timeLabel;//60秒后重发
@end

@implementation AccountBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     i = 60;
    self.title = @"账号绑定";
    [self initSubViews];
}

-(void)initSubViews{
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.phoneLineView];
    [self.view addSubview:self.sendMessageButton];
    [self.view addSubview:self.bindButton];
    [self.view addSubview:self.passwordLineView];
    [self.view addSubview:self.AccordingLabel];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-35*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.view.mas_top).offset(kNavHeight + (82-51.5)*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake( kScreenWidth - 70*AUTO_SIZE_SCALE_X, 51.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(-1*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-50*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(140*AUTO_SIZE_SCALE_X, 51.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(-1*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-50*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.passwordLineView.mas_bottom).offset(-8.75*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X));
    }];
    
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.passwordLineView.mas_bottom).offset(30*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 50*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
    }];
    
    [self.AccordingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bindButton.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 12*AUTO_SIZE_SCALE_X));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)sendMessageButtonOnClick:(UIButton *)sender{
    NSDictionary *dic = @{@"tel":self.phoneTextField.text,};
    [[RequestManager shareRequestManager] GetVerifyCodeResult:dic viewController:self successData:^(NSDictionary *result) {
        if(IsSucess(result) == 1){
            [self.sendMessageButton removeFromSuperview];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runClock) userInfo:nil repeats:YES];
            [self.timer fire];
        }else{}
    } failuer:^(NSError *error) {
        
    }];
}

-(void)bindButtonOnClick:(UIButton *)sender{
    sender.enabled = NO;
    NSDictionary *dic = @{
                          @"tel":self.phoneTextField.text,
                          @"verification_code":self.passwordTextField.text
                          };
    [[RequestManager shareRequestManager] bindTel:dic viewController:nil successData:^(NSDictionary *result) {
        sender.enabled = YES;
        [self.view endEditing:YES];
        if(IsSucess(result) == 1){
            [self WhetherGotoTagView];
        }else{
             [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    } failuer:^(NSError *error) {
        sender.enabled = YES;
         [self.view endEditing:YES];
    }];
}


-(void)WhetherGotoTagView{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] getChooseTagsFlag:dic viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            NSInteger WhetherGoTagViewFlag = [[[result objectForKey:@"data"] objectForKey:@"result"] integerValue];
            if (WhetherGoTagViewFlag == 0) {
                SelectTagViewController *vc = [[SelectTagViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:NULL];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_LOGINSELECT object:nil userInfo:nil
                 ];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
    }];
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return YES;
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [MobClick beginLogPageView:kAccountBindPage];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAccountBindPage];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

-(void)fieldChanged:(id)sender
{
    UITextField  *textField =  (UITextField*)sender;
    if (textField.tag==1001) {
        NSString * temp = textField.text;
        if (textField.markedTextRange ==nil){
            while(1){
                if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 11) {
                    break;
                }else{
                    temp = [temp substringToIndex:temp.length-1];
                }
            }
            textField.text=temp;
        }
    }
    if (self.phoneTextField.text.length == 11){
        self.sendMessageButton.enabled = YES;
    }else{
        self.sendMessageButton.enabled = NO;
    }
    if (self.phoneTextField.text.length == 11 && self.passwordTextField.text.length == 4) {
        self.bindButton.enabled = YES;
    }else{
        self.bindButton.enabled = NO;
    }
}


-(void)runClock
{
    self.timeLabel.text = [NSString stringWithFormat:@"%ld秒后重发",i];
    [self.view addSubview:self.timeLabel];
    //约束
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
        make.right.equalTo(self.view.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.passwordLineView.mas_bottom).offset(-8.75*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X));
    }];
    i--;
    if (i<0) {
        [self.timer invalidate];
        [self.timeLabel removeFromSuperview];
        [self.view addSubview:self.sendMessageButton];
        //约束
        [self.sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
            make.bottom.equalTo(self.passwordLineView.mas_bottom).offset(-8.75*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X));
        }];
        i=60;
    }
}
-(void)goBack{
    [super goBack];
//    NSLog(@"goback accoutbind");
    [self removeDefaultData];
}
- (void)removeDefaultData{
    //    [DEFAULTS removeObjectForKey:@"rongyuntoken"];
    [DEFAULTS removeObjectForKey:@"userId"];
    [DEFAULTS removeObjectForKey:@"qtxsy_auth"];
    [DEFAULTS removeObjectForKey:@"userPortraitUri"];
    [DEFAULTS removeObjectForKey:@"userNickName"];
    [DEFAULTS removeObjectForKey:@"userKind"];
    [DEFAULTS removeObjectForKey:@"c_profiles"];
    [DEFAULTS removeObjectForKey:@"userTelphone"];
    [DEFAULTS removeObjectForKey:@"user_id_str"];
    
    [DEFAULTS synchronize];
}

-(UITextField *)phoneTextField{
    if (_phoneTextField == nil) {
        _phoneTextField = [UITextField new];
        self.phoneTextField.placeholder = @"请输入手机号";
        self.phoneTextField.delegate = self;
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTextField.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.phoneTextField.tag =1001;
        self.phoneTextField.tintColor = RedUIColorC1;
        [self.phoneTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        self.phoneTextField.backgroundColor = [UIColor clearColor];
    }
    return _phoneTextField;
}

-(UITextField *)passwordTextField{
    if (_passwordTextField == nil) {
        _passwordTextField = [UITextField new];
        _passwordTextField.placeholder = @"请输入验证码";
        _passwordTextField.delegate = self;
        _passwordTextField.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.tintColor = RedUIColorC1;
        [_passwordTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}

-(UIImageView *)phoneLineView{
    if (_phoneLineView == nil) {
        _phoneLineView = [UIImageView new];
        _phoneLineView.backgroundColor =lineImageColor;
    }
    return _phoneLineView;
}

-(UIImageView *)passwordLineView{
    if (_passwordLineView == nil) {
        _passwordLineView = [UIImageView new];
        _passwordLineView.backgroundColor =lineImageColor;
    }
    return _passwordLineView;
}

-(UIButton *)sendMessageButton{
    if (_sendMessageButton == nil) {
        _sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendMessageButton.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [_sendMessageButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendMessageButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_sendMessageButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
        _sendMessageButton.layer.cornerRadius = 18;
        _sendMessageButton.layer.masksToBounds = YES;
        [_sendMessageButton addTarget:self action:@selector(sendMessageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendMessageButton.enabled = NO;
    }
    return _sendMessageButton;
}

-(UILabel *)AccordingLabel{
    if (_AccordingLabel == nil) {
        _AccordingLabel = [CommentMethod initLabelWithText:@"根据相关法律规定，用户注册网站需要进行手机号绑定" textAlignment:NSTextAlignmentCenter font:12 TextColor:FontUIColorGray];
    }
    return _AccordingLabel;
}

-(UIButton *)bindButton{
    if (_bindButton == nil) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bindButton.titleLabel.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        [_bindButton setTitle:@"确定绑定" forState:UIControlStateNormal];
        _bindButton.layer.cornerRadius = 8;
        _bindButton.layer.masksToBounds = YES;
        [_bindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bindButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_bindButton setBackgroundImage:[CommentMethod createImageWithColor: [UIColor colorWithRed:249/255.0 green:54/255.0 blue:48/255.0 alpha:0.5/1.0]] forState:UIControlStateDisabled];
        [_bindButton addTarget:self action:@selector(bindButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _bindButton.enabled = NO;
    }
    return _bindButton;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = FontUIColorBlack;
        self.timeLabel.backgroundColor = UIColorFromRGB(0xdddddd);
        self.timeLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.cornerRadius = 18*AUTO_SIZE_SCALE_X;
    }
    return _timeLabel;
}
@end
