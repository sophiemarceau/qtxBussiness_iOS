//
//  BaseModel.h
//  YourBusiness
//
//  Created by sophiemarceau_qu on 2017/7/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"



/*
 1.获取 model 的属性--> JSONKeyPath 映射字典
 2.获取 model 的属性列表
 3.根据 model 的方法给网络请求中返回的 JSON 字典中的 value 做值类型转化操作
 4.使用 KVC 把值赋给 model 的属性，完成操作
 */
typedef NS_ENUM(NSInteger, ReturnFlagState) {
    ReturnFailure,
    ReturnSuccess,
};

@interface BaseModel : MTLModel <MTLJSONSerializing>
//- (instancetype) initWithDictionary: (NSDictionary *)dict;
@property (nonatomic, assign, readonly) ReturnFlagState responseFlagState;
@property (nonatomic, copy) NSString *msg;
@end
