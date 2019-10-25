//
//  BossModel.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/12/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossModel.h"

@implementation BossModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.headStr = [NSString stringWithFormat:@"%@",dict[@"userCSimpleInfoDto"][@"c_photo"]];
        self.nameAndJobStr = [NSString stringWithFormat:@"%@ %@",dict[@"userCSimpleInfoDto"][@"c_short_company_name"],dict[@"userCSimpleInfoDto"][@"c_jobtitle"]];
        self.subStr = dict[@"userCSimpleInfoDto"][@"c_profiles"];
        self.locationStr = dict[@"userCSimpleInfoDto"][@"cAreaName"];
        self.tradeStr = dict[@"project_industry_name"];
        self.companyUrlStr = [NSString stringWithFormat:@"%@",dict[@"project_cover_pic"]];
        self.companyNameStr = dict[@"project_name"];
        self.companySubStr = dict[@"project_slogan"];
        self.bossFlag = [dict[@"userCSimpleInfoDto"][@"is_certification"] integerValue];
        self.officialFlag = [dict[@"project_authentication_code"] integerValue];
        self.bossID = [dict[@"user_id"] integerValue];
        self.user_id_str =  [NSString stringWithFormat:@"%@",dict[@"user_id_str"]];
        NSString *name = dict[@"userCSimpleInfoDto"][@"c_realname"];
        if (name == nil || [name isEqualToString:@""]) {
            self.bossName = @"";
        }else{
            self.bossName = [NSString stringWithFormat:@"%@",dict[@"userCSimpleInfoDto"][@"c_realname"]];
        }
        
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
