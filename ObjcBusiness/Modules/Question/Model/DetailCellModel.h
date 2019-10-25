//
//  DetailCellModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseModel.h"

@interface DetailCellModel : BaseModel
@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *headURLStr;
@property (nonatomic, strong) NSString *jobStr;
@property (nonatomic, strong) NSString *companyStr;
@property (nonatomic, strong) NSString *questionStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *commentStr;
@property (nonatomic, strong) NSString *dingStr;

@property (nonatomic, strong) NSString *c_expert_profiles;
@property (nonatomic, strong) NSString *c_profiles;
@property (nonatomic, assign) NSInteger userPosition_code;
@property (nonatomic, strong) NSDictionary *userCSimpleInfoDto;
@property (nonatomic, assign) NSInteger answer_is_anonymous;

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger answer_id;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(instancetype) logisticsWithDict:(NSDictionary *)dict;
@end
