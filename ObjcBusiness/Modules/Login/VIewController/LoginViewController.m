//
//  LoginViewController.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LoginViewModel.h"

@interface LoginViewController ()
@property (strong,nonatomic) LoginViewModel *loginViewModel;
@property (strong,nonatomic) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initViews];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return YES;
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

#pragma mark - Private
- (void)_initViews {
    [self.view addSubview:self.loginView];
    [self.loginView setWithViewMoel:self.loginViewModel WithSuperViewController:self];
}

#pragma mark - Getter
- (LoginViewModel *)loginViewModel {
    if (_loginViewModel == nil) {
        _loginViewModel = [[LoginViewModel alloc]init];
    }
    return _loginViewModel;
}

- (LoginView *)loginView {
    if (_loginView == nil) {
        _loginView = [[LoginView alloc]init];
    }
    return _loginView;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [MobClick beginLogPageView:kLoginPage];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:kLoginPage];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
@end
