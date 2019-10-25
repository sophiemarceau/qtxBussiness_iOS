//
//  AccountBindingViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/6.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"

@interface AccountBindingViewController : BaseViewController
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UIButton *sendMessageButton;
@property(nonatomic,strong)UIButton *bindButton;
@property(nonatomic,strong)UILabel *AccordingLabel;

@property(nonatomic,strong)UIImageView *phoneLineView,*passwordLineView;
@end
