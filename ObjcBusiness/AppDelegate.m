//
//  AppDelegate.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/7/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import "YouQUserDataSource.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import "ConfigData.h"
#import "GuideViewController.h"
#import "SDLaunchViewController.h"
#import "BaseNavigationViewController.h"
#import "LoginModel.h"
#import "MessageCodeModel.h"
#import "RongYunModel.h"
#import "UserInfoModel.h"
#import "Mantle.h"
#import "DBHelper.h"
#import "AccountBindingViewController.h"
#import "MineViewController.h"
#import "SystemMessageViewController.h"
#import "QuestDetailViewController.h"
#import "BaseNavigationViewController.h"
#import "ProjectDetailViewController.h"
#import "QuestDetailViewController.h"
#import "AnswerDetailViewController.h"
#import "FansListViewController.h"
#import "GetDingListViewController.h"
#import "LeaveMessageDetailViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<UITabBarControllerDelegate,RCIMConnectionStatusDelegate,JPUSHRegisterDelegate>{
    NSString *userID;
    NSUInteger selectedIndex;
    int advitiesFlag;
    NSString *qtxsy_auth;
}
@property (nonatomic, strong) MainViewController *tabbarVC;
@property(nonatomic) int loginFailureTimes;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self getRongYunAPPKey];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    _loginFailureTimes = 0;
    //友盟数据统计 埋点
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK!
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:NO];
    /* 设置友盟社会化分享 appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    
    
   
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写,也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //2.1.9版本新增获取registration id block接口｡
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
//            NSLog(@"registrationID获取成功:%@",registrationID);
        }
        else{
//            NSLog(@"registrationID获取失败,code:%d",resCode);
        }
    }];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法,改成可上报IDFA,如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容,请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化｡
    [JPUSHService setupWithOption:launchOptions appKey:KJpushappKey
                          channel:KJpushchannel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BOOL firstLaunch =[[ConfigData sharedInstance] isFirstLaunch];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quit:) name:NOTIFICATION_NAME_USER_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startiOnclick) name:NOTIFICATION_NAME_QuitGuidePage object:nil];
    //第一次装机启动进入 引导页面
    if (firstLaunch) {
        [self _intoGuideViewController];
    }else{
        [self startiOnclick];
    }
    return YES;
}

//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    //6.3的新的API调用,是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响｡
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //6.3的新的API调用,是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * qtx_auth = [userDefaults objectForKey:@"qtx_auth"];
    if (qtx_auth) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCheckVersionInMainPage object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCheckVersionInMainPage object:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"willPresentNotification 收到远程通知:%@", [self logDic:userInfo]);
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法,选择是否提醒用户,有Badge､Sound､Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    //    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSString *ios_parameterStr = [userInfo valueForKey:@"ios_parameter"];
    //    NSNumber *badge = content.badge;  // 推送消息的角标
    //    NSString *body = content.body;    // 推送消息体
    //    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    //    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    //    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"didReceiveNotificationResponse 收到远程通知:%@", [self logDic:userInfo]);
//        NSLog(@"ios_parameterStr 收到远程通知:%@", ios_parameterStr);
        
        NSArray *pushWhereArray = [ios_parameterStr componentsSeparatedByString:@"_"];
        if (pushWhereArray != nil) {
            if (pushWhereArray.count == 2) {
                NSInteger flag = [pushWhereArray[0] integerValue];
                NSString *IDStr = [NSString stringWithFormat:@"%@",pushWhereArray[1]];
                [self gotoWhere:flag WithID:IDStr];
            }
        }
    }
    completionHandler();  // 系统要求执行这个方法
}

//        0     系统消息列表     N
//        1     问题详情        Y
//        2     答案详情        Y
//        3     项目留言详情     Y
//        4     粉丝列表        N
//        5     收到的赞列表     N
-(void)gotoWhere:(NSInteger)flag WithID:(NSString *)IDStr{
    //进入 系统消息
    if (flag == 0) {
        SystemMessageViewController *vc = [[SystemMessageViewController alloc] init];
        vc.title = @"系统消息";
        [self.tabbarVC.selectedViewController pushViewController:vc animated:YES];
    }
    //进入 问题详情
    if (flag == 1) {
        QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
        vc.title = @"问题详情";
        vc.question_id = [IDStr integerValue] ;
        [self.tabbarVC.selectedViewController pushViewController:vc animated:YES];
    }
    //进入 答案详情
    if (flag == 2) {
        AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
        vc.answer_id =  [IDStr integerValue] ;
        [self.tabbarVC.selectedViewController pushViewController:vc animated:YES];
    }
    //进入 项目留言详情
    if (flag == 3) {
        LeaveMessageDetailViewController *vc = [[LeaveMessageDetailViewController alloc] init];
        vc.message_id = [IDStr integerValue];
        [self.tabbarVC.selectedViewController pushViewController:vc animated:YES];
    }
    //进入 粉丝列表
    if (flag == 4) {
        FansListViewController   *vc = [[FansListViewController alloc] init];
        [self.tabbarVC.selectedViewController.navigationController pushViewController:vc animated:YES];
        
    }
    //进入 收到的赞列表
    if (flag == 5) {
        GetDingListViewController   *vc = [[GetDingListViewController alloc] init];
        vc.title = @"收到的赞";
        [self.tabbarVC.selectedViewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif


- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

//- (BOOL)IsAlreayLogin:(UITabBarController * _Nonnull)tabBarController {
//
//}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    NSLog(@"tabBarController-------select-------->%@",viewController.tabBarItem.title);
    if([viewController.tabBarItem.title isEqualToString:@"问答"]){
        
        return YES;
    }
    if([viewController.tabBarItem.title isEqualToString:@"直聊"]){
        return YES;
    }
    
    if([viewController.tabBarItem.title isEqualToString:@"消息"]){
//         [self IsAlreayLogin:tabBarController];
        userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (userID) {
            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                
                return YES;
            }else{
                //跳到登录页面
                AccountBindingViewController *login = [[AccountBindingViewController alloc] init];
                login.isModalButton = YES;
                BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
                 loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                //隐藏tabbar
                [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNav animated:YES completion:nil];
                //在登陆界面判断登陆成功之后发送通知,将所选的TabbarItem传回,使用通知传值
                [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_NAME_LOGINSELECT object:nil];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logSelect:) name:NOTIFICATION_NAME_LOGINSELECT object:nil];     //接收
                return NO;
            }
        }else{
            //跳到登录页面
            LoginViewController *login = [[LoginViewController alloc] init];
            login.isModalButton = YES;
            BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
             loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
            //隐藏tabbar
            [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNav animated:YES completion:nil];
            //在登陆界面判断登陆成功之后发送通知,将所选的TabbarItem传回,使用通知传值
            [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_NAME_LOGINSELECT object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logSelect:) name:NOTIFICATION_NAME_LOGINSELECT object:nil];     //接收
            return  NO;
        }
    }
    
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
//        [self IsAlreayLogin:tabBarController];
        userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (userID) {
            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                
                return YES;
            }else{
                //跳到登录页面
                AccountBindingViewController *login = [[AccountBindingViewController alloc] init];
                login.isModalButton = YES;
                BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
                 loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                //隐藏tabbar
                [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNav animated:YES completion:nil];
                //在登陆界面判断登陆成功之后发送通知,将所选的TabbarItem传回,使用通知传值
                [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_NAME_LOGINSELECT object:nil];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logSelect:) name:NOTIFICATION_NAME_LOGINSELECT object:nil];     //接收
                return NO;
            }
        }else{
            //跳到登录页面
            LoginViewController *login = [[LoginViewController alloc] init];
            login.isModalButton = YES;
            BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
             loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
            //隐藏tabbar
            [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNav animated:YES completion:nil];
            //在登陆界面判断登陆成功之后发送通知,将所选的TabbarItem传回,使用通知传值
            [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_NAME_LOGINSELECT object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logSelect:) name:NOTIFICATION_NAME_LOGINSELECT object:nil];     //接收
            return  NO;
        }
    }
    return NO;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{}

- (void)initMainViewController{
    self.window.rootViewController = self.tabbarVC;
}

#pragma mark - DB
- (void)initDB{
    
}

- (void)getRongYunAPPKey{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] getRongcloudAppKey:dic viewController:nil successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            NSString *IMappkeyStr = [[result objectForKey:@"data"] objectForKey:@"result"];
            if (IMappkeyStr != nil) {
//                NSLog(@"IMappkeyStr------>%@",IMappkeyStr);
                /* 设置融云IM appkey */
                [[RCIM sharedRCIM] initWithAppKey:IMappkeyStr];
                
                //设置会话列表头像和会话页面头像
                [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
                [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
                [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Error;
                
                //开启用户信息持久化
                [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
                
                //设置用户信息源和群组信息源
                [RCIM sharedRCIM].userInfoDataSource = YouQuDataSource;
                //登录融云server
                NSString *userRongYunServerToken = [DEFAULTS objectForKey:@"rongyuntoken"];
                userID = [DEFAULTS objectForKey:@"userId"];
                qtxsy_auth = [DEFAULTS objectForKey:@"qtxsy_auth"];
                NSString *userNickName = [DEFAULTS objectForKey:@"userNickName"];
                NSString *userPortraitUri = [DEFAULTS objectForKey:@"userPortraitUri"];
                
                RCUserInfo *_currentUserInfo = [[RCUserInfo alloc] initWithUserId:userID
                                                                             name:userNickName
                                                                         portrait:userPortraitUri];
                [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
                if(userRongYunServerToken == nil ||  userRongYunServerToken.length ==0){
                    [self removeDefaultData];
                }else{
                    if (userRongYunServerToken.length && userID.length) {
                        [self loginRongCloudtoken:userRongYunServerToken];
                    }
                }
            }
        }
    } failuer:^(NSError *error) {
        
    }];
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https,可允许http图片分享,但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppKey appSecret:kWechatAppSecret redirectURL:nil];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名,统一用appKey和appSecret进行参数设置,而QQ平台仅需将appID作为U-Share的appKey参数传进即可｡
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppKey/*设置QQ平台的appID*/  appSecret:@"eqZ3pMXq4JFe5dN3" redirectURL:kWechatAppSecretURL];
}

