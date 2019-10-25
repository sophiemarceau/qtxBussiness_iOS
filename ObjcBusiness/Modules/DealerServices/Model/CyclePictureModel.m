//
//  CyclePictureModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/22.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CyclePictureModel.h"

@implementation CyclePictureModel

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
