//
//  ResumeTempletViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/5.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ResumeTempletViewController.h"

@interface ResumeTempletViewController ()

@end

@implementation ResumeTempletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSArray * ctrlArray = self.navigationController.viewControllers;
//     [self.navigationController popToViewController:ctrlArray[ctrlArray.count-4] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    [self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:kResumePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO];
    //    [self.comBoBoxView dimissPopView];
    [MobClick endLogPageView:kResumePage];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

@end
