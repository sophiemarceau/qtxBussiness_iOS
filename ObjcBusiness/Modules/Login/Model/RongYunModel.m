//
//  RongYunModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/5.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "RongYunModel.h"

@implementation RongYunModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"responseFlagState": @"flag",
             @"msg": @"msg",
             @"rongyuntoken":@"data.result",
             };
}

+ (NSValueTransformer *)responseFlagStateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @(1): @(ReturnSuccess),
                                                                           @(0): @(ReturnFailure),
                                                                           
                                                                           }];
}

@end
