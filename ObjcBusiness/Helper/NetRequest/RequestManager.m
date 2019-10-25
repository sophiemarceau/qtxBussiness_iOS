//
//  RequestManager.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "RequestManager.h"
#import "NetworkManager.h"
#import <commoncrypto/CommonDigest.h>
#import "OpenUDID.h"

#define   kNetWorkManager   [NetworkManager SharedNetworkManager]

#pragma 接口汇总
                       
#define HTJD_sendSms @"/api/user/sendvalidatecodesms/"
#define HTJD_login4APPByTel @"/api/user/login4APPByTel/"
#define HTJD_confirmLoginByQRcode4APP @"/api/user/confirmLoginByQRcode4APP/"
#define HTJD_login4APPByOpenidQq @"/api/user/login4APPByOpenidQq/"
#define HTJD_login4APPByOpenidWx @"/api/user/login4APPByOpenidWx/"
#define HTJD_updateUserCInfo @"/api/user/updateUserCInfo/"
#define HTJD_getUserCDto @"/api/user/getUserCDto/"
#define HTJD_updateUserCInfo @"/api/user/updateUserCInfo/"
#define HTJD_toBlank4MachineIdentificationCode @"/api/user/toBlank4MachineIdentificationCode/"
#define HTJD_getUnReadCountDto @"/api/message/getUnReadCountDto/"
#define HTJD_getLoadingPic @"/api/ad/getLoadingPic/"
#define HTJD_searchAdDtoList @"/api/ad/searchAdDtoList/"
#define HTJD_searchPromotingProjects @"/project/searchPromotingProjects/"
#define HTJD_getRongCloudToken @"/api/user/getRongCloudToken/"
#define HTJD_geiAllkindsofNumbersClient @"/api/overview/getStatisticsDto4User/"
#define HTJD_geiAllkindsofNumbersEnterprise @"/api/overview/getStatisticsDto4Company/"
#define HTJD_initBusinessResume @"/api/businessResume/initBusinessResume/"
#define HTJD_getUserBusinessResume @"/api/businessResume/getUserBusinessResume/"
#define HTJD_editBusinessResumeIntention  @"/api/businessResume/editBusinessResumeIntention/"
#define HTJD_closeResumeExperience @"/api/businessResume/closeResumeExperience/"
#define HTJD_deleteBusinessResumePlace @"/api/businessResume/deleteBusinessResumePlace/"
#define HTJD_isPerfectBusinessResume @"/api/businessResume/isPerfectBusinessResume/"
#define HTJD_updateBusinessResumePlace @"/api/businessResume/updateBusinessResumePlace/"
#define HTJD_addBusinessResumePlace @"/api/businessResume/addBusinessResumePlace/"
#define HTJD_addResumeExperience @"/api/businessResume/addResumeExperience/"
#define HTJD_saveBusinessResume @"/api/businessResume/saveBusinessResume/"
#define HTJD_getBusinessResumePlace @"/api/businessResume/getBusinessResumePlace/"
#define HTJD_getBusinessResumeIntention @"/api/businessResume/getBusinessResumeIntention/"
#define HTJD_uploadImgPhoto @"/api/image/uploadImg/"
#define HTJD_searchCompanySimpleDtosByCompanyName @"/api/company/searchCompanySimpleDtosByCompanyName/"
#define HTJD_applyCompanyEntering @"/api/user/applyCompanyEntering/"
#define HTJD_openCompanyFeature @"/api/user/openCompanyFeature/"
#define HTJD_getCompanyStatusByName @"/api/company/getCompanyStatusByName/"
#define HTJD_searchProjectDtos4App @"/api/project/searchProjectDtos4App/"
#define HTJD_getProjectDto4App @"/api/project/getProjectDto4App/"
#define HTJD_searchProjectMessageDtos4Project @"/api/project/searchProjectMessageDtos4Project/"
#define HTJD_cancelProjectCollect @"/api/collection/cancelCollectProject/"
#define HTJD_addProjectCollect @"/api/collection/collectProject/"
#define HTJD_createProjectMessage @"/api/project/createProjectMessage/"
#define HTJD_submitFeedback @"/api/feedback/submitFeedback/"
#define HTJD_getOnlineAndOfflineProjectDtoListByUserId @"/api/project/getOnlineAndOfflineProjectDtoListByUserId/"
#define HTJD_getProjectMessageDto @"/api/project/getProjectMessageDto/"
#define HTJD_getMessageUserTel @"/api/project/getMessageUserTel/"
#define HTJD_saveSimpleBusinessResume @"/api/businessResume/saveSimpleBusinessResume/"
#define HTJD_getSimpleBusinessResumeDto @"/api/businessResume/getSimpleBusinessResumeDto/"
#define HTJD_searchLatestQuestionDtos @"/api/qa/searchLatestQuestionDtos/"
#define HTJD_searchHotAnswerDtos @"/api/qa/searchHotAnswerDtos/"
#define HTJD_getTagDtoList @"/api/qa/getTagDtoList/"
#define HTJD_searchQuestionDtosByTag @"/api/qa/searchQuestionDtosByTag/"
#define HTJD_recommendExpert @"/api/connection/recommendExpert/"
#define HTJD_askQuestion @"/api/qa/askQuestion/"
#define HTJD_addTag @"/api/qa/addTag/"
#define HTJD_getLikeTagDtoLike @"/api/qa/getLikeTagDtoLike/"
#define HTJD_getQuestionDetail @"/api/qa/getQuestionDetail/"
#define HTJD_searchAnswerDtosByQuestionId @"/api/qa/searchAnswerDtosByQuestionId/"
#define HTJD_cancelCollectQuestion @"/api/qa/cancelCollectQuestion/"
#define HTJD_collectQuestion @"/api/qa/collectQuestion/"
#define HTJD_searchExpert @"/api/qa/searchExpert/"
#define HTJD_inviteAnswer @"/api/qa/inviteAnswer/"
#define HTJD_answerQuestion @"/api/qa/answerQuestion/"
#define HTJD_getTagDtoListByQuestionId @"/api/qa/getTagDtoListByQuestionId/"
#define HTJD_addConnection @"/api/connection/addConnection/"
#define HTJD_cancelConnection @"/api/connection/cancelConnection/"
#define HTJD_searchBoutiqueAnswerQuestionDtos @"/api/qa/searchBoutiqueAnswerQuestionDtos/"
#define HTJD_searchQuestionDtosByTag @"/api/qa/searchQuestionDtosByTag/"
#define searchOnlinProjectDtosByTagId      @"/api/project/searchOnlinProjectDtosByTagId4App/"
#define HTJD_collectTag @"/api/collection/collectTag/"
#define HTJD_cancelCollectTag @"/api/collection/cancelCollectTag/"
#define HTJD_getUserCHomePageDto @"/api/user/getUserCHomePageDto/"
#define HTJD_searchAnswerDtosByUserId @"/api/qa/searchAnswerDtosByUserId/"
#define HTJD_searchMyAnswerDtos @"/api/qa/searchMyAnswerDtos/"
#define HTJD_searchMyQuestionDtos @"/api/qa/searchMyQuestionDtos/"
#define HTJD_searchOnlinProjectDtosByUserId @"/api/project/searchOnlinProjectDtosByUserId4App/"
#define HTJD_searchQuestionDtosByUserId @"/api/qa/searchQuestionDtosByUserId/"
#define HTJD_getSysMsgUnReadCount  @"/api/message/getSysMsgUnReadCount/"
#define HTJD_updateSysMsgToRead  @"/api/message/updateSysMsgToRead/"
#define HTJD_updateDingToRead @"/api/ding/updateDingToRead/"
#define HTJD_updateCommentToRead @"/api/comment/updateCommentToRead/"
#define HTJD_searchSysMsgDtos  @"/api/message/searchSysMsgDtos/"
#define HTJD_searchCommentDtosByUserId  @"/api/comment/searchCommentDtosByUserId/"
#define HTJD_searchDingDtosByUserId @"/api/ding/searchDingDtosByUserId/"
#define HTJD_searchHisFansConnectionDtos @"/api/connection/searchHisFansConnectionDtos/"
#define HTJD_searchMyFansConnectionDtos @"/api/connection/searchMyFansConnectionDtos/"
#define HTJD_searchMyAttentionConnectionDtos @"/api/connection/searchMyAttentionConnectionDtos/"
#define HTJD_searchHisAttentionConnectionDtos @"/api/connection/searchHisAttentionConnectionDtos/"
#define HTJD_searchQuestionDtosCollection  @"/api/collection/searchQuestionDtosCollection/"
#define HTJD_searchCollectionAnswerDtosByUserId  @"/api/collection/searchCollectionAnswerDtosByUserId/"
#define HTJD_searchCollectionProjectDtosByUserId4App  @"/api/collection/searchCollectionProjectDtosByUserId4App/"
#define HTJD_searchCollectionTagDtosByUserId  @"/api/collection/searchCollectionTagDtosByUserId/"
#define HTJD_bindTel  @"/api/user/bindTel/"
#define HTJD_searchLikeQuestionDtos @"/api/qa/searchLikeQuestionDtos/"
#define HTJD_searcHotSearchProjectDtoList @"/api/project/searcHotSearchProjectDtoList/"
#define HTJD_searchUserCSimpleInfoDtos @"/api/user/searchUserCSimpleInfoDtos/"
#define HTJD_deleteQuestion @"/api/qa/deleteQuestion/"
#define HTJD_getTagDto @"/api/qa/getTagDto/"
#define HTJD_getConnectionStatus @"/api/connection/getConnectionStatus/"
#define HTJD_getAnswerDetail @"/api/qa/getAnswerDetail/"
#define HTJD_shareAnswer @"/api/qa/shareAnswer/"
#define HTJD_addShareCount @"/api/qa/addShareCount/"
#define HTJD_getVersionInfo @"/api/common/checkForUpdates/"
#define HTJD_getAnauthorizedProjectCount  @"/api/project/getAnauthorizedProjectCount/"
#define HTJD_collectTags  @"/api/collection/collectTags/"
#define HTJD_searchTagDtosByRecommend  @"/api/qa/searchTagDtosByRecommend/"
#define HTJD_skipTagsFlag @"/api/user/skipTagsFlag/"
#define HTJD_getChooseTagsFlag @"/api/user/getChooseTagsFlag/"




