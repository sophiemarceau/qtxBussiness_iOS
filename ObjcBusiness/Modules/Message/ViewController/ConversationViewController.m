//
//  ConversationViewController.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ConversationViewController.h"
#import "IQKeyboardManager.h"
#import "PersonalHomePageViewController.h"
@interface ConversationViewController ()
@property (nonatomic, strong) UIImageView *shadowImage;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)){
    }else{self.automaticallyAdjustsScrollViewInsets = NO;}
    self.chatSessionInputBarControl.inputTextView.inputAccessoryView = [[UIView alloc] init];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    [self initNavgation];
    [self loadData];
}

-(void)loadData{
    NSDictionary *dic = @{ @"user_id_strs":self.targetId, };
    [[RequestManager shareRequestManager] searchUserCListDtoByUserIds:dic viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            if(array != nil){
                NSDictionary *resultDic = array[0];
                NSString *name = resultDic[@"c_name"];
                if (name == nil || [name isEqualToString:@""]) {
                    name = @"";
                }else{
                    name = [NSString stringWithFormat:@"与%@直聊中",resultDic[@"c_name"]];
                }
                self.title =name;
                self.user_id = [resultDic[@"user_id"] integerValue];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    } failuer:^(NSError *error) {
    }];
}

-(void)gotoHomePage:(UIButton *)sender{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = self.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -Navigation
- (void)initNavgation{
    UIImage *rightImage = nil;
    rightImage =[UIImage imageNamed:@"nav_chat_userinfo"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(gotoHomePage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightBackItem setTitle:@""];
    self.navigationItem.rightBarButtonItem = rightBackItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kConversationPage];
    //打开键盘事件相应
    [IQKeyboardManager sharedManager].enable = NO;
    [self adjuestNavigator];
}

- (void) viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kConversationPage];
    //关闭键盘事件相应
    [IQKeyboardManager sharedManager].enable = YES;
    self.shadowImage.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self GetUserInfoResult];
}

- (void)adjuestNavigator{
    //是否显示或隐藏导航底部的线
    NSArray *subViews = [self allSubViews:self.navigationController.navigationBar];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height<1){
            //实践后发现系统的横线高度为0.333
            self.shadowImage = (UIImageView *)view;
        }
    }
    self.shadowImage.hidden = YES;
    UIImage *goBackImage = nil;
    goBackImage =[UIImage imageNamed:@"nav_back"];
    
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
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(NSArray *)allSubViews:(UIView *)aView {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews){
        NSArray *subviews = [self allSubViews:eachView];
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
    }
    return results;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
