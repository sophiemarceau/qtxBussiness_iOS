//
//  MainViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationViewController.h"


#import "MessageViewController.h"
#import "MineViewController.h"
#import "ProjectViewController.h"
#import "QuestionViewController.h"
#import "QuestDetailViewController.h"
#import "AnswerDetailViewController.h"
#import "ProjectDetailViewController.h"
#import "BossListViewContrller.h"

@interface MainViewController (){
    NSString *new_downloadUrl;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCheckVersionInMainPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersion) name:kCheckVersionInMainPage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kgotoDetailPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoDetailProject:) name:kgotoDetailPage object:nil];
    [self initViewController];
    NSUserDefaults * userDefaults = DEFAULTS;
    NSString * firstRun = [userDefaults objectForKey:@"firstRun"];
    //存在需要查看版本更新
    if (firstRun) {
        //提示升级客户端
        [self checkVersion];
    }
    //不存在,为第一次启动,不需要 版本更新
    else{
        firstRun = @"alreadyRun";
        [userDefaults setObject:firstRun forKey:@"firstRun"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建子控制器
-(void)initViewController
{
    //背景色
    self.tabBar.barTintColor = [UIColor whiteColor];
    //选中颜色
    self.tabBar.itemWidth = kScreenWidth / 4;
    self.tabBar.tintColor = RedUIColorC1;
    self.tabBar.itemPositioning = UITabBarItemPositioningCentered;
    QuestionViewController *vc1 = [[QuestionViewController alloc] init];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"问答" image:[[UIImage imageNamed:@"tab_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                           selectedImage:[[UIImage imageNamed:@"tab_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    vc1.tabBarItem.badgeValue = @"1";
    BaseNavigationViewController *nav1 = [[BaseNavigationViewController alloc] initWithRootViewController:vc1];
//    nav1.navigationBarHidden = YES;
    //    vc1.tabBarItem.title = ;
    
    
//    ProjectViewController *vc2 = [[ProjectViewController alloc] init];
//    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"项目" image:[[UIImage imageNamed:@"tab_icon_item_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                           selectedImage:[[UIImage imageNamed:@"tab_item_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    BaseNavigationViewController *nav2 = [[BaseNavigationViewController alloc] initWithRootViewController:vc2];
    
    BossListViewContrller *vc2 = [[BossListViewContrller alloc] init];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"直聊" image:[[UIImage imageNamed:@"tab_boss_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                           selectedImage:[[UIImage imageNamed:@"tab_boss_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationViewController *nav2 = [[BaseNavigationViewController alloc] initWithRootViewController:vc2];
    //    vc2.tabBarItem.title = @"消息";
    
    MessageViewController *vc3 = [[MessageViewController alloc] init];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[[UIImage imageNamed:@"tab_chat_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                           selectedImage:[[UIImage imageNamed:@"tab_chat_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationViewController *nav3 = [[BaseNavigationViewController alloc] initWithRootViewController:vc3];
    
    
    
    MineViewController *vc4 = [[MineViewController alloc] init];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_me_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                           selectedImage:[[UIImage imageNamed:@"tab_me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    BaseNavigationViewController *nav4 = [[BaseNavigationViewController alloc] initWithRootViewController:vc4];
    //    vc3.tabBarItem.title = @"我的";
    self.viewControllers = @[nav1,nav2,nav3,nav4];
    self.tabBar.itemPositioning = UITabBarItemPositioningCentered;
    
}

- (void)gotoDetailProject:(NSNotification *)notification {
    if (notification.userInfo != nil) {
        NSInteger project_id = [[notification.userInfo objectForKey:@"project_id"] integerValue];
        int page_jump_type_code = [[notification.userInfo objectForKey:@"page_jump_type_code"] intValue];
        if (page_jump_type_code == 1) {
            ProjectDetailViewController *vc =  [[ProjectDetailViewController alloc] init];
            vc.project_id =project_id;
             [self.selectedViewController pushViewController:vc animated:YES];
        }
        if (page_jump_type_code == 2) {
            QuestDetailViewController *vc =  [[QuestDetailViewController alloc] init];
            vc.question_id =project_id;
             [self.selectedViewController pushViewController:vc animated:YES];
        }
        if (page_jump_type_code == 3) {
            AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
            vc.answer_id = project_id;
            [self.selectedViewController pushViewController:vc animated:YES];

        }
    }
    
}

#pragma mark 版本更新
-(void)checkVersion
{
    NSDictionary * versionDic = @{
                                  @"source":@"2",
                                  @"version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                  };
    [[RequestManager shareRequestManager] getVersionInfo:versionDic viewController:self successData:^(NSDictionary *result) {
        if(IsSucess(result) == 1){
            new_downloadUrl = @"";
            new_downloadUrl = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"url"]];
            NSString *versionFlag = [[result objectForKey:@"data"] objectForKey:@"result"];
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * VersionAletshow = [userDefaults objectForKey:@"VersionAletshow"];
            //0 已是最新 1 可更新 2必更新
            if([versionFlag isEqualToString:@"1"] ){
                //可更新
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本有新的更新，是否现在去更新" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alertView.tag = 101;
                if (VersionAletshow) {
                    //已提示
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    NSString *lastRunVersion = [defaults objectForKey:IS_UPDATE_VERSION];
//                    NSLog(@"lastRunVersion--->%@",lastRunVersion);
                    if ([lastRunVersion isEqualToString:@"1"]) {
                        
                        [defaults setObject:@"0" forKey:IS_UPDATE_VERSION];
                        
                        [defaults synchronize];
                        NSString *version = [defaults objectForKey:IS_UPDATE_VERSION];
//                        NSLog(@"lastRunVersion--->%@",version);
                        [alertView show];
                        
                    }
                    
                }else{
                    
                    [alertView show];
                    VersionAletshow = @"1";
                    [userDefaults setObject:VersionAletshow forKey:@"VersionAletshow"];
                }
            }else if([versionFlag isEqualToString:@"2"]){
                //必须更新
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本已不可用，请更新后使用" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles: nil];
                alertView.tag = 102;
                [alertView show];
            }else{
                return ;
            }
        }
//        self.tabBar.hidden = NO;
    } failuer:^(NSError *error) {
//        self.tabBar.hidden = YES;
    }];
       
}

@end
