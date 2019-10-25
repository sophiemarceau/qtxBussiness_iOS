//
//  LoginViewModel.h
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewModel.h"



@interface LoginViewModel : BaseViewModel

//@property (strong,nonatomic) LoginModel *loginModel;
//@property (strong,nonatomic) NSString *racMsg;


//- (void)LoginApp:(NSDictionary *)dataDic WithUIViewController:(UIViewController *)superViewController;

- (void)LoginApp:(NSDictionary *)dataDic;
- (void)getMsgCode:(NSDictionary *)dataDic;

//- (void)LoginAppWithUIViewController:(UIViewController *)superViewController;

- (void)getAuthWithUserInfoFromWechat;
- (void)getAuthWithUserInfoFromQQ;

- (void)loginRongYunServer:(NSDictionary *)dataDic;
@end
