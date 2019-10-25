//
//  QuestModel.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/14.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseModel.h"

@interface QuestModel : BaseModel

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, assign) NSInteger isHotModelflag;//是否是热门列表的model
@property (nonatomic, assign) NSInteger answer_id;
@property (nonatomic, assign) NSInteger question_id;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *headURLStr;
@property (nonatomic, strong) NSString *jobStr;
@property (nonatomic, strong) NSString *companyStr;
@property (nonatomic, strong) NSString *questionStr;
@property (nonatomic, strong) NSString *commentStr;
@property (nonatomic, strong) NSString *dingStr;

@property (nonatomic, strong) NSString *c_expert_profiles;
@property (nonatomic, strong) NSString *c_profiles;
@property (nonatomic, assign) NSInteger userPosition_code;


@property (nonatomic, assign) NSInteger answer_is_anonymous;

@property (nonatomic, strong) NSDictionary *userCSimpleInfoDto;
-(instancetype) initWithDict:(NSDictionary *)dict;
-(instancetype) initWithDictionary:(NSDictionary *)dict;
+(instancetype) logisticsWithDict:(NSDictionary *)dict;

@end