- (void)startiOnclick{
    _tabbarVC = [[MainViewController alloc] init];
    _tabbarVC.delegate = self;
    self.tabbarVC = _tabbarVC;
    if(!advitiesFlag) {
        advitiesFlag = TRUE;
        [self downLoadAdvertisement];
    }else{
        [self initMainViewController];
    }
}

- (void)loginRongCloudtoken:(NSString *)token{
    //登录融云服务器
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//         NSLog(@"connectWithToken------>%@",token);
//        NSLog(@"connectWithToken------>%@",userId);
        [self loginSuccesstoken:token userId:userId];
    }error:^(RCConnectErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"RCConnectErrorCode is %ld", (long)status);
             [[RCIMClient sharedRCIMClient] logout];
        });
    }tokenIncorrect:^{
        
        if (_loginFailureTimes < 1) {
            _loginFailureTimes++;
            NSDictionary *dic = @{@"qtxsy_auth":qtxsy_auth};
            [[RequestManager shareRequestManager] GetGetRongYunTokenResult:dic viewController:nil successData:^(NSDictionary *result) {
                if (IsSucess(result) == 1) {
                     [self loginRongCloudtoken:[result objectForKey:@"data"][@"result"]];
                }else {
                    
                }
            } failuer:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Token无效");
                    NSLog(@"无法连接到服务器!");
                });
            }];
        }
    }];
}

