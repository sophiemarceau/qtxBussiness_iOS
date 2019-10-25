//
//  NewQuestionModel.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseModel.h"

@interface NewQuestionModel : BaseModel

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *questionStr;
@property (nonatomic, strong) NSString *questionNumStr;
@property (nonatomic, strong) NSString *collectionNumStr;
@property (nonatomic, assign) NSInteger question_id;
-(instancetype) initWithDict:(NSDictionary *)dict;

+(instancetype) logisticsWithDict:(NSDictionary *)dict;

@end

