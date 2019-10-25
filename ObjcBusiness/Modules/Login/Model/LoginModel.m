//
//  LoginModel.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"responseFlagState": @"flag",
             @"msg":@"msg",
             @"qtxsy_auth": @"data.qtxsy_auth",
             @"userId":@"data.user_id" ,
             @"userKind":@"data.user_kind",
             @"user_id_str":@"data.user_id_str"
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
//
//+ (NSValueTransformer *)portraitUriJSONTransformer {
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}
@end
