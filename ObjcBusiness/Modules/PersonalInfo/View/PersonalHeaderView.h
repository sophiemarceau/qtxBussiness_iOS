//
//  PersonalHeaderView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalVIewModel.h"
#import "UITextView+ZWPlaceHolder.h"
@interface PersonalHeaderView : UIView 
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *headerLabel;
@property (nonatomic,strong)UIImageView *arrowImageView,*lineImageView,*lineImageView1;

@property (nonatomic,strong)UIView *userNameView;
@property (nonatomic,strong)UILabel *userNameLabel;
@property (nonatomic,strong)UITextField *userNameTextField;

@property (nonatomic,strong)UIView *introduceView;
@property (nonatomic,strong)UILabel *introduceLabel;
@property (nonatomic,strong)UITextField *introduceTextField;

@property (nonatomic,strong)UIView *locationView;
@property (nonatomic,strong)UILabel *locationLabel;
@property (nonatomic,strong)UITextField *locationdTextField;
@property (nonatomic,strong)UIButton *locationdButton;

@property (nonatomic,strong)UIView *remarkBgView;

@property (nonatomic,strong)UILabel *remarksLabel;
@property (nonatomic,strong)UITextView *remarksTextView;

@property (nonatomic,strong)UIImageView *lastlineImageViewlast;
@property(nonatomic,strong)UIViewController *superViewController;
-(void)setWithViewMoel:(PersonalVIewModel *)viewModel WithSuperViewController:(UIViewController *)vc;

@end
