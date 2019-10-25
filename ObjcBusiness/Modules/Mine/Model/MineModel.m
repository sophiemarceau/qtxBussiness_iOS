//
//  MineModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"responseFlagState": @"flag",
             @"msg": @"msg",
             @"browseNum": @"data.dto.browseNum",
             @"collectNum":@"data.dto.collectNum" ,
             @"communicateNum":@"data.dto.communicateNum"
             };
}

+ (NSValueTransformer *)responseFlagStateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @(1): @(ReturnSuccess),
                                                                           @(0): @(ReturnFailure)
                                                                           }];
}

+ (NSValueTransformer *)browseNumJSONTransformer {
    
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

+ (NSValueTransformer *)collectNumJSONTransformer {
    
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
+ (NSValueTransformer *)communicateNumJSONTransformer {
    
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
