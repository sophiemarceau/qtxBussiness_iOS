//
//  ConversantionUserInfo.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/22.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ConversantionUserInfo : RCUserInfo

@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *user_id_str;//用户ID混淆字符串；
@property(nonatomic,strong)NSString *c_photo;//用户头像；
@property(nonatomic,strong)NSString *c_name;//用户昵称或真实姓名（老板入驻后返回真实姓名）；
@property(nonatomic,strong)NSString *c_short_company_name;//企业简称（老板入驻后返回）；
@property(nonatomic,strong)NSString *c_jobtitle;//用户在企业供职的职位名称（老板入驻后返回）；
@end
