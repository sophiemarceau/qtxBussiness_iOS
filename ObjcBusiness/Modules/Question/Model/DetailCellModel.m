//
//  DetailCellModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DetailCellModel.h"

@implementation DetailCellModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        self.answer_id = [dictionary[@"answer_id"] integerValue];
        self.nameStr = dictionary[@"c_nickname"];
        self.questionStr = dictionary[@"answer_content"];
        self.timeStr = dictionary[@"answer_createdtime"];
        self.commentStr = dictionary[@"answe_comment_count"];
        self.dingStr= dictionary[@"answer_ding_count"];
        self.answer_is_anonymous = [dictionary[@"answer_is_anonymous"] integerValue];
        id userDTO = dictionary[@"userCSimpleInfoDto"];
        if(userDTO == nil){
            self.userCSimpleInfoDto = nil;
        }else{
            self.userCSimpleInfoDto = dictionary[@"userCSimpleInfoDto"];
        }
        
        self.headURLStr = dictionary[@"userCSimpleInfoDto"][@"c_photo"];
        self.jobStr =  dictionary[@"userCSimpleInfoDto"][@"c_jobtitle"];
        self.user_id = [dictionary[@"user_id"] integerValue];
        self.companyStr = dictionary[@"userCSimpleInfoDto"][@"company_name"];
        self.c_profiles = dictionary[@"userCSimpleInfoDto"][@"c_profiles"];
        self.c_expert_profiles = dictionary[@"userCSimpleInfoDto"][@"c_expert_profiles"];
        self.userPosition_code = [dictionary[@"userCSimpleInfoDto"][@"userPosition_code"] integerValue];
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
    return [[self alloc] initWithDictionary:dict];
}
@end
