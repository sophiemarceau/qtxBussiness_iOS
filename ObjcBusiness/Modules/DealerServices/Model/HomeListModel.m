//
//  HomeListModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "HomeListModel.h"

@implementation HomeListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"responseFlagState": @"flag",
             @"msg": @"msg",
             
             };
}

+ (NSValueTransformer *)responseFlagStateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @(1): @(ReturnSuccess),
                                                                           @(0): @(ReturnFailure)
                                                                           }];
}
@end