#define HTJD_createProject4Boss @"/api/project/createProject4Boss/"
#define HTJD_updateProject4Boss  @"/api/project/updateProject4Boss/"
#define HTJD_applyBossEntering @"/api/user/applyBossEntering/"
#define HTJD_searchBossProjectDtos @"/api/project/searchBossProjectDtos/"
#define HTJD_getBossProjectDtoByUserId @"/api/project/getBossProjectDtoByUserId/"

#define HTJD_getProjectCountByUserId @"/api/project/getProjectCountByUserId/"

#define HTJD_saveImUser @"/api/user/saveImUser/"
#define HTJD_searchUserCListDtoByUserIds @"/api/user/searchUserCListDtoByUserIds/"
#define HTJD_searchUserViews @"/api/user/searchUserViews/"
#define HTJD_saveUserView @"/api/user/saveUserView/"
#define HTJD_getRongcloudAppKey @"/api/common/getRongcloudAppKey/"
#define HTJD_countUserViewNum @"/api/user/countUserViewNum/"
static RequestManager *shareResult;
@interface RequestManager ()

@property(nonatomic ,strong) AFHTTPSessionManager *requestManager;

@end
@implementation RequestManager

+(RequestManager *)shareRequestManager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareResult = [[self alloc]init];
        
    });
    return shareResult;
}

