//
//  LoginView.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "LoginView.h"
#import "LoginViewModel.h"
//#import <RongIMKit/RongIMKit.h>
#import "WebViewController.h"
#import "LoginModel.h"
#import "DBHelper.h"
#import "MessageCodeModel.h"
#import "RongYunModel.h"
#import "UserInfoModel.h"
#import "AccountBindingViewController.h"
#import "SelectTagViewController.h"
#import "JPUSHService.h"
#import <UMSocialCore/UMSocialCore.h>
typedef NS_ENUM(NSUInteger, LoginButtonType) {
    LoginButtonTag,
    SendMessageButtonTag,
    QQButttonTag,
    WeChatButtonTag,
};

@interface LoginView ()<RCIMConnectionStatusDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    NSInteger i;
}

@property(nonatomic,strong)LoginViewModel *loginViewModel;
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UITextField *phoneTextField,*passwordTextField;
@property(nonatomic,strong)UIButton *sendMessageButton,*loginButton,*weixinButton,*QQButton;
@property(nonatomic,strong)UILabel *loginAgreementLabel;
@property(nonatomic,strong)UILabel *AgreementtitleLabel;
@property(nonatomic,strong)UILabel *socialDescriptionLabel;
@property(nonatomic,strong)UIImageView *lineImageView1,*lineImageView2,*phoneLineView,*passwordLineView;
@property(nonatomic,strong)UIViewController *superViewController;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UILabel *timeLabel;//60秒后重发
@property(nonatomic) int loginFailureTimes;

@property(nonatomic, strong) NSString *loginUserId;
@property(nonatomic, strong) NSString *qtxsy_auth;
@property(nonatomic, strong) NSString *loginToken;
@property(nonatomic, strong) NSString *userKind;
@property(nonatomic, strong) NSString *user_id_str;
@end


@implementation LoginView

- (instancetype)init{
    self = [super init];
    if (self) {
        i = 60;
        _loginFailureTimes = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = [UIScreen mainScreen].bounds;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    
    [self addSubview:self.logoImageView];
    [self addSubview:self.phoneTextField];
    [self addSubview:self.phoneLineView];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.passwordLineView];
    [self addSubview:self.sendMessageButton];
    [self addSubview:self.loginButton];
    [self addSubview:self.loginAgreementLabel];
    [self addSubview:self.AgreementtitleLabel];
    [self addSubview:self.socialDescriptionLabel];
    [self addSubview:self.weixinButton];
//    [self addSubview:self.QQButton];
    
//    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(125*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.mas_top).offset(84*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(124.8*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X));
//    }];
    self.logoImageView.frame = UIRect(125, 84, 124, 45);
    
    
//    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(35*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.mas_top).offset(174*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-35*AUTO_SIZE_SCALE_X*2, 17*AUTO_SIZE_SCALE_X));
//    }];
    self.phoneTextField.frame = UIRect(35, 174, 414-70, 17);
    
//    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.mas_top).offset(211*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-25*AUTO_SIZE_SCALE_X*2, 0.5));
//    }];
    self.phoneLineView.frame = CGRectMake(UI(25), UI(211), UI(414-50), 0.5);
    
//    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(35*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.phoneLineView.mas_bottom).offset(35.5*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X));
//    }];
    self.passwordTextField.frame = UIRect(35, 212+35, 200, 17);
    
//    [self.sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.phoneLineView.mas_bottom).offset(27*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X));
//    }];
    self.sendMessageButton.frame = UIRect(414-125, 212+27, 100, 34);
    
//    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.passwordTextField.mas_bottom).offset(20.5*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-25*AUTO_SIZE_SCALE_X*2, 0.5));
//    }];
    self.passwordLineView.frame = CGRectMake(UI(25), UI(212+73), UI(414-50), 0.5);
    
//    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.passwordLineView.mas_bottom).offset(30*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-25*AUTO_SIZE_SCALE_X*2, 44*AUTO_SIZE_SCALE_X));
//    }];
    self.loginButton.frame = UIRect(25, 286+30, 414-50, 44);
    
//    [self.loginAgreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.loginButton.mas_bottom).offset(20*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-25*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
//    }];
    self.loginAgreementLabel.frame = UIRect(25, 286+74+20, 414/2-25, 12);
//    [self.AgreementtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.loginButton.mas_bottom).offset(20*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-25*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
//    }];
    self.AgreementtitleLabel.frame = CGRectMake(kScreenWidth-UI(25)-UI(414/2-25), UI(286+74+20), UI(414/2-25), UI(12));
    
//    [self.socialDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(25*AUTO_SIZE_SCALE_X);
//        make.bottom.equalTo(self.mas_bottom).offset(-99*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-25*AUTO_SIZE_SCALE_X*2, 14*AUTO_SIZE_SCALE_X));
//    }];
    self.socialDescriptionLabel.frame = CGRectMake(UI(25), kScreenHeight - UI(99+14) , UI(414-50), UI(14));


//    [self.weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self.mas_left).offset(72*AUTO_SIZE_SCALE_X);
//        make.centerX.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom).offset(-40*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(44*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
//    }];
    self.weixinButton.frame = CGRectMake(UI((414-44)/2), kScreenHeight - UI(84), UI(44), UI(44));

//    [self.QQButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-72*AUTO_SIZE_SCALE_X);
//        make.bottom.equalTo(self.mas_bottom).offset(-40*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(44*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
//    }];
}

