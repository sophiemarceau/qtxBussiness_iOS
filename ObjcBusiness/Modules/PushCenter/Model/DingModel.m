//
//  DingModel.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/31.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DingModel.h"

@implementation DingModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = super.init;
    if (self) {
        
        self.timeStr = dict[@"ding_createdtime"];
        self.commentFromStr = dict[@"dingContent"];
        self.answer_id = [dict[@"answer_id"] integerValue];
        id userDTO = dict[@"userCSimpleInfoDto"];
        if(userDTO == nil){
            self.userCSimpleInfoDto = nil;
        }else{
            self.userCSimpleInfoDto = dict[@"userCSimpleInfoDto"];
        }
        self.answer_is_anonymous = [dict[@"answer_is_anonymous"] integerValue];
        self.user_id = [dict[@"user_id"]integerValue];
        self.ding_obj_kind_code = [dict[@"ding_obj_kind_code"]integerValue];
        self.nameStr = dict[@"userCSimpleInfoDto"][@"c_nickname"];
        self.headURLStr = dict[@"userCSimpleInfoDto"][@"c_photo"];
        self.jobStr = dict[@"userCSimpleInfoDto"][@"c_jobtitle"];
        self.companyStr = dict[@"userCSimpleInfoDto"][@"company_name"];
        self.c_expert_profiles = dict[@"userCSimpleInfoDto"][@"c_expert_profiles"];
        self.c_profiles = dict[@"userCSimpleInfoDto"][@"c_profiles"];
        self.userPosition_code = [dict[@"userCSimpleInfoDto"][@"userPosition_code"] integerValue];
        
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}

+(instancetype)logisticsWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