#pragma md5 加密
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

//取消请求
- (void)cancelAllRequest
{
    [kNetWorkManager cancelAllRequest];
}


-(NSDictionary *)AddPublicParams:(NSDictionary *)params{
    
    NSString *qtx_quth = [DEFAULTS objectForKey:@"qtxsy_auth"] ;
    NSDictionary *PublicDictionary ;
    if(qtx_quth != nil){
        //    //公共交互报文
        PublicDictionary = @{
                                          @"qtxsy_auth": qtx_quth,
                                          @"source":@"2",
                                          };
    }else{
        PublicDictionary =@{
                            
                            @"source":@"2",
                            };
    }
  
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    //添加 各个不同接口需要请求的参数
    if (params != nil) {
         [beforeDic addEntriesFromDictionary:params];
    }
   
//    NSLog(@"beforedic----->%@",beforeDic);
    return beforeDic;
}

#pragma mark - 退出登录需要删除本地的账号缓存
-(void)loginCancel:(NSDictionary *)resultDic{
//    NSLog(@"resultDic---退出登录需要删除本地的账号缓存--->%@",resultDic);
    NSString *qtxStr = [DEFAULTS objectForKey:@"qtxsy_auth"];
    
    //一种是 qtxStr存在 但是 别的手机登录导致失效了 故要实现被踢出
    if (qtxStr) {
//         NSLog(@"resultDic--msg---一种是 qtxStr存在 但是 别的手机登录导致失效了 故要实现被踢出->");
        [self tipAlert:[resultDic objectForKey:@"msg"] viewController:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:nil];
    }else{
         //另一种是 qtxStr不存在 想看页面需要先去登录再去浏览页面
//         NSLog(@"resultDic---else--->%@",resultDic);
        [self tipAlert:[resultDic objectForKey:@"请您先登录"] viewController:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    }
    return;
}

#pragma mark - 获取验证码
- (void)GetVerifyCodeResult:(NSDictionary *)dataDic viewController:(UIViewController *)controller successData:(SuccessData)success failuer:(ErrorData)errors
{
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_sendSms WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
         success(result);
     } failure:^(NSError *error) {
         errors(error);
     }];
}