-(void)runClock{
    self.timeLabel.text = [NSString stringWithFormat:@"%ld秒后重发",i];
    [self addSubview:self.timeLabel];
    //约束
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
//        make.right.equalTo(self.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.phoneLineView.mas_bottom).offset(27*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X));
//    }];
    self.timeLabel.frame = UIRect(414-125, 212+27, 100, 34);
    i--;
    if (i<0) {
        [self.timer invalidate];
        [self.timeLabel removeFromSuperview];
        [self addSubview:self.sendMessageButton];
        //约束
//        [self.sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-25*AUTO_SIZE_SCALE_X);
//            make.top.equalTo(self.phoneLineView.mas_bottom).offset(27*AUTO_SIZE_SCALE_X);
//            make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X));
//        }];
        self.sendMessageButton.frame = UIRect(414-125, 212+27, 100, 34);
        i=60;
    }
}

-(void)setWithViewMoel:(LoginViewModel *)viewModel WithSuperViewController:(UIViewController *)vc{
    self.loginViewModel = viewModel;
    self.superViewController = vc;
    [self.loginViewModel setBlockWithReturnBlock:^(id returnValue, ResopnseFlagState returnFlag,NSString *singalString) {

        
    } WithErrorBlock:^(id errorCode,NSString *errorSignalString) {
        
    }];
}

//-(void)GetUserInfoResult{
//    [DEFAULTS setObject:self.loginUserId forKey:@"userId"];
//    [DEFAULTS setObject:self.qtxsy_auth forKey:@"qtxsy_auth"];
//    [DEFAULTS setObject:self.userKind forKey:@"userKind"];
//    [DEFAULTS setObject:self.user_id_str forKey:@"user_id_str"];
//    [DEFAULTS synchronize];
//    [self endEditing:YES];
//
//    NSDictionary *dic = @{
//                          @"user_id_str":self.user_id_str,
//                          @"_isReturnCompanyInfo":@"1",
//                          @"_isReturnExt":@"1"
//                          };
//    [[RequestManager shareRequestManager] GetUserInfoResult:dic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"GetUserInfoResult------>%@",result);
//        if (IsSucess(result) == 1) {
//            NSDictionary *resultDic = [[result objectForKey:@"data"] objectForKey:@"result"];
//            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_tel"]] forKey:@"userTelphone"];
//            [DEFAULTS synchronize];
//            NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
//            if (userTelphone != nil && ![userTelphone isEqualToString:@""]) {
//                [self WhetherGotoTagView];
//            }else{
//                [self gotoBindView];
//            }
//        }else{
//        }
//    } failuer:^(NSError *error) {
//    }];
//}

