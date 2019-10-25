//
//  YouQUserDataSource.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/21.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "YouQUserDataSource.h"
#import "ConversantionUserInfo.h"
@implementation YouQUserDataSource


+ (YouQUserDataSource *)shareInstance {
    static YouQUserDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
        //1根据userID从 读取手机本地APP是否有有相关数据
        //2app缓存里面读取如果没有则根据userID从app的server服务器里面读取 相关用户信息 比如username userid userhead
        //然后completion（RCUserInfo）
    
//     NSLog(@"getUserInfoWithUserId --currentUserInfo--- %@", [RCIM sharedRCIM].currentUserInfo.userId);
//    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    NSDictionary *dic = @{ @"user_id_strs":userId, };
    [[RequestManager shareRequestManager] searchUserCListDtoByUserIds:dic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"searchUserCListDtoByUserIds--rcConversationListTableView---->%@",result);
        if (IsSucess(result) == 1) {
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            if(array != nil){
                NSDictionary *resultDic = array[0];
                ConversantionUserInfo *rcduserinfo_ = [ConversantionUserInfo new];
                rcduserinfo_.portraitUri = resultDic[@"c_photo"];
                rcduserinfo_.name = resultDic[@"c_name"];
                rcduserinfo_.c_name =  resultDic[@"c_name"];
                rcduserinfo_.userId = [NSString stringWithFormat:@"%d",[resultDic[@"user_id"] intValue]];
                rcduserinfo_.user_id_str = resultDic[@"user_id_str"];
                rcduserinfo_.c_photo = resultDic[@"c_photo"];
                NSString *companyStr = resultDic[@"c_short_company_name"];
                NSString *jobStr = resultDic[@"c_jobtitle"];
                if( companyStr== nil){
                    rcduserinfo_.c_short_company_name = @"";
                }else{
                    rcduserinfo_.c_short_company_name = companyStr;
                }
                if (jobStr== nil){
                    rcduserinfo_.c_jobtitle = @"";
                }else{
                    rcduserinfo_.c_jobtitle = jobStr;
                }
                completion(rcduserinfo_);
            }
        }
        //                else{
        //                if (IsSucess(result) == -1) {
        //                    [[RequestManager shareRequestManager] loginCancel:result];
        //                }else{
        //                    [[RequestManager shareRequestManager] resultFail:result viewController:nil];
        //                }
        //            }
    } failuer:^(NSError *error) {
    }];
    //开发者调自己的服务器接口根据userID异步请求数据
//    if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//         completion([RCIM sharedRCIM].currentUserInfo);
//    } else {
//
//    }


}
@end
