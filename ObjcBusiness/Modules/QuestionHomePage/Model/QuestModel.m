//
//  QuestModel.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/14.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestModel.h"

@implementation QuestModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = super.init;
    if (self) {
        
        
        self.titleStr = dict[@"question_content"];
        self.nameStr = dict[@"c_nickname"];
        self.answer_id = [dict[@"answer_id"] integerValue];
        self.user_id = [dict[@"user_id"] integerValue];
        
        self.answer_is_anonymous  = [dict[@"answer_is_anonymous"] integerValue];
        if (dict[@"answer_id"] == nil) {
            self.answer_id = [dict[@"answer_id_show"] integerValue];
        }
        NSDictionary *answerDto = dict[@"answerDto"];
        if (answerDto == nil) {
            self.commentStr = dict[@"answe_comment_count"];
            self.dingStr= dict[@"answer_ding_count"];
            self.questionStr = dict[@"answer_content"];
            
            id userDTO = dict[@"userCSimpleInfoDto"];
            if(userDTO == nil){
                self.userCSimpleInfoDto = nil;
            }else{
                self.userCSimpleInfoDto = dict[@"userCSimpleInfoDto"];
            }
            self.headURLStr = dict[@"userCSimpleInfoDto"][@"c_photo"];
            self.jobStr = dict[@"userCSimpleInfoDto"][@"c_jobtitle"];
            self.companyStr = dict[@"userCSimpleInfoDto"][@"company_name"];
            self.c_profiles = dict[@"userCSimpleInfoDto"][@"c_profiles"];
            self.c_expert_profiles = dict[@"userCSimpleInfoDto"][@"c_expert_profiles"];
            self.userPosition_code = [dict[@"userCSimpleInfoDto"][@"userPosition_code"] integerValue];
        }else{
            self.commentStr = answerDto[@"answe_comment_count"];
            self.dingStr= answerDto[@"answer_ding_count"];
            self.questionStr = answerDto[@"answer_content"];
            
            
            id userDTO = answerDto[@"userCSimpleInfoDto"];
            if(userDTO == nil){
                self.userCSimpleInfoDto = nil;
            }else{
                self.userCSimpleInfoDto = answerDto[@"userCSimpleInfoDto"];
            }
            self.headURLStr = answerDto[@"userCSimpleInfoDto"][@"c_photo"];
            self.jobStr = answerDto[@"userCSimpleInfoDto"][@"c_jobtitle"];
            self.companyStr = answerDto[@"userCSimpleInfoDto"][@"company_name"];
            self.c_profiles = answerDto[@"userCSimpleInfoDto"][@"c_profiles"];
            self.c_expert_profiles = answerDto[@"userCSimpleInfoDto"][@"c_expert_profiles"];
            self.userPosition_code = [answerDto[@"userCSimpleInfoDto"][@"userPosition_code"] integerValue];
        }

    }
    return self;
}

//他人主页里面的 获取数据需要的解析 
-(instancetype) initWithDictionary:(NSDictionary *)dict{
    self = super.init;
    if (self) {
        NSLog(@"QuestModel----initWithDictionary----->%@",dict);
        NSDictionary *questionDto = dict[@"questionDto"];
        
        
        self.titleStr = questionDto[@"question_content"];
        self.nameStr = dict[@"c_nickname"];
        self.answer_id = [dict[@"answer_id"] integerValue];
        self.user_id = [dict[@"user_id"] integerValue];
        
        self.commentStr = dict[@"answe_comment_count"];
        self.dingStr =dict[@"answer_ding_count"];
        self.questionStr = dict[@"answer_content"];
        self.answer_is_anonymous  = [dict[@"answer_is_anonymous"] integerValue];
        id userDTO = dict[@"userCSimpleInfoDto"];
        if(userDTO == nil){
            self.userCSimpleInfoDto = nil;
        }else{
            self.userCSimpleInfoDto = dict[@"userCSimpleInfoDto"];
        }
        self.headURLStr = dict[@"userCSimpleInfoDto"][@"c_photo"];
        self.jobStr = dict[@"userCSimpleInfoDto"][@"c_jobtitle"];
        self.companyStr = dict[@"userCSimpleInfoDto"][@"company_name"];
        self.c_profiles = dict[@"userCSimpleInfoDto"][@"c_profiles"];
        self.c_expert_profiles = dict[@"userCSimpleInfoDto"][@"c_expert_profiles"];
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
