
//  BaseNavigationViewController.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "BaseViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[BaseViewController class]]) {
        ((BaseViewController *)viewController).hidesBottomBarWhenPushed = [(BaseViewController *)viewController shouldHideBottomBarWhenPushed];
    } else {
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    UIViewController* vc = viewControllers[viewControllers.count-1];
    vc.hidesBottomBarWhenPushed = [(BaseViewController *)vc shouldHideBottomBarWhenPushed];
    [super setViewControllers:viewControllers animated:animated];
}
@end
