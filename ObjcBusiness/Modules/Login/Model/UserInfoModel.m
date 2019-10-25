//
//  UserInfoModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/5.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"responseFlagState": @"flag",
             @"msg": @"msg",
             @"userNickName":@"data.result.c_nickname",
             @"userId":@"data.result.user_id" ,
             @"userPortraitUri":@"data.result.c_photo"
             };
}




+ (NSValueTransformer *)responseFlagStateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @(1): @(ReturnSuccess),
                                                                           @(0): @(ReturnFailure)
                                                                           }];
}



+ (NSValueTransformer *)userIdJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value,BOOL *success, NSError*__autoreleasing *error) {
        
        NSNumber *num = value;
        
        NSString *tempStr = [NSString stringWithFormat:@"%@", num];
        
        return tempStr;
        
    } reverseBlock:^id(id value,BOOL *success, NSError *__autoreleasing *error) {
        
        NSString *tempStr = value;
        
        NSNumber *tempNum = @(tempStr.integerValue);
        
        return tempNum;
        
    }];
    
}

+ (NSValueTransformer *)userKindJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value,BOOL *success, NSError*__autoreleasing *error) {
        
        NSNumber *num = value;
        
        NSString *tempStr = [NSString stringWithFormat:@"%@", num];
        
        return tempStr;
        
    } reverseBlock:^id(id value,BOOL *success, NSError *__autoreleasing *error) {
        
        NSString *tempStr = value;
        
        NSNumber *tempNum = @(tempStr.integerValue);
        
        return tempNum;
        
    }];
    
}
@end
