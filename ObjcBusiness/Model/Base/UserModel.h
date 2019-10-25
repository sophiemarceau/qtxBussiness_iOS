//
//  UserModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/7/27.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface UserModel : NSObject
//MTLModel <MTLJSONSerializing>
@property (nonatomic,copy)NSString *qtxsy_auth;
@property (nonatomic,copy)NSString *openId;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *userToken;
@property (nonatomic,copy)NSString *userHeadUrl;
@property (nonatomic,copy)NSString *user_kind;//用户类型（1，普通用户；2，企业用户；3，平台运营）；
@end
