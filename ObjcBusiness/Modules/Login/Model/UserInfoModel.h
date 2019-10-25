//
//  UserInfoModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/5.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *userNickName;

@property (nonatomic,strong) NSString *userPortraitUri;


@end
