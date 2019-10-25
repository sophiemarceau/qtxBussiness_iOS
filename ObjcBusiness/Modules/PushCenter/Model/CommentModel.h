//
//  CommentModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//
#import "BaseModel.h"

@interface CommentModel : BaseModel
@property (nonatomic, copy, readonly) NSString *identifier;

//@property (nonatomic, assign) NSInteger isHotModelflag;//是否是热门列表的model
@property (nonatomic, assign) NSInteger answer_id;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString *headURLStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *jobStr;
@property (nonatomic, strong) NSString *companyStr;
@property (nonatomic, strong) NSString *commentFromStr;
@property (nonatomic, strong) NSString *replyStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) NSInteger answer_is_anonymous;
@property (nonatomic, strong) NSString *c_expert_profiles;
@property (nonatomic, strong) NSString *c_profiles;
@property (nonatomic, assign) NSInteger userPosition_code;

@property (nonatomic, strong) NSDictionary *userCSimpleInfoDto;
-(instancetype) initWithDict:(NSDictionary *)dict;

+(instancetype) logisticsWithDict:(NSDictionary *)dict;

@end
