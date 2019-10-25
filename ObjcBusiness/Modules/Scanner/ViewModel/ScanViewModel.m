//
//  ScanViewModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ScanViewModel.h"

@implementation ScanViewModel
- (void)scanQRCodepush:(NSDictionary *)dataDic{
    [[RequestManager shareRequestManager] confirmLoginByQRcode4APPRequest:dataDic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"result---confirmLoginByQRcode4APPRequest---%@",result);
//        NSError *errorMTL ;
//        id returnObject = [MTLJSONAdapter modelOfClass:LoginModel.class
//                                    fromJSONDictionary:result error:&errorMTL];
//        
//        ResopnseFlagState flag;
//        if(IsSucess(result)){
//            flag = ResponseSuccess;
//        }else{
//            flag = ResponseFailure;
//        }
//        if(![errorMTL isEqual:[NSNull null]]) {
//            //            self.returnBlock(returnObject, flag,@"LoginUserRequest");
//            //            [self loginSuccess:@"" userId:@"" token:@""];
//            
//            
//        }else {
//            //            NSLog(@"errorMTL-------->%@",errorMTL);
//        }
        
    } failuer:^(NSError *error) {
        
    }];

}
@end