#pragma mark -  用户绑定手机号
- (void)bindTel:(NSDictionary *)dataDic
 viewController:(UIViewController *)controller
    successData:(SuccessData)success
        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_bindTel WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 通过userID 获取 有效的融云token
- (void)GetGetRongYunTokenResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success failuer:(ErrorData)errors{
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_getRongCloudToken WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
          success(result);
//         int flag = [[result objectForKey:@"flag"] intValue];
//         if (flag == -1) {
//             [self loginCancel:result];
//         }else{
//             success(result);
//         }
//         NSLog(@"result--通过userID 获取 有效的融云token--->%@",result);
     } failure:^(NSError *error) {
         errors(error);
     }];
}

#pragma mark - 通过通过username password 登录
- (void)LoginResult:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success failuer:(ErrorData)errors{
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_sendSms WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
          success(result);
//         int flag = [[result objectForKey:@"flag"] intValue];
//         if (flag == -1) {
//             [self loginCancel:result];
//         }else{
//             success(result);
//         }
     } failure:^(NSError *error) {
         errors(error);
     }];

}

#pragma mark - 通过userID 获取 UserInfo
- (void)GetUserInfoResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUserCDto WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
          success(result);
//         int flag = [[result objectForKey:@"flag"] intValue];
//         if (flag == -1) {
//             [self loginCancel:result];
//         }else{
//             success(result);
//         }
     } failure:^(NSError *error) {
         errors(error);
     }];
}

#pragma mark - 通过userID 获取 是否生意简历完成
- (void)GetUserIsFinishBusinessResumeResult:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors{
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_getUserCDto WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
          success(result);
//         int flag = [[result objectForKey:@"flag"] intValue];
//         if (flag == -1) {
//             [self loginCancel:result];
//         }else{
//             success(result);
//         }
     } failure:^(NSError *error) {
         errors(error);
     }];
}

#pragma mark - 退出登录APP前，调用此接口清除推送消息用的机器码
- (void)QuitToBlank4MachineIdentificationCodeResult:(NSDictionary *)dataDic
                                     viewController:(UIViewController *)controller
                                        successData:(SuccessData)success failuer:(ErrorData)errors{
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_toBlank4MachineIdentificationCode WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
          success(result);
//         int flag = [[result objectForKey:@"flag"] intValue];
//         if (flag == -1) {
//             [self loginCancel:result];
//         }else{
//             success(result);
//         }
     } failure:^(NSError *error) {
         errors(error);
     }];
}

#pragma mark - 手机号登录APP
- (void)LoginUserRequest:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *PublicDictionary =@{
                                      @"user_lastloginsource":@"2",//登录来源（1，Android；2，iOS；3，H5；4，PC；5，SYSTEM）
                                      @"machine_identification_code":[self opendUDID],
                                      };
