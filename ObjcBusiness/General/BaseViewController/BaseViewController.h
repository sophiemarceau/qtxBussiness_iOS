//
//  BaseViewController.h
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property(nonatomic,assign)BOOL isBackButton; //push
@property(nonatomic,assign)BOOL isModalButton; //weather or not presentviewcontrller


- (UIImage *)navigationBarBackgroundImage;
- (BOOL)shouldShowShadowImage;
- (BOOL)shouldHideBottomBarWhenPushed;
-(void)goBack;
- (void)adjuestNavigator;
@end
