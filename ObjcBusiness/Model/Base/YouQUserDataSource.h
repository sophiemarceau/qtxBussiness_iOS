//
//  YouQUserDataSource.h
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/21.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

#define YouQuDataSource [YouQUserDataSource shareInstance]

@interface YouQUserDataSource : NSObject <RCIMUserInfoDataSource>


+ (YouQUserDataSource *)shareInstance;



@end
