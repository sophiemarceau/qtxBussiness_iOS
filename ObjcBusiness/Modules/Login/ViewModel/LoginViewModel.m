//
//  LoginViewModel.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginModel.h"
#import "JPUSHService.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MessageCodeModel.h"
#import "RongYunModel.h"
#import "UserInfoModel.h"

@interface LoginViewModel()

@end
@implementation LoginViewModel


- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)getMsgCode:(NSDictionary *)dataDic{
    [[RequestManager shareRequestManager] GetVerifyCodeResult:dataDic viewController:nil successData:^(NSDictionary *result) {
        
        NSError *errorMTL ;
        id returnObject = [MTLJSONAdapter modelOfClass:RongYunModel.class
                                    fromJSONDictionary:result error:&errorMTL];
        ResopnseFlagState flag;
        if(IsSucess(result) == 1){
            flag = ResponseSuccess;
        }else{
            flag = ResponseFailure;
        }
        if(![errorMTL isEqual:[NSNull null]]) {
            self.returnBlock(returnObject, flag,@"GetVerifyCodeResult");
        }else {
//            NSLog(@"errorMTL-------->%@",errorMTL);
        }
    } failuer:^(NSError *error) {
        
    }];
}


- (void)LoginApp:(NSDictionary *)dataDic{
    //1 app登录请求app后台服务器 返回userID
    //2 通过userID 请求服务器返回token
    //3 服务器返回token后本地存储token
    //3 app 缓存token 和userID
    [[RequestManager shareRequestManager] LoginUserRequest:dataDic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"result----LoginUserRequest---->%@",result);
        NSError *errorMTL ;
        id returnObject = [MTLJSONAdapter modelOfClass:LoginModel.class
                                    fromJSONDictionary:result error:&errorMTL];
        ResopnseFlagState flag;
        if(IsSucess(result) == 1){
            flag = ResponseSuccess;
            [JPUSHService setTags:nil alias:[[RequestManager shareRequestManager] opendUDID] fetchCompletionHandle:
             ^(int iResCode, NSSet *iTags,NSString *iAlias){
                 NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,[self logSet:iTags], iAlias];
//                 NSLog(@"TagsAlias回调:%@", callbackString);
             }];
        }else{
            flag = ResponseFailure;
        }
//        NSLog(@"result----LoginUserRequest---->%@",returnObject);
        if(![errorMTL isEqual:[NSNull null]]) {
            self.returnBlock(returnObject, flag,@"LoginUserRequest");
        }else {
            NSLog(@"errorMTL-------->%@",errorMTL);
        }
    } failuer:^(NSError *error) {
        
    }];
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


#pragma mark - 微信
- (void)getAuthWithUserInfoFromWechat{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
//            NSLog(@"getAuthWithUserInfoFromWechat-----error----->%@",error);
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
//                NSLog(@"result----login4APPByOpenidWxRequest---->%@",result);
                NSError *errorMTL ;
                LoginModel *returnObject = [MTLJSONAdapter modelOfClass:LoginModel.class
                                            fromJSONDictionary:result error:&errorMTL];
                
                ResopnseFlagState flag;
                if(IsSucess(result) == 1){
                    flag = ResponseSuccess;
                    [JPUSHService setTags:nil alias:[[RequestManager shareRequestManager] opendUDID] fetchCompletionHandle:
                     ^(int iResCode, NSSet *iTags,NSString *iAlias){
                         NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,[self logSet:iTags], iAlias];
                         NSLog(@"TagsAlias回调:%@", callbackString);
                     }];
                }else{
                    flag = ResponseFailure;
                }
                if(![errorMTL isEqual:[NSNull null]]) {
                    self.returnBlock(returnObject, flag,@"QQorWechat");
                }else {
                    NSLog(@"errorMTL-------->%@",errorMTL);
                }
            } failuer:^(NSError *error) {
                
            }];
        }
    }];
}

#pragma mark - QQ
- (void)getAuthWithUserInfoFromQQ{
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
//                NSLog(@"result----login4APPByOpenidQqRequest---->%@",result);
                NSError *errorMTL ;
                id returnObject = [MTLJSONAdapter modelOfClass:LoginModel.class
                                            fromJSONDictionary:result error:&errorMTL];
                ResopnseFlagState flag;
                if(IsSucess(result) == 1){
                    flag = ResponseSuccess;
                    [JPUSHService setTags:nil alias:[[RequestManager shareRequestManager] opendUDID] fetchCompletionHandle:
                     ^(int iResCode, NSSet *iTags,NSString *iAlias){
                         NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,[self logSet:iTags], iAlias];
                         NSLog(@"TagsAlias回调:%@", callbackString);
                     }];
                }else{
                    flag = ResponseFailure;
                }
                if(![errorMTL isEqual:[NSNull null]]) {
                    self.returnBlock(returnObject, flag,@"QQorWechat");
                }else {
                    NSLog(@"errorMTL-------->%@",errorMTL);
                }
            } failuer:^(NSError *error) {
                
            }];
        }
    }];

}

- (void)loginRongYunServer:(NSDictionary *)dataDic{
    [[RequestManager shareRequestManager] GetGetRongYunTokenResult:dataDic viewController:nil successData:^(NSDictionary *result) {
        NSLog(@"result-----GetGetRongYunTokenResult--->%@",result);
        ResopnseFlagState flag;

        if (IsSucess(result) == 1) {
            flag = ResponseSuccess;
            self.returnBlock(result, flag,@"loginRongYunServer");
        }else {
            flag = ResponseFailure;
        }
        self.returnBlock(result, flag,@"loginRongYunServer");

    } failuer:^(NSError *error) {
        
    }];
}

@end
