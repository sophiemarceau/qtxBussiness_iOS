//
//  NewQuestionModel.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "NewQuestionModel.h"

@implementation NewQuestionModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.titleStr = dict[@"question_content"];
        self.questionStr = dict[@"answerDto"][@"answer_content"];
        self.collectionNumStr= dict[@"question_collect_count"];
        self.questionNumStr= dict[@"question_answer_count"];
        self.question_id = [dict[@"question_id"] integerValue];
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
