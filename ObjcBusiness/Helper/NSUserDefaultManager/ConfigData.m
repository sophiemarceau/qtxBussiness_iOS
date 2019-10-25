//
//  ConfigData.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/10/17.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "ConfigData.h"

@implementation ConfigData

+ (instancetype)sharedInstance
{
    static ConfigData *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ConfigData alloc] init];
    });
    return instance;
}

- (BOOL)isFirstLaunch
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
//    NSString *flag = [defaults objectForKey:IS_UPDATE_VERSION];
//    NSLog(@"lastRunVersion------>%@",lastRunVersion);
//    NSLog(@"currentVersion------>%@",currentVersion);
    if (!lastRunVersion) {
        [defaults setValue:@"0" forKey:IS_UPDATE_VERSION];
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults synchronize];
        return YES;
        
    }else if (![lastRunVersion isEqualToString:currentVersion]) {
//        [defaults setBool:YES forKey:IS_UPDATE_VERSION];
//        [defaults setInteger:1 forKey:IS_UPDATE_VERSION];
        [defaults setValue:@"1" forKey:IS_UPDATE_VERSION];
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults synchronize];
        return YES;
        
    }
    [defaults setValue:@"0" forKey:IS_UPDATE_VERSION];
    [defaults synchronize];
//     NSLog(@"lastRunVersion--->%@",flag);
    return NO;
}

@end