- (void)loginSuccesstoken:(NSString *)token userId:(NSString *)userId{
    //保存默认用户
    [DEFAULTS setObject:token forKey:@"rongyuntoken"];
    [DEFAULTS setObject:userId forKey:@"userId"];
    [DEFAULTS setObject:qtxsy_auth forKey:@"qtxsy_auth"];
    [DEFAULTS synchronize];
    NSString *user_id_str = [DEFAULTS objectForKey:@"user_id_str"];
    if (!user_id_str) {
        user_id_str  = @"";
    }
    NSDictionary *dic = @{
                          @"user_id_str":user_id_str,
                          @"_isReturnCompanyInfo":@"1",
                          @"_isReturnExt":@"1"
                          };
    [[RequestManager shareRequestManager] GetUserInfoResult:dic viewController:nil successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            NSDictionary *resultDic = [[result objectForKey:@"data"] objectForKey:@"result"];
            if (resultDic != nil) {
                NSString *nickname = [resultDic objectForKey:@"userNickName"];
                NSString *portraitUri = [resultDic objectForKey:@"userPortraitUri"];
                RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId
                                                                 name:nickname
                                                             portrait:portraitUri];
                //            [[DBHelper shareInstance] insertUserToDB:user];
                [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
                [RCIM sharedRCIM].currentUserInfo = user;
                [DEFAULTS setObject:user.portraitUri forKey:@"userPortraitUri"];
                [DEFAULTS setObject:user.name forKey:@"userNickName"];
                [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[[[result objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"c_tel"]] forKey:@"userTelphone"];
                [DEFAULTS synchronize];
//                NSLog(@"delegate-------loginSuccesstoken----loginrongyun 成功---->%@",[RCIM sharedRCIM].currentUserInfo);
            }
        }
    } failuer:^(NSError *error) {
        
    }];
}