- (void)loginRongCloudtoken:(NSString *)token{
    //登录融云服务器
    [[RCIM sharedRCIM] connectWithToken: token
                                success:^(NSString *userId) {
                                    NSLog([NSString
                                           stringWithFormat:@"token is %@  userId is %@", token , userId],
                                          nil);
                                    self.loginUserId = userId;
                                    [self loginSuccesstoken:self.qtxsy_auth userId:userId];
                                }error:^(RCConnectErrorCode status) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        NSLog(@"RCConnectErrorCode is %ld", (long)status);
                                        //SDK会自动重连登录，这时候需要监听连接状态
                                        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
                                        [[RCIMClient sharedRCIMClient] logout];
                                    });
                                }tokenIncorrect:^{
                                    NSLog(@"IncorrectToken");
                                    if (_loginFailureTimes < 1) {
                                        _loginFailureTimes++;
                                        NSDictionary *dic = @{@"qtxsy_auth":self.qtxsy_auth};
                                        [[RequestManager shareRequestManager] GetGetRongYunTokenResult:dic viewController:nil successData:^(NSDictionary *result) {
                                            if (IsSucess(result) == 1) {
                                                
                                                [self loginRongCloudtoken:[result objectForKey:@"data"][@"result"]];
                                            }else {
                                                NSLog(@"errorMTL----GetGetRongYunTokenResult---->%@",result);
                                            }
                                        } failuer:^(NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                NSLog(@"Token无效");
                                                NSLog(@"无法连接到服务器！");
                                            });
                                        }];
                                    }
                                }];
}

- (void)loginSuccesstoken:(NSString *)token userId:(NSString *)userId{
//    [self invalidateRetryTime];
    //保存默认用户
    
    [DEFAULTS setObject:token forKey:@"rongyuntoken"];
    [DEFAULTS setObject:self.loginUserId forKey:@"userId"];
    [DEFAULTS setObject:self.qtxsy_auth forKey:@"qtxsy_auth"];
    [DEFAULTS setObject:self.userKind forKey:@"userKind"];
    [DEFAULTS setObject:self.user_id_str forKey:@"user_id_str"];
    [DEFAULTS synchronize];
   
    NSDictionary *dic = @{
                          @"user_id_str":self.user_id_str,
                          @"_isReturnCompanyInfo":@"1",
                          @"_isReturnExt":@"1"
                          };
                          
    [[RequestManager shareRequestManager] GetUserInfoResult:dic viewController:nil successData:^(NSDictionary *result) {
        

        if (IsSucess(result) == 1) {
            NSDictionary *resultDic = [[result objectForKey:@"data"] objectForKey:@"result"];
            NSString *userNickName = [resultDic objectForKey:@"c_nickname"];
            NSString *userPortraitUri = [resultDic objectForKey:@"c_photo"];
            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_tel"]] forKey:@"userTelphone"];
            [DEFAULTS setObject:userNickName forKey:@"userNickName"];
            [DEFAULTS setObject:userPortraitUri forKey:@"userPortraitUri"];
            
            [DEFAULTS synchronize];
            
            
            RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId
                                                             name:userNickName
                                                         portrait:userPortraitUri];
            //            [[DBHelper shareInstance] insertUserToDB:user];
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
            [RCIM sharedRCIM].currentUserInfo = user;
            NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
            if (userTelphone != nil && ![userTelphone isEqualToString:@""]) {
                [self WhetherGotoTagView];
            }else{
                [self gotoBindView];
            }
        }else{
            
        }
    } failuer:^(NSError *error) {
        
    }];
}

-  (void)invalidateRetryTime{
    [self.timer invalidate];
    [self.timeLabel removeFromSuperview];
    self.timer = nil;
    i=60;
}

-(void)NewGuideViewTaped:(UITapGestureRecognizer *)sender{
    self.AgreementtitleLabel.userInteractionEnabled = NO;
    WebViewController *vc = [[WebViewController alloc] init];
    vc.isModalButton = YES;
    vc.webtitle =@"渠天下生意平台 用户合作协议";
    vc.webViewurl = [NSString stringWithFormat:@"%@",@"user/userAgreement??appUse=iOS"];
    [self.superViewController.navigationController pushViewController:vc animated:YES];
    self.AgreementtitleLabel.userInteractionEnabled = YES;
}


#pragma mark - 按钮点击事件
-(void)fieldChanged:(id)sender{
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
        self.loginButton.enabled = YES;
    }else{
        self.loginButton.enabled = NO;
    }
}

