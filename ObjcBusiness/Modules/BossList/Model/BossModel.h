//
//  BossModel.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/12/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseModel.h"

@interface BossModel : BaseModel
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong) NSString *user_id_str;
@property (nonatomic, strong) NSString *headStr;
@property (nonatomic, strong) NSString *nameAndJobStr;
@property (nonatomic, strong) NSString *subStr;
@property (nonatomic, strong) NSString *locationStr;
@property (nonatomic, strong) NSString *tradeStr;
@property (nonatomic, strong) NSString *companyUrlStr;
@property (nonatomic, strong) NSString *companyNameStr;
@property (nonatomic, strong) NSString *companySubStr;
@property (nonatomic, assign) NSInteger bossFlag;
@property (nonatomic, assign) NSInteger officialFlag;
@property (nonatomic, assign) NSInteger bossID;
@property (nonatomic, strong) NSString *bossName;
-(instancetype) initWithDict:(NSDictionary *)dict;

+(instancetype) logisticsWithDict:(NSDictionary *)dict;
@end
