//
//  MineViewModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MineViewModel.h"
#import "MineModel.h"
#import "Mantle.h"
#import <RongIMKit/RongIMKit.h>
@implementation MineViewModel

//-(void)isPerfectBusinessResume{
//    
//    NSDictionary *dic = @{@"qtxsy_auth":[DEFAULTS objectForKey:@"qtxsy_auth"]};
//    [[RequestManager shareRequestManager] isPerfectBusinessResume:dic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"result----isPerfectBusinessResume--------->%@",result);
//        
////        NSError *errorMTL ;
////        UserInfoModel *returnObject = [MTLJSONAdapter modelOfClass:UserInfoModel.class fromJSONDictionary:result error:&errorMTL];
//        ResopnseFlagState flag;
//        if(IsSucess(result)){
//            flag = ResponseSuccess;
//            self.returnBlock(result[@"data"], flag,@"isPerfectBusinessResume");
//        }else{
//            flag = ResponseFailure;
//        }
////        if(![errorMTL isEqual:[NSNull null]]) {
////             self.returnBlock(returnObject, flag,@"getUserInfoTOMineView");
////        }else {
////            NSLog(@"errorMTL----GetGetRongYunTokenResult---->%@",errorMTL);
////        }
//    } failuer:^(NSError *error) {
//        
//    }];
//}
//-(void)getManyNumbersToClientView{
//    NSDictionary *dic = @{@"qtxsy_auth":[DEFAULTS objectForKey:@"qtxsy_auth"]};
//    [[RequestManager shareRequestManager] GetAllKindsOfNumbersClientInfoResult:dic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"result----GetAllKindsOfNumbersClientInfoResult ---->%@",result);
//
//        NSError *errorMTL ;
//        MineModel *returnObject = [MTLJSONAdapter modelOfClass:MineModel.class fromJSONDictionary:result error:&errorMTL];
//        ResopnseFlagState flag;
//        if(IsSucess(result)){
//            flag = ResponseSuccess;
//        }else{
//            flag = ResponseFailure;
//        }
//        if(![errorMTL isEqual:[NSNull null]]) {
//            self.returnBlock(returnObject, flag,@"getManyNumbersToClientView");
//        }else {
//            NSLog(@"errorMTL-------->%@",errorMTL);
//        }
//    } failuer:^(NSError *error) {
//
//    }];
//}

//-(void)getManyNumbersToEnterpirseView{
//    NSDictionary *dic = @{@"qtxsy_auth":[DEFAULTS objectForKey:@"qtxsy_auth"]};
//    [[RequestManager shareRequestManager] GetAllKindsOfNumbersEnterpriseInfoResult:dic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"result----getManyNumbersToEnterpirseView ---->%@",result);
//
//        NSError *errorMTL ;
//        MineModel *returnObject = [MTLJSONAdapter modelOfClass:MineModel.class fromJSONDictionary:result error:&errorMTL];
//        ResopnseFlagState flag;
//        if(IsSucess(result)){
//            flag = ResponseSuccess;
//        }else{
//            flag = ResponseFailure;
//        }
//        if(![errorMTL isEqual:[NSNull null]]) {
//            self.returnBlock(returnObject, flag,@"getManyNumbersToEnterpirseView");
//        }else {
//            NSLog(@"errorMTL-------->%@",errorMTL);
//        }
//    } failuer:^(NSError *error) {
//
//    }];
//}
@end