#pragma mark - RCIMConnectionStatusDelegate
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
            [self loginSuccesstoken:self.qtxsy_auth userId:self.loginUserId];
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
            NSLog(@"当前网络不可用，请检查！");
            [[RequestManager shareRequestManager] tipAlert:@"当前网络不可用，请检查！" viewController:nil];
        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            NSLog(@"您的帐号在别的设备上登录，您被迫下线！");
            [[RequestManager shareRequestManager] tipAlert:@"您的帐号在别的设备上登录，您被迫下线！" viewController:nil];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            NSLog(@"Token无效");
            NSLog(@"无法连接到服务器！");
            [[RequestManager shareRequestManager] tipAlert:@"无法连接到服务器！" viewController:nil];
            if (self.loginFailureTimes < 1) {
                self.loginFailureTimes++;
                NSDictionary *dataDic = @{@"qtxsy_auth":self.qtxsy_auth};
                [[RequestManager shareRequestManager] GetGetRongYunTokenResult:dataDic viewController:nil successData:^(NSDictionary *result) {
//                    NSLog(@"result-----GetGetRongYunTokenResult--->%@",result);
                    if (IsSucess(result) == 1) {
                         [self loginRongCloudtoken:[result objectForKey:@"data"][@"result"]];
//                         [self loginRongCloudtoken:returnObject.rongyuntoken];
                    }else {
//                        NSLog(@"errorMTL----GetGetRongYunTokenResult---->%@",result);
                    }
                } failuer:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Token无效");
                        NSLog(@"无法连接到服务器！");
                        [[RequestManager shareRequestManager] tipAlert:@"无法连接到服务器！" viewController:nil];
                    });
                }];
            }
        } else {
            NSLog(@"RCConnectErrorCode is %zd", status);
            [[RCIMClient sharedRCIMClient] logout];
        }
    });
}

