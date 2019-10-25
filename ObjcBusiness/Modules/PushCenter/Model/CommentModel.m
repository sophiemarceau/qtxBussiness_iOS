//
//  CommentModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = super.init;
    if (self) {
 

        self.answer_id = [dict[@"answer_id"] integerValue];
        
        self.timeStr = dict[@"comment_createdtime"];
        
        self.replyStr = dict[@"commentedContent"];
        self.commentFromStr = dict[@"comment_content"];
        
        self.answer_is_anonymous =  [dict[@"answer_is_anonymous"] integerValue];
        
        id userDTO = dict[@"userCSimpleInfoDto"];
        if(userDTO == nil){
            self.userCSimpleInfoDto = nil;
        }else{
            self.userCSimpleInfoDto = dict[@"userCSimpleInfoDto"];
        }
        self.nameStr = dict[@"userCSimpleInfoDto"][@"c_nickname"];
        self.headURLStr = dict[@"userCSimpleInfoDto"][@"c_photo"];
        self.jobStr = dict[@"userCSimpleInfoDto"][@"c_jobtitle"];
        self.companyStr = dict[@"userCSimpleInfoDto"][@"company_name"];
        self.c_expert_profiles = dict[@"userCSimpleInfoDto"][@"c_expert_profiles"];
        self.c_profiles = dict[@"userCSimpleInfoDto"][@"c_profiles"];
        self.user_id = [dict[@"user_id"] integerValue];
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