#pragma mark - RCIMConnectionStatusDelegate
/**
 *  网络状态变化｡
 *
 *  @param status 网络状态｡
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号在别的设备上登录,"
                              @"您被迫下线!"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        [self removeDefaultData];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        if (self.loginFailureTimes < 1) {
            self.loginFailureTimes++;
            NSDictionary *dataDic = @{@"qtxsy_auth":qtxsy_auth};
            [[RequestManager shareRequestManager] GetGetRongYunTokenResult:dataDic viewController:nil successData:^(NSDictionary *result) {
//                NSLog(@"delegate-----GetGetRongYunTokenResult--->%@",result);
                if (IsSucess(result) == 1) {
                     [self loginRongCloudtoken:[result objectForKey:@"data"][@"result"]];
                    
                }else {
//                    NSLog(@"errorMTL----GetGetRongYunTokenResult---->%@",result);
                }
            } failuer:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"Token无效");
//                    NSLog(@"无法连接到服务器!");
                });
            }];
        }
    }else if (status == ConnectionStatus_DISCONN_EXCEPTION){
        [[RCIMClient sharedRCIMClient] disconnect];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号被封禁"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        [self removeDefaultData];
    }
}

- (void)removeDefaultData{
    [DEFAULTS removeObjectForKey:@"rongyuntoken"];
    [DEFAULTS removeObjectForKey:@"userId"];
    [DEFAULTS removeObjectForKey:@"qtxsy_auth"];
    [DEFAULTS removeObjectForKey:@"userPortraitUri"];
    [DEFAULTS removeObjectForKey:@"userNickName"];
    [DEFAULTS removeObjectForKey:@"userKind"];
    [DEFAULTS removeObjectForKey:@"c_profiles"];
    [DEFAULTS removeObjectForKey:@"userTelphone"];
    [DEFAULTS removeObjectForKey:@"user_id_str"];
    
    [DEFAULTS synchronize];
}

#pragma mark 退出应用返回首页
-(void)quit:(NSNotification *)notification{
    if (notification.userInfo ==nil) {
        [self removeDefaultData];
        _tabbarVC = [[MainViewController alloc] init];
        _tabbarVC.delegate = self;
        self.tabbarVC = _tabbarVC;
        [self initMainViewController];
        self.tabbarVC.selectedIndex = selectedIndex = 0;
    }else{
        NSInteger gotoWhere =  [notification.userInfo[@"gotoLogin"] integerValue];
        // gotoWhere 0 是没手机号 跳到绑定手机号页面 1是去登录
        if (gotoWhere == 1) {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.isModalButton = YES;
            BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
            //            [((UINavigationController *)self.tabbarVC.selectedViewController) presentViewController:Nav animated:YES completion:nil];
            
            UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            /* viewController.presentedViewController只有present才有值,push的时候为nil
             */
            //防止重复弹
            if ([viewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigation = (id)viewController.presentedViewController;
                if ([navigation.topViewController isKindOfClass:[LoginViewController class]]) {
                    return;
                }
            }
            if (viewController.presentedViewController) {
                //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
                [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
                    [viewController presentViewController:loginNav animated:true completion:nil];
                }];
            }else {
                [viewController presentViewController:loginNav animated:true completion:nil];
            }
        }else{
            //跳到登录页面
            AccountBindingViewController *vc = [[AccountBindingViewController alloc] init];
            vc.isModalButton = YES;
            BaseNavigationViewController *Nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
             Nav.modalPresentationStyle = UIModalPresentationFullScreen;
            //            [((UINavigationController *)self.tabbarVC.selectedViewController) presentViewController:Nav animated:YES completion:nil];
            
            UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            /* viewController.presentedViewController只有present才有值,push的时候为nil
             */
            
            //防止重复弹
            if ([viewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigation = (id)viewController.presentedViewController;
                if ([navigation.topViewController isKindOfClass:[AccountBindingViewController class]]) {
                    return;
                }
            }
            if (viewController.presentedViewController) {
                //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
                [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
                    [viewController presentViewController:Nav animated:true completion:nil];
                }];
            }else {
                [viewController presentViewController:Nav animated:true completion:nil];
            }
        }
        
    }
}

#pragma mark - init   GuideViewController
- (void)_intoGuideViewController{
    GuideViewController *guid = [[GuideViewController alloc]init];
    self.window.rootViewController = guid;
}

#pragma mark 广告页加载
-(void)downLoadAdvertisement{
    SDLaunchViewController *vc = [[SDLaunchViewController alloc] initWithMainVC:self.tabbarVC viewControllerType:ADLaunchViewController];
    vc.imageURL = @"广告图";
    self.window.rootViewController = vc;
}

- (void)logSelect:(NSNotification *)text{
//    NSLog(@"selectindex----logSelect------->%ld",selectedIndex);
    _tabbarVC.selectedIndex = selectedIndex;
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                             name:kJPFNetworkDidReceiveMessageNotification
//                           object:nil];
//}


@end