#pragma mark QQButton WechatButton LoginButton SendMessageButton onClick Event
-(void)OnClick:(UIButton *)sender{
    self.QQButton.enabled = NO;
    self.weixinButton.enabled = NO;
    self.loginButton.enabled = NO;
    self.sendMessageButton.enabled = NO;
    RCNetworkStatus status = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
    
    if (RC_NotReachable == status) {
        self.QQButton.enabled = YES;
        self.weixinButton.enabled = YES;
        self.loginButton.enabled = YES;
        self.sendMessageButton.enabled = YES;
        [[RequestManager shareRequestManager] tipAlert:@"当前网络不可用，请检查！" viewController:nil];
        return;
    }
    
     __block LoginView *manager = self;
    NSDictionary *postdic = nil;
    if (sender.tag == SendMessageButtonTag) {
        postdic = @{@"tel":self.phoneTextField.text,};
        [[RequestManager shareRequestManager] GetVerifyCodeResult:postdic viewController:nil successData:^(NSDictionary *result) {
             NSLog(@"GetVerifyCodeResult-----resopnse----->%@",result);
            if (IsSucess(result) == 1) {
                [manager.sendMessageButton removeFromSuperview];
                manager.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:manager selector:@selector(runClock) userInfo:nil repeats:YES];
                [manager.timer fire];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self.superViewController];
                }
            }
            [manager endEditing:YES];
            manager.QQButton.enabled = YES;
            manager.weixinButton.enabled = YES;
            manager.loginButton.enabled = YES;
            manager.sendMessageButton.enabled = YES;
        } failuer:^(NSError *error) {
            [manager endEditing:YES];
            manager.QQButton.enabled = NO;
            manager.weixinButton.enabled = NO;
            manager.loginButton.enabled = NO;
            manager.sendMessageButton.enabled = NO;
        }];
    }
    
    if (sender.tag == LoginButtonTag) {
        postdic = @{
                    @"user_login":self.phoneTextField.text,
                    @"verification_code":self.passwordTextField.text,
                    };
        //1 app登录请求app后台服务器 返回userID
        //2 通过userID 请求服务器返回token
        //3 服务器返回token后本地存储token
        //3 app 缓存token 和userID
        [[RequestManager shareRequestManager] LoginUserRequest:postdic viewController:nil successData:^(NSDictionary *result) {
//            NSLog(@"result----LoginUserRequest---->%@",result);
            if (IsSucess(result) == 1) {
                [JPUSHService setTags:nil alias:[[RequestManager shareRequestManager] opendUDID] fetchCompletionHandle:
                 ^(int iResCode, NSSet *iTags,NSString *iAlias){
                     NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,[self logSet:iTags], iAlias];
                     NSLog(@"TagsAlias回调:%@", callbackString);
                 }];
        
                manager.loginUserId = [[result objectForKey:@"data"] objectForKey:@"user_id"];
                manager.qtxsy_auth = [[result objectForKey:@"data"] objectForKey:@"qtxsy_auth"];
                manager.userKind = [NSString stringWithFormat:@"%d",[[[result objectForKey:@"data"] objectForKey:@"user_kind"] intValue]];
                manager.user_id_str = [[result objectForKey:@"data"] objectForKey:@"user_id_str"];
                
                NSDictionary *dic = @{@"qtxsy_auth":manager.qtxsy_auth};
                [self loginRongYunServer:dic];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self.superViewController];
                }
            }
            [manager endEditing:YES];
            manager.QQButton.enabled = YES;
            manager.weixinButton.enabled = YES;
            manager.loginButton.enabled = YES;
            manager.sendMessageButton.enabled = YES;
        } failuer:^(NSError *error) {
            [manager endEditing:YES];
            manager.loginButton.enabled = YES;
            manager.sendMessageButton.enabled = YES;
            manager.weixinButton.enabled = YES;
            manager.loginButton.enabled = YES;
        }];
    }
    
    if (sender.tag == QQButttonTag) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                // 授权信息
                NSLog(@"QQ uid: %@", resp.uid);
                NSLog(@"QQ openid: %@", resp.openid);
                NSLog(@"QQ unionid: %@", resp.unionId);
                NSLog(@"QQ accessToken: %@", resp.accessToken);
                NSLog(@"QQ expiration: %@", resp.expiration);
                // 用户信息
                NSLog(@"QQ name: %@", resp.name);
                NSLog(@"QQ iconurl: %@", resp.iconurl);
                NSLog(@"QQ gender: %@", resp.unionGender);
                // 第三方平台SDK源数据
                NSLog(@"QQ originalResponse: %@", resp.originalResponse);
                NSDictionary *dic = @{
                                      @"openid_qq":resp.openid,
                                      @"nickname":resp.name,
                                      @"headimgurl":resp.iconurl,
                                      };
                [[RequestManager shareRequestManager] login4APPByOpenidQqRequest:dic viewController:nil successData:^(NSDictionary *result) {
//                    NSLog(@"result----login4APPByOpenidQqRequest---->%@",result);
                    if (IsSucess(result) == 1) {
                        [JPUSHService setTags:nil alias:[[RequestManager shareRequestManager] opendUDID] fetchCompletionHandle:
                         ^(int iResCode, NSSet *iTags,NSString *iAlias){
                             NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,[self logSet:iTags], iAlias];
                             NSLog(@"TagsAlias回调:%@", callbackString);
                         }];
                        
                        manager.loginUserId = [[result objectForKey:@"data"] objectForKey:@"user_id"];
                        manager.qtxsy_auth = [[result objectForKey:@"data"] objectForKey:@"qtxsy_auth"];
                        manager.userKind = [NSString stringWithFormat:@"%d",[[[result objectForKey:@"data"] objectForKey:@"user_kind"] intValue]];
                        manager.user_id_str = [[result objectForKey:@"data"] objectForKey:@"user_id_str"];
                        
                        NSDictionary *dic = @{@"qtxsy_auth":manager.qtxsy_auth};
                        [self loginRongYunServer:dic];
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self.superViewController];
                        }
                    }
                    [manager endEditing:YES];
                    manager.QQButton.enabled = YES;
                    manager.weixinButton.enabled = YES;
                    manager.loginButton.enabled = YES;
                    manager.sendMessageButton.enabled = YES;
                } failuer:^(NSError *error) {
                    [manager endEditing:YES];
                    manager.loginButton.enabled = YES;
                    manager.sendMessageButton.enabled = YES;
                    manager.weixinButton.enabled = YES;
                    manager.loginButton.enabled = YES;
                }];
            }
        }];
    }
    
    if (sender.tag == WeChatButtonTag) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"getAuthWithUserInfoFromWechat-----error----->%@",error);
                [manager endEditing:YES];
                                   manager.loginButton.enabled = YES;
                                   manager.sendMessageButton.enabled = YES;
                                   manager.weixinButton.enabled = YES;
                                   manager.loginButton.enabled = YES;
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                // 授权信息
                NSLog(@"Wechat uid: %@", resp.uid);
                NSLog(@"Wechat openid: %@", resp.openid);
                NSLog(@"Wechat unionid: %@", resp.unionId);
                NSLog(@"Wechat accessToken: %@", resp.accessToken);
                NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
                NSLog(@"Wechat expiration: %@", resp.expiration);
                
                // 用户信息
                
                NSLog(@"Wechat name: %@", resp.name);
                NSLog(@"Wechat iconurl: %@", resp.iconurl);
                NSLog(@"Wechat gender: %@", resp.unionGender);
                
                // 第三方平台SDK源数据
                NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
                NSDictionary *dic = @{
                                      @"openid_wx":resp.openid,
                                      @"nickname":resp.name,
                                      @"headimgurl":resp.iconurl,
                                      };
                [[RequestManager shareRequestManager] login4APPByOpenidWxRequest:dic viewController:nil successData:^(NSDictionary *result) {
//                    NSLog(@"result----login4APPByOpenidWxRequest---->%@",result);
                    if (IsSucess(result) == 1) {
                        [JPUSHService setTags:nil alias:[[RequestManager shareRequestManager] opendUDID] fetchCompletionHandle:
                         ^(int iResCode, NSSet *iTags,NSString *iAlias){
                             NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,[self logSet:iTags], iAlias];
                             NSLog(@"TagsAlias回调:%@", callbackString);
                         }];
                        manager.loginUserId = [[result objectForKey:@"data"] objectForKey:@"user_id"];
                        manager.qtxsy_auth = [[result objectForKey:@"data"] objectForKey:@"qtxsy_auth"];
                        manager.userKind = [NSString stringWithFormat:@"%d",[[[result objectForKey:@"data"] objectForKey:@"user_kind"] intValue]];
                        manager.user_id_str = [[result objectForKey:@"data"] objectForKey:@"user_id_str"];
                        
                        NSDictionary *dic = @{@"qtxsy_auth":manager.qtxsy_auth};
                        [self loginRongYunServer:dic];
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self.superViewController];
                        }
                    }
                    [manager endEditing:YES];
                    manager.loginButton.enabled = YES;
                    manager.sendMessageButton.enabled = YES;
                    manager.weixinButton.enabled = YES;
                    manager.loginButton.enabled = YES;
                } failuer:^(NSError *error) {
                    [manager endEditing:YES];
                    manager.loginButton.enabled = YES;
                    manager.sendMessageButton.enabled = YES;
                    manager.weixinButton.enabled = YES;
                    manager.loginButton.enabled = YES;
                }];
            }
        }];
    }
}

