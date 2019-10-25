//
//  LoginModel.h
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"



@interface LoginModel : BaseModel
@property (nonatomic,strong) NSString *qtxsy_auth;
@property (nonatomic,strong) NSString *userKind;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *user_id_str;

@end
