//
//  PersonalVIewModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PersonalVIewModel.h"

@implementation PersonalVIewModel
- (void)saveUserInformation:(NSDictionary *)dic{

    [[RequestManager shareRequestManager] UpdateUserInfoResult:dic viewController:nil successData:^(NSDictionary *result) {

        ResopnseFlagState flag;
        if(IsSucess(result) == 1){
            flag = ResponseSuccess;
        }else{
            flag = ResponseFailure;
        }
        self.returnBlock(result,flag,@"saveUserInformation");
        
    } failuer:^(NSError *error) {
        
    }];
}
@end