- (void)loginRongYunServer:(NSDictionary *)dataDic{
    [[RequestManager shareRequestManager] GetGetRongYunTokenResult:dataDic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"result-----GetGetRongYunTokenResult--->%@",result);
        if (IsSucess(result) == 1) {
            [self loginRongCloudtoken:[result objectForKey:@"data"][@"result"]];
        }else {
//            NSLog(@"errorMTL----GetGetRongYunTokenResult---->%@",result);
        }
    } failuer:^(NSError *error) {
        
    }];
}

-(void)gotoBindView{
    AccountBindingViewController *vc = [[AccountBindingViewController alloc] init];
    vc.isModalButton = YES;
    [self.superViewController.navigationController pushViewController:vc animated:YES];
}

-(void)WhetherGotoTagView{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] getChooseTagsFlag:dic viewController:self.superViewController successData:^(NSDictionary *result) {
//        NSLog(@"result------->%@",result);
        if (IsSucess(result) == 1) {
            NSInteger WhetherGoTagViewFlag = [[[result objectForKey:@"data"] objectForKey:@"result"] integerValue];
            if (WhetherGoTagViewFlag == 0) {
                SelectTagViewController *vc = [[SelectTagViewController alloc] init];
                [self.superViewController.navigationController pushViewController:vc animated:YES];
            }else{
                [self saveIntoDefaults];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self.superViewController];
            }
        }
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self.superViewController];
        [LZBLoadingView dismissLoadingView];
    }];
}

-(void)saveIntoDefaults{
    [self.superViewController dismissViewControllerAnimated:YES completion:NULL];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_LOGINSELECT object:nil userInfo:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    [*tags addObject:tag];
}

#pragma mark - Getter
- (UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [UIImageView new];
        _logoImageView.image = [UIImage imageNamed:@"login_logo"];
    }
    return _logoImageView;
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
        _passwordTextField.tintColor = [UIColor redColor];
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
        _sendMessageButton.tag = SendMessageButtonTag;
        [_sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendMessageButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_sendMessageButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
        _sendMessageButton.layer.cornerRadius = UI(17);
        _sendMessageButton.layer.masksToBounds = YES;
        [_sendMessageButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendMessageButton.enabled = NO;
    }
    return _sendMessageButton;
}