//    NSLog(@"machin_identification_code---------->%@",PublicDictionary);
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    [beforeDic addEntriesFromDictionary:dataDic];
    //    NSDictionary *postdic = [self translateParams:beforeDic];
    //    NSLog(@"beforeDic--------->%@",beforeDic);
    
    [kNetWorkManager requestPostWithParameters:beforeDic
                                       ApiPath:
     HTJD_login4APPByTel WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 更新用户个人信息
- (void)UpdateUserInfoResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateUserCInfo WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];

}


#pragma mark - APP确认登录PC企业端
- (void)confirmLoginByQRcode4APPRequest:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_confirmLoginByQRcode4APP WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - QQ登录APP
- (void)login4APPByOpenidQqRequest:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors{
    NSDictionary *PublicDictionary =@{
                                      @"user_lastloginsource":@"2",//登录来源（1，Android；2，iOS；3，H5；4，PC；5，SYSTEM）
                                      @"machine_identification_code":[self opendUDID],
                                      };
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    [beforeDic addEntriesFromDictionary:dataDic];

    //    NSDictionary *postdic = [self translateParams:beforeDic];
    //    NSLog(@"beforeDic--------->%@",beforeDic);
    
    [kNetWorkManager requestPostWithParameters:beforeDic
                                       ApiPath:
     HTJD_login4APPByOpenidQq WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 微信登录APP
- (void)login4APPByOpenidWxRequest:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors{
    NSDictionary *PublicDictionary =@{
                                      @"user_lastloginsource":@"2",//登录来源（1，Android；2，iOS；3，H5；4，PC；5，SYSTEM）
                                      @"machine_identification_code":[self opendUDID],
                                      };
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    [beforeDic addEntriesFromDictionary:dataDic];
    //    NSDictionary *postdic = [self translateParams:beforeDic];
        
    
    [kNetWorkManager requestPostWithParameters:beforeDic
                                       ApiPath:
     HTJD_login4APPByOpenidWx WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取打开APP时的加载图片（及对应跳转的Url）
- (void)getfirstFigure:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors{
    NSDictionary *PublicDictionary =@{@"source":@"2",};
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    //添加 各个不同接口需要请求的参数
    [beforeDic addEntriesFromDictionary:dataDic];
    
    [kNetWorkManager requestPostWithParameters:beforeDic
                                       ApiPath:
     HTJD_getLoadingPic
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

- (void)SearchPromotingProjectsResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors{
    NSDictionary *PublicDictionary =@{@"source":@"2",};
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    //添加 各个不同接口需要请求的参数
    [beforeDic addEntriesFromDictionary:dataDic];
    
    [kNetWorkManager requestPostWithParameters:beforeDic
                                       ApiPath:
     HTJD_searchPromotingProjects WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 通过userID 获取 浏览数 收藏数 沟通数
- (void)GetAllKindsOfNumbersClientInfoResult:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors{
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_geiAllkindsofNumbersClient WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
//         int flag = [[result objectForKey:@"flag"] intValue];
//         if (flag == -1) {
//             [self loginCancel:result];
//         }else{
//             success(result);
//         }
          success(result);
     } failure:^(NSError *error) {
         errors(error);
     }];
}

#pragma mark - 通过userID 获取 浏览数 收藏数 沟通数
- (void)GetAllKindsOfNumbersEnterpriseInfoResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success failuer:(ErrorData)errors{
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_geiAllkindsofNumbersEnterprise WithHeader:nil onTarget:controller success:^(NSDictionary *result) {
//         int flag = [[result objectForKey:@"flag"] intValue];
//         if (flag == -1) {
//             [self loginCancel:result];
//         }else{
//             success(result);
//         }
          success(result);
     } failure:^(NSError *error) {
         errors(error);
     }];
}

#pragma mark -4.5.9	获取banner列表(app端)
- (void)SearchAdDtoListResult:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchAdDtoList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 初始化简历
- (void)initBusinessResume:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_initBusinessResume WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取用户生意简历
- (void)getUserBusinessResume:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUserBusinessResume WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 编辑生意简历意向信息
- (void)editBusinessResumeIntention:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_editBusinessResumeIntention WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 关闭生意经验
- (void)closeResumeExperience:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_closeResumeExperience WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 删除生意简历场所信息
- (void)deleteBusinessResumePlace:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_deleteBusinessResumePlace WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 我的页面里面的 是否显示完善生意简历提示
- (void)isPerfectBusinessResume:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_isPerfectBusinessResume WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 更新生意简历场所信息
- (void)updateBusinessResumePlace:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateBusinessResumePlace WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 添加生意简历场所信息
- (void)addBusinessResumePlace:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addBusinessResumePlace WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 添加生意经验
- (void)addResumeExperience:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addResumeExperience WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 保存生意简历
- (void)saveBusinessResume:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_saveBusinessResume WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取生意简历场所信息
- (void)getBusinessResumePlace:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getBusinessResumePlace WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取生意简历意向信息
- (void)getBusinessResumeIntention:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getBusinessResumeIntention WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -	上传图片
- (void)SubmitImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestUploadImageWithParameters:postdic SendImageData:sendData FileName:filename ApiPath:
     HTJD_uploadImgPhoto WithHeader:nil onTarget:nil
                                              success:^(NSDictionary *result) {
//                                                  int flag = [[result objectForKey:@"flag"] intValue];
//                                                  if (flag == -1) {
//                                                      [self loginCancel:result];
//                                                  }else{
//                                                      success(result);
//                                                  }
                                                   success(result);
                                              } failure:^(NSError *error) {
                                                  errors(error);
                                              }];
}

#pragma mark - 根据关键词模糊查询企业名称，获取企业ID、名称信息列表
- (void)searchCompanySimpleDtosByCompanyName:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchCompanySimpleDtosByCompanyName WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 申请企业入驻
- (void)applyCompanyEntering:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_applyCompanyEntering WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 选择已入驻企业，开通企业功能
- (void)openCompanyFeature:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_openCompanyFeature WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 根据企业名称获取企业入驻状态
- (void)getCompanyStatusByName:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getCompanyStatusByName WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 获取项目列表
- (void)searchProjectDtos4App:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchProjectDtos4App WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取项目详情
- (void)getProjectDto4App:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getProjectDto4App WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 根据项目 ID  获取留言列表
- (void)searchProjectMessageDtos4Project:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchProjectMessageDtos4Project WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 取消收藏
- (void)cancelProjectCollect:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelProjectCollect WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -添加用户收藏项目
- (void)addProjectCollect:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addProjectCollect WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -新建留言
- (void)createProjectMessage:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_createProjectMessage WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -提交反馈信息
- (void)SubmitFeedbackResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_submitFeedback WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}



-(NSString *)opendUDID{
    return  [OpenUDID value];
}

#pragma mark -获取用户上过线的项目
- (void)getOnlineAndOfflineProjectDtoListByUserId:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getOnlineAndOfflineProjectDtoListByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -获取留言详情
- (void)getProjectMessageDto:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getProjectMessageDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -获取留言手机号
- (void)getMessageUserTel:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getMessageUserTel WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -添加或修改个人信息
- (void)saveSimpleBusinessResume:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_saveSimpleBusinessResume WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -获取个人信息
- (void)getSimpleBusinessResumeDto:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSimpleBusinessResumeDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -首页最新问题
- (void)searchLatestQuestionDtos:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
//    NSLog(@"postDic ------>%@",postdic);
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchLatestQuestionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -1.1.2    首页-热门
- (void)searchHotAnswerDtos:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchHotAnswerDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取标签 （读取首页标签或者读取搜索页推荐标签）
- (void)getTagDtoList:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getTagDtoList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           success(result);
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -首页-根据标签获取问题
- (void)searchQuestionDtosByTag:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchQuestionDtosByTag WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -首页-获取推荐专家
- (void)recommendExpert:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_recommendExpert WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -提问
- (void)askQuestion:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_askQuestion WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -添加标签
- (void)addTag:(NSDictionary *)dataDic
viewController:(UIViewController *)controller
   successData:(SuccessData)success
       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addTag WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 模糊搜索标签
- (void)getLikeTagDtoLike:(NSDictionary *)dataDic
viewController:(UIViewController *)controller
   successData:(SuccessData)success
       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getLikeTagDtoLike WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 问题详情
- (void)getQuestionDetail:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getQuestionDetail WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                            success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取问题下的答案列表
- (void)searchAnswerDtosByQuestionId:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchAnswerDtosByQuestionId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 取消收藏问题
- (void)cancelCollectQuestion:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors{
    
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelCollectQuestion WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 收藏问题
- (void)collectQuestion:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors{
    
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_collectQuestion WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 获取专家列表
- (void)searchExpert:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors{
    
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchExpert WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  邀请专家回答
- (void)inviteAnswer:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_inviteAnswer WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 回答问题 提交
- (void)answerQuestion:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_answerQuestion WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -问题所属标签列表
- (void)getTagDtoListByQuestionId:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors{
    
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getTagDtoListByQuestionId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -添加关注
- (void)addConnection:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors{
    
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addConnection WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -取消关注
- (void)cancelConnection:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors{
    
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelConnection WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 标签下的精品回答
- (void)searchBoutiqueAnswerQuestionDtos:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchBoutiqueAnswerQuestionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  获取相关项目
- (void)searchOnlinProjectDtosByTagIdResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     searchOnlinProjectDtosByTagId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  收藏标签
- (void)collectTag:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_collectTag WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  取消收藏标签
- (void)cancelCollectTag:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelCollectTag WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -  个人主页获取 个人相关信息
- (void)getUserCHomePageDto:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUserCHomePageDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  个人主页获取项目列表
- (void)searchOnlinProjectDtosByUserId:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchOnlinProjectDtosByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                             success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  获取两个人的关注关系
- (void)getConnectionStatus:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getConnectionStatus WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}
#pragma mark -  某一个用户(其他人) 的 -----------获取-----答案列表
- (void)searchAnswerDtosByUserId:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchAnswerDtosByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -  获取答案列表 (我的)
- (void)searchMyAnswerDtos:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyAnswerDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -  个人主页 获取提问列表 (我的)
- (void)searchMyQuestionDtos:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyQuestionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -  某一个用户 的 提问列表
- (void)searchQuestionDtosByUserId:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchQuestionDtosByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -  获取未读系统消息的数量
- (void)getSysMsgUnReadCount:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSysMsgUnReadCount WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 系统消息置为已读
- (void)updateSysMsgToRead:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateSysMsgToRead WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 未读赞相关消息置为已读
- (void)updateDingToRead:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateDingToRead WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 未读的评论消息置为已读
- (void)updateCommentToRead:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateCommentToRead WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 获取列表里 各种未读选项里面的 未读消息 数量
- (void)getUnReadCountDto:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUnReadCountDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -  获取系统消息列表
- (void)searchSysMsgDtos:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchSysMsgDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  收到的评论列表
- (void)searchCommentDtosByUserId:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchCommentDtosByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  收到的赞列表
- (void)searchDingDtosByUserId:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchDingDtosByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  我的粉丝列表
- (void)searchMyFansConnectionDtos:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyFansConnectionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  他的粉丝列表
- (void)searchHisFansConnectionDtos:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchHisFansConnectionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  查看我的关注列表
- (void)searchMyAttentionConnectionDtos:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyAttentionConnectionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  查看他的关注列表
- (void)searchHisAttentionConnectionDtos:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchHisAttentionConnectionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  收藏问题
- (void)searchQuestionDtosCollection:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchQuestionDtosCollection WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  收藏答案
- (void)searchCollectionAnswerDtosByUserId:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchCollectionAnswerDtosByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  收藏项目
- (void)searchCollectionProjectDtosByUserId4App:(NSDictionary *)dataDic
                            viewController:(UIViewController *)controller
                               successData:(SuccessData)success
                                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchCollectionProjectDtosByUserId4App WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  收藏标签
- (void)searchCollectionTagDtosByUserId:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success
                                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchCollectionTagDtosByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -  模糊搜索问题
- (void)searchLikeQuestionDtos:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchLikeQuestionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];

}

#pragma mark -  获取热门搜索项目
- (void)searcHotSearchProjectDtoList:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searcHotSearchProjectDtoList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  搜索用户
- (void)searchUserCSimpleInfoDtos:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchUserCSimpleInfoDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -  删除问题
- (void)deleteQuestion:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_deleteQuestion WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -    标签详情
- (void)getTagDto:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getTagDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -    分享问题
- (void)addShareCount:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addShareCount WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -    分享答案
- (void)shareAnswer:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_shareAnswer WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -    答案详情
- (void)getAnswerDetail:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getAnswerDetail WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获未认证项目数量
- (void)getAnauthorizedProjectCount:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getAnauthorizedProjectCount WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -    获取用户是否显示推荐标签页面
- (void)getChooseTagsFlag:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getChooseTagsFlag WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -    获取推荐关注标签
- (void)searchTagDtosByRecommend:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchTagDtosByRecommend WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -    跳过推荐关注标签页
- (void)skipTagsFlag:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_skipTagsFlag WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}
#pragma mark -    收藏多个标签
- (void)collectTags:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_collectTags WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}
#pragma mark - 4.5.13    检查产品版本更新
- (void)getVersionInfo:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
               failuer:(ErrorData)errors{
    
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_getVersionInfo WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                            success(result);
//                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           if (flag == -1) {
//                                               [self loginCancel:result];
//                                           }else{
//                                               success(result);
//                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -创建老板项目
- (void)createProject4Boss:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_createProject4Boss WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -编辑老板项目
- (void)updateProject4Boss:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateProject4Boss WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -老板入驻
- (void)applyBossEntering:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_applyBossEntering WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取老板列表
- (void)searchBossProjectDtos:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchBossProjectDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 根据登录用户 ID 获取老板项目信息
- (void)getBossProjectDtoByUserId:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors{
     NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getBossProjectDtoByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

//#pragma mark - 根据用户 ID 获取上线老板项目信息
//- (void)getOnlineBossProjectDtoByUserId:(NSDictionary *)dataDic
//                         viewController:(UIViewController *)controller
//                            successData:(SuccessData)success
//                                failuer:(ErrorData)errors{
//    NSDictionary *postdic = [self AddPublicParams:dataDic];
//    [kNetWorkManager requestPostWithParameters:postdic
//                                       ApiPath:
//     HTJD_getOnlineBossProjectDtoByUserId WithHeader:nil onTarget:nil
//                                       success:^(NSDictionary *result) {
//                                           success(result);
//                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
//                                           //                                           if (flag == -1) {
//                                           //                                               [self loginCancel:result];
//                                           //                                           }else{
//                                           //                                               success(result);
//                                           //                                           }
//                                       } failure:^(NSError *error) {
//                                           errors(error);
//                                       }];
//}

#pragma mark - 根据用户 ID 获取项目数量
- (void)getProjectCountByUserId:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getProjectCountByUserId WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}




#pragma mark - 保存融云会话用户记录
- (void)saveImUser:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_saveImUser WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 根据一个或多个用户ID混淆串拼接的字符串，查询并返回用户基本信息
- (void)searchUserCListDtoByUserIds:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchUserCListDtoByUserIds WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 看过我的
- (void)searchUserViews:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchUserViews WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 添加查看关系
- (void)saveUserView:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_saveUserView WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取融云App Key
- (void)getRongcloudAppKey:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getRongcloudAppKey WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 看过我的数量
- (void)countUserViewNum:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_countUserViewNum WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result) {
                                           success(result);
                                           //                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           //                                           if (flag == -1) {
                                           //                                               [self loginCancel:result];
                                           //                                           }else{
                                           //                                               success(result);
                                           //                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}
#pragma mark - 错误提示语言
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller{
    if ([results isKindOfClass:[NSNull class]]) {
        return;
    }
    //    [controller.view makeToast:results duration:2.0 position:@"bottom"];
    [controller.view makeToast:results duration:2.8 position:@"center"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    return;
}

- (void)tipAlert:(NSString *)results{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:results
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}

//弹出错误提示
- (void)resultFail:(NSDictionary *)result WithController:(UIViewController *)controller{
    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
        NSString *info =  [result objectForKey:@"msg"];
        [self tipAlert:info viewController:controller];
    }
}

//弹出错误提示
- (void)resultFail:(NSDictionary *)result  viewController:(UIViewController *)controller{
    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
        NSString *info =  [result objectForKey:@"msg"];
        [self tipAlert:info viewController:controller];
    }
}


@end
