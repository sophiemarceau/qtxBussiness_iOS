//
//  BaseViewController.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *shadowImage;
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isModalButton = NO;
        self.isBackButton = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)){
    }else{self.automaticallyAdjustsScrollViewInsets = NO;}
     self.view.backgroundColor = BGColorGray;
    // Do any additional setup after loading the view.
}

-(void)goBack{
    //    if (self.isBackFromOrderPay) {
    //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"本次订单还未付款,返回后将退出当前界面，您可在我的订单中继续操作此订单，是否退出当前界面" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    //        alert.tag = 1001;
    //        [alert show];
    ////        [self.navigationController popToRootViewControllerAnimated:YES];
    //
    //        return;
    //    }
    if (self.isModalButton){
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

NSArray *allSubviews(UIView *aView) {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews)
    {
        NSArray *subviews = allSubviews(eachView);
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
    }
    return results;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self adjuestNavigator];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.shadowImage.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)adjuestNavigator{
    //是否显示或隐藏导航底部的线
    NSArray *subViews = allSubviews(self.navigationController.navigationBar);
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height<1){
            //实践后发现系统的横线高度为0.333
            self.shadowImage = (UIImageView *)view;
        }
    }
    if([self shouldShowShadowImage]){//需要显示导航栏底部的线
        self.shadowImage.hidden = NO;
    }else{
        self.shadowImage.hidden = YES;
    }
    
//    if([self shouldShowShadowImage]){//需要显示导航栏底部的线
//        [self.navigationController.navigationBar setShadowImage:nil];
//    } else {//不需要显示导航栏底部的线
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    }
//    //是否使用自定义的背景（透明）
//    if([self navigationBarBackgroundImage]){
//        [self.navigationController.navigationBar setBackgroundImage:[self navigationBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
//    } else {
//        [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    }


    //是否显示回退按钮
    if([self shouldShowGobackButton]){
//        UIBarButtonItem *negSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negSpaceItem.width = -5;
        UIImage *goBackImage = nil;
        if (self.isModalButton){
            goBackImage =[UIImage imageNamed:@"login_icon_close"];
        }else{
            goBackImage =[UIImage imageNamed:@"nav_back"];
        }
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:goBackImage forState:UIControlStateNormal];
        [backButton sizeToFit];
        //点击事件
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        //    [[UIBarButtonItem alloc] initWithImage:goBackImage style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        leftBackItem.tintColor = UIColorFromRGB(0x1A1A1A);
        [leftBackItem setTitle:@""];
        self.navigationItem.leftBarButtonItem = leftBackItem;
//      self.navigationItem.leftBarButtonItems = @[negSpaceItem,leftBackItem];
//      UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithImage:goBackImage style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
//        self.navigationItem.leftBarButtonItems = @[negSpaceItem,leftBackItem];
//        if (highlightedImage != nil) {
//            
//            [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
//        }
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
//        self.navigationItem.leftBarButtonItem = leftBackItem;
    }else{
        [self.navigationController.navigationItem setHidesBackButton:YES];
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    }
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

#pragma - 设置导航栏背景
- (UIImage *)navigationBarBackgroundImage{
//    return nil;
    return [CommentMethod createImageWithColor:UIColorFromRGB(0xffffff)];
}

//是否显示视图底部导航栏的线
- (BOOL)shouldShowShadowImage{
    return  NO;
}

//是否显示或隐藏视图底部的tabbar
- (BOOL)shouldHideBottomBarWhenPushed{
    return NO;
}

//是否显示导航回退按钮
- (BOOL)shouldShowGobackButton{
    return  NO;
}



@end