-(UILabel *)loginAgreementLabel{
    if (_loginAgreementLabel == nil) {
        _loginAgreementLabel = [CommentMethod initLabelWithText:@"点击登录代表你已同意" textAlignment:NSTextAlignmentRight font:12 TextColor:FontUIColor999999Gray];
        UITapGestureRecognizer * loginAgreementLabeltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NewGuideViewTaped:)];
        _loginAgreementLabel.userInteractionEnabled = YES;
        [_loginAgreementLabel addGestureRecognizer:loginAgreementLabeltap];
    }
    return _loginAgreementLabel;
}

-(UILabel *)AgreementtitleLabel{
    if (_AgreementtitleLabel== nil) {
        _AgreementtitleLabel = [CommentMethod initLabelWithText:@"《渠天下生意用户协议》" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColor999999Gray];
        UITapGestureRecognizer * NewViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NewGuideViewTaped:)];
        _AgreementtitleLabel.userInteractionEnabled = YES;
        [_AgreementtitleLabel addGestureRecognizer:NewViewtap];
        
    }
    return _AgreementtitleLabel;
}

-(UILabel *)socialDescriptionLabel{
    if (_socialDescriptionLabel == nil) {
        _socialDescriptionLabel = [CommentMethod initLabelWithText:@"——  使用社交账号登录  ——" textAlignment:NSTextAlignmentCenter font:12 TextColor:FontUIColorBlack];
    }
    return _socialDescriptionLabel;
}

-(UIImageView *)lineImageView1{
    if (_lineImageView1 == nil) {
        _lineImageView1 = [UIImageView new];
        _lineImageView1.backgroundColor =lineImageColor;
    }
    return _lineImageView1;
}

-(UIImageView *)lineImageView2{
    if (_lineImageView2 == nil) {
        _lineImageView2 = [UIImageView new];
        _lineImageView2.backgroundColor =lineImageColor;
    }
    return _lineImageView2;
}

-(UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 8;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.tag = LoginButtonTag;
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[CommentMethod createImageWithColor: [UIColor colorWithRed:249/255.0 green:54/255.0 blue:48/255.0 alpha:0.5/1.0]] forState:UIControlStateDisabled];
        [_loginButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.enabled = NO;
    }
    return _loginButton;
}

-(UIButton *)weixinButton{
    if (_weixinButton == nil) {
        _weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinButton.tag = WeChatButtonTag;
        [_weixinButton setBackgroundImage:[UIImage imageNamed:@"login_icon_wechat"] forState:UIControlStateNormal];
        [_weixinButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinButton;
}

-(UIButton *)QQButton{
    if (_QQButton == nil) {
        _QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _QQButton.tag = QQButttonTag;
        [_QQButton setBackgroundImage:[UIImage imageNamed:@"login_icon_qq"] forState:UIControlStateNormal];
        [_QQButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QQButton;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = FontUIColorBlack;
        self.timeLabel.backgroundColor = UIColorFromRGB(0xdddddd);
        self.timeLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.cornerRadius = 17*AUTO_SIZE_SCALE_X;
    }
    return _timeLabel;
}

//#pragma mark - KVO
//- (void)setupKVO {
//    [self.loginViewModel addObserver:self forKeyPath:@"racMsg" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
//    //    //* FBKVO
//    //    [self.KVOController observe:self.vm keyPath:@"nameStr" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//    //        self.label.text = change[NSKeyValueChangeNewKey];
//    //    }];
//}
//
//-(void)dealloc{
//    [self removeKVO];
//}
//
//- (void)removeKVO {
//    [self.loginViewModel removeObserver:self forKeyPath:@"racMsg"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"racMsg"]) {
//        if ([_loginViewModel.racMsg isEqualToString:@"success"]) {
//            NSLog(@"keypath----->%@--------%@----context---->%@",keyPath,((LoginViewModel *)object).loginModel,change);
//
//            if (_loginViewModel.loginModel.responseFlagState == ResponseSuccess) {
//                [self.superViewController dismissViewControllerAnimated:YES completion:NULL];
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_LOGINSELECT object:nil userInfo:@{NOTIFICATION_NAME_LOGINSELECT:@(self.selectIndex)}];
//            } else {
//                NSLog(@"msg----->%@",_loginViewModel.loginModel.msg);
//            }
//
//        }else {
//
//            NSLog(@"keypath----->%@--------%@----context---->%@",keyPath,((LoginViewModel *)object).loginModel,change);
//        }
//        _button.enabled = YES;
//    }
//}



@end
