//
//  DBHelper.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/7/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouQuUserInfo.h"
#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
@interface DBHelper : NSObject

+ (DBHelper *)shareInstance;

- (void)closeDBForDisconnect;

//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user;

//从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId;

//从表中获取所有用户信息
//- (NSArray *)getAllUserInfo;

//从表中获取某个好友的信息
//- (YouQuUserInfo *)getFriendInfo:(NSString *)friendId;

//清空好友缓存数据
//- (void)clearFriendsData;


@end
