//
//  ServiceViewModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/2.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ServiceViewModel.h"

#import "Mantle.h"


@implementation ServiceViewModel
- (void)cyclleViewList{
    
    [[RequestManager shareRequestManager] SearchAdDtoListResult:nil viewController:nil successData:^(NSDictionary *result) {
        NSError *errorMTL ;
        id returnObject = [MTLJSONAdapter modelOfClass:CyclePictureModel.class
                  fromJSONDictionary:result error:&errorMTL];
        ResopnseFlagState flag;
        if(IsSucess(result) == 1){
             flag = ResponseSuccess;
        }else{
             flag = ResponseFailure;
        }
        if(![errorMTL isEqual:[NSNull null]]) {
            self.returnBlock(returnObject, flag,@"SearchAdDtoListResult");
        }else {
//            NSLog(@"errorMTL----->%@",errorMTL);
        }
    } failuer:^(NSError *error) {
        
        self.errorBlock(error,@"SearchAdDtoListResult");
    }];
}

- (void)getServiceList{
    [[RequestManager shareRequestManager] SearchPromotingProjectsResult:nil viewController:nil successData:^(NSDictionary *result) {
        NSError *errorMTL ;
        id returnObject = [MTLJSONAdapter modelOfClass:CyclePictureModel.class
                                    fromJSONDictionary:result error:&errorMTL];
        ResopnseFlagState flag;
        if(IsSucess(result) == 1){
            flag = ResponseSuccess;
        }else{
            flag = ResponseFailure;
        }
        if(![errorMTL isEqual:[NSNull null]]) {
            self.returnBlock(returnObject, flag,@"SearchPromotingProjectsResult");
        }else {
//            NSLog(@"errorMTL----->%@",errorMTL);
        }
    } failuer:^(NSError *error) {
        
        self.errorBlock(error,@"SearchPromotingProjectsResult");
    }];
}

@end
