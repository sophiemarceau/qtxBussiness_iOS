//
//  BossDetailViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/14.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossDetailViewController.h"
#import "BossHeaderView.h"
#import "SPPageMenu.h"
#import "YX.h"
#import "YXTabView.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
#import "IgnorHeaderTouchTableView.h"
#import "UIImageView+WebCache.h"
#import "NSString+textStringToSize.h"
#import "JohnTopTitleView.h"
#import "BossQuestionViewController.h"
#import "BossAnswerListViewController.h"
#import "BossProjectListViewController.h"
#import "SharedView.h"
#import "ComplainViewController.h"
@interface BossDetailViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate,SelectSharedTypeDelegate>{
    int total_count2;
    int total_count3;
    noWifiView * failView;
    NSDictionary *result0;
    NSDictionary *result1;
    NSDictionary *result2;
    NSError *error0;NSError *error1;NSError *error2;
    NSInteger attentionType;
    
    NSString *bossProjectH5Url;
}
@property(nonatomic,strong)SPPageMenu *pageMenu;
@property(nonatomic,strong)UIView *tableHeaderView;
@property(nonatomic,strong)BossHeaderView *bossHeaderView;
@property(nonatomic,strong)UIView *detailIntroduceView;
@property(nonatomic,strong)UILabel *detailContentLabel;
@property(nonatomic,strong)UILabel *detailButton;
@property(nonatomic,strong)UIImageView *ArrowImageView;

@property(nonatomic,strong)UIButton *directChatButton;
@property(nonatomic,strong)NSMutableArray *myChildViewControllers;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;
@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabView;
@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabViewPre;
@property(nonatomic,assign)BOOL canScroll;

@property(nonatomic,strong)NSMutableArray *answerArray,*questionArray;
@property(nonatomic,strong)BossProjectListViewController *pProjectVC;
@property(nonatomic,strong)BossAnswerListViewController *pAnswerVC;
@property(nonatomic,strong)BossQuestionViewController *pQuestionVC;
@end

@implementation BossDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bossProjectH5Url = @"";
    [self initNavgation];
    
    [self loadData];
}

-(void)shareClick:(UIButton *)sender{
    NSLog(@"shareClick");
    //     flag 0 没有删除 flag 1有删除
    NSDictionary *dic = @{@"title" :@"举报老板",
                          @"desc" :@"举报老板",
                          @"image":[UIImage imageNamed:@"logo-login"],
                          @"url"  :[NSString stringWithFormat:@"%@/%@",@"question",[NSString stringWithFormat:@"%ld",self.bossID]]};
    SharedView *sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    sharedView.fromWhereFlag = ShareTypeFromBossDetail;
    sharedView.delegate = self;
    sharedView.currentVC = self;
    sharedView.boss_id = self.bossID;
    [sharedView initPublishContent:dic FlagWithDeleButton:0];
}

- (void)SelectSharedTypeDelegateReturnPage:(ShareType)returnShareType{
    NSLog(@"SelectSharedTypeDelegateReturnPage-------");
    if (returnShareType == ShareTypeReport) {
        NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (userID) {
            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                ComplainViewController *vc = [[ComplainViewController alloc] init];
                vc.feedback_kind = 1;
                vc.reportType = 3;
                vc.reportFromID = self.bossID;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
        }
    }
    
    if(returnShareType == ShareTypeDelete){
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (returnShareType == ShareTypeCopy) {
        [[RequestManager shareRequestManager] tipAlert:@"复制成功" viewController:self];
    }
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    self.detailButton.hidden = YES;
    [self.detailContentLabel sizeToFit];
    self.detailContentLabel.frame = CGRectMake(self.detailContentLabel.frame.origin.x, self.detailContentLabel.frame.origin.y, self.detailContentLabel.frame.size.width, self.detailContentLabel.frame.size.height);
    self.detailIntroduceView.frame =
    CGRectMake(self.detailIntroduceView.frame.origin.x,
               self.detailIntroduceView.frame.origin.y,
               kScreenWidth,
               self.detailContentLabel.frame.origin.y+self.detailContentLabel.frame.size.height+11.5*AUTO_SIZE_SCALE_X);
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.detailIntroduceView.frame)+10*AUTO_SIZE_SCALE_X);
    [self.tableView reloadData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.answerArray removeAllObjects];
    [self.answerArray removeAllObjects];
    result0 = result1 = nil;
    failView.hidden = YES;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第0个网络请求任务添加到组中
    // 个人主页 相关信息 获取
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic0 = @{
                               @"_user_id_other":[NSString stringWithFormat:@"%ld",self.bossID],
                               @"_currentPage":@"",
                               @"_pageSize":@"",
                               };
        NSLog(@"dic0------->%@",dic0);
        [[RequestManager shareRequestManager] getUserCHomePageDto:dic0 viewController:self successData:^(NSDictionary *result){
            result0= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error0 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 将第1个网络请求任务添加到组中
    
    // 个人主页 回答列表
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSDictionary *dic1 =  @{
                                @"user_id_owner":[NSString stringWithFormat:@"%ld",self.bossID],
                                @"_currentPage":@"",
                                @"_pageSize":@"",
                                };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] searchAnswerDtosByUserId:dic1 viewController:self successData:^(NSDictionary *result){
            result1 = result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            
            error1 = error;
            NSLog(@"失败请求数据");
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 将第2个网络请求任务添加到组中
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        // 开始网络请求任务
        // 提问列表
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSString *userStr = [NSString stringWithFormat:@"%ld",self.bossID];
        userStr = [NSString stringWithFormat:@"%ld",self.bossID];
        NSDictionary *dic2 = @{
                               @"user_id_owner":userStr,
                               @"_currentPage":@"",
                               @"_pageSize":@"",
                               };
        //        NSLog(@"dic2==================>%@",dic2);
        [[RequestManager shareRequestManager]searchQuestionDtosByUserId:dic2 viewController:self successData:^(NSDictionary *result){
            //            NSLog(@"result=========dic2=========>%@",result);
            result2 = result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error2 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"成功请求数据=0:%@",result0);
        NSLog(@"成功请求数据=1:%@",result1);
        NSLog(@"成功请求数据=2:%@",result2);
        
        if (result0==nil||result1==nil || result2==nil ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initSubViews];
                failView.hidden = YES;
                [LZBLoadingView dismissLoadingView];
            });
        }
    });
}

-(void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIImage *rightImage = nil;
    rightImage =[UIImage imageNamed:@"detail_pages_btn_more"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton sizeToFit];
    //点击事件
    [rightButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [rightBackItem setTitle:@""];
    self.navigationItem.rightBarButtonItem = rightBackItem;
}

-(void)initSubViews{
    if (IsSucess(result0) == 1) {
        NSDictionary *dic = result0[@"data"][@"result"];
        if (![dic isEqual:[NSNull null]]) {
                [self.bossHeaderView.headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"c_photo"]] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
                self.bossHeaderView.nameLabel.text = dic[@"c_realname"];
                
                NSInteger isexpert = [dic[@"is_expert"] integerValue];// 是否为专家身份；0，不是；1，是；
                if (isexpert==1) {
                    self.bossHeaderView.expertFlagImageView.hidden = NO;
                }else{
                    self.bossHeaderView.expertFlagImageView.hidden = YES;
                }
                NSInteger is_certification = [dic[@"is_certification"] integerValue];//企业用户是否认证；0，没有认证；1，已认证；
                if (is_certification==1) {
                    self.bossHeaderView.enterpriseFlagImageView.hidden = NO;
                }else{
                    self.bossHeaderView.enterpriseFlagImageView.hidden = YES;
                }
                self.bossHeaderView.companyAndJobLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"c_short_company_name"],dic[@"c_jobtitle"]];
                self.bossHeaderView.introduceLabel.text = dic[@"c_profiles"];
                self.bossHeaderView.locationLabel.text = dic[@"cAreaName"];
                self.bossHeaderView.locationImageView.hidden = NO;
                NSString *locationNameStr =  dic[@"cAreaName"];
                CGSize locationStrSize = [NSString sizeWithText:locationNameStr maxSize:CGSizeMake(kScreenWidth - CGRectGetMaxX(self.bossHeaderView.frame) -97*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
                self.bossHeaderView.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.bossHeaderView.locationImageView.frame),
                                                                     CGRectGetMaxY(self.bossHeaderView.introduceLabel.frame) +5*AUTO_SIZE_SCALE_X,
                                                                     locationStrSize.width,
                                                                     locationStrSize.height);
                self.bossHeaderView.tradeImageView.frame = CGRectMake(CGRectGetMaxX(self.bossHeaderView.locationLabel.frame)+20*AUTO_SIZE_SCALE_X, self.bossHeaderView.locationImageView.origin.y, 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
                
                self.bossHeaderView.tradeLabel.frame = CGRectMake(CGRectGetMaxX(self.bossHeaderView.tradeImageView.frame), CGRectGetMaxY(self.bossHeaderView.introduceLabel.frame) +5*AUTO_SIZE_SCALE_X, kScreenWidth- (self.bossHeaderView.tradeLabel.frame.origin.x)-15*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
                self.bossHeaderView.tradeLabel.text = dic[@"project_industry_name"];
                
                NSString *expstr = [NSString stringWithFormat:@"专家认证：%@",dic[@"c_expert_profiles"]];
                NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:expstr];
                [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(0,5)];
                [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,5)];
                [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorBlack range:NSMakeRange(5,[dic[@"c_expert_profiles"] length])];
                [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(5,[dic[@"c_expert_profiles"] length])];
                self.bossHeaderView.expertLabel.attributedText = mutablestr;
                self.bossHeaderView.expertLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.bossHeaderView.headImageView.frame)+10*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
                
                NSString *jobStr = [NSString stringWithFormat:@"%@ | %@",dic[@"c_jobtitle"],dic[@"company_name"]];
                NSString *jobString = [NSString stringWithFormat:@"职位认证：%@",jobStr];
                NSMutableAttributedString *mutablestr1 = [[NSMutableAttributedString alloc] initWithString:jobString];
                [mutablestr1 addAttribute:NSForegroundColorAttributeName value:blueLabelColor range:NSMakeRange(0,5)];
                [mutablestr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,5)];
                [mutablestr1 addAttribute:NSForegroundColorAttributeName value:FontUIColorBlack range:NSMakeRange(5,[jobStr length])];
                [mutablestr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(5,[jobStr length])];
                self.bossHeaderView.jobLabel.attributedText = mutablestr1;
                self.bossHeaderView.jobLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.bossHeaderView.expertLabel.frame)+5*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
                
            NSString *bossDescriptionStr = dic[@"c_description"];
                CGSize detailContentSize = [NSString sizeWithText:bossDescriptionStr maxSize:CGSizeMake(kScreenWidth - 30*AUTO_SIZE_SCALE_X, MAXFLOAT) font:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]];
                ;
            CGFloat detailContentHeight;
            if (detailContentSize.height < 21*AUTO_SIZE_SCALE_X) {
                detailContentHeight = 21*AUTO_SIZE_SCALE_X;
            }else{
                detailContentHeight = detailContentSize.height;
                detailContentHeight = detailContentSize.height > 63*AUTO_SIZE_SCALE_X ? 63*AUTO_SIZE_SCALE_X : detailContentHeight;
            }
            self.detailContentLabel.text = bossDescriptionStr;
            bossProjectH5Url = dic[@"bossProjectH5Url"];
            
                self.detailContentLabel.frame = CGRectMake(self.detailContentLabel.frame.origin.x, self.detailContentLabel.frame.origin.y, self.detailContentLabel.frame.size.width, detailContentHeight);

                if(detailContentSize.height > 63*AUTO_SIZE_SCALE_X){
                    [_detailIntroduceView addSubview:self.detailButton];
                    _detailButton.frame = CGRectMake(0, CGRectGetMaxY(self.detailContentLabel.frame), kScreenWidth, 42*AUTO_SIZE_SCALE_X);
                    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar_icon_down-1"]];
                    arrowImageView.frame = CGRectMake(217*AUTO_SIZE_SCALE_X, 19*AUTO_SIZE_SCALE_X, 6*AUTO_SIZE_SCALE_X ,4*AUTO_SIZE_SCALE_X);
                    [self.detailButton addSubview:arrowImageView];
                    self.detailIntroduceView.frame =
                    CGRectMake(self.detailIntroduceView.frame.origin.x,
                               CGRectGetMaxY(self.bossHeaderView.frame)+10*AUTO_SIZE_SCALE_X,
                               kScreenWidth,
                               CGRectGetMaxY(self.detailButton.frame));
                }else{
                    self.detailIntroduceView.frame =
                    CGRectMake(self.detailIntroduceView.frame.origin.x,
                               CGRectGetMaxY(self.bossHeaderView.frame)+10*AUTO_SIZE_SCALE_X,
                               kScreenWidth,
                               self.detailContentLabel.frame.origin.y+self.detailContentLabel.frame.size.height+11.5*AUTO_SIZE_SCALE_X);
                }
                self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.detailIntroduceView.frame)+10*AUTO_SIZE_SCALE_X);
            }else{
                if (IsSucess(result0) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result0];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result0 viewController:self];
                }
            }
        
    }
    _tableView = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, kNavHeight,kScreenWidth, kScreenHeight-kNavHeight-kTabHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
    [self.view addSubview:self.directChatButton];
    [self getConnection];
}

-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

-(void)clickAttention:(UIButton *)sender{
    sender.enabled = NO;
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            NSString *userStr1 = [NSString stringWithFormat:@"%ld",self.bossID];
            
            NSDictionary *dic = @{@"user_id_followed":userStr1,};
            if (attentionType == 0) {
                [[RequestManager shareRequestManager] addConnection:dic viewController:self successData:^(NSDictionary *result){
                    NSLog(@"sender-----addConnection----%@",result);
                    //            failView.hidden = YES;
                    if(IsSucess(result) == 1){
                        attentionType = [[result objectForKey:@"data"][@"result"]  intValue];
                        [[RequestManager shareRequestManager] tipAlert:@"关注成功" viewController:self];
                        if (attentionType == 1) {
                            [self.bossHeaderView.followButton setTitleColor:FontUIColor999999Gray forState:(UIControlStateNormal)];
                            [self.bossHeaderView.followButton setTitle:@"已关注"  forState:(UIControlStateNormal)];
                            [self.bossHeaderView.followButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xf4f5f7)] forState:UIControlStateNormal];
                        }
                        if (attentionType == 2) {
                            [self.bossHeaderView.followButton setTitleColor:FontUIColor999999Gray forState:(UIControlStateNormal)];
                            [self.bossHeaderView.followButton setTitle:@"相互关注"  forState:(UIControlStateNormal)];
                            [self.bossHeaderView.followButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xf4f5f7)] forState:UIControlStateNormal];
                        }
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        }
                    }
                    sender.enabled = YES;
                }failuer:^(NSError *error){
                    [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                    sender.enabled = YES;
                }];
                
            }
            if (attentionType == 1 || (attentionType == 2)) {
                [[RequestManager shareRequestManager] cancelConnection:dic viewController:self successData:^(NSDictionary *result){
                    NSLog(@"result-----cancelConnection----%@",result);
                    if(IsSucess(result) == 1){
                        attentionType = [[result objectForKey:@"data"][@"result"]  intValue];
                        if (attentionType == 0) {
                            [[RequestManager shareRequestManager] tipAlert:@"已取消关注" viewController:self];
                            [self.bossHeaderView.followButton setTitleColor:RedUIColorC1 forState:(UIControlStateNormal)];
                            [self.bossHeaderView.followButton setTitle:@"关注"  forState:(UIControlStateNormal)];
                            [self.bossHeaderView.followButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xf4f5f7)] forState:UIControlStateNormal];
                        }
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        }
                    }
                    sender.enabled = YES;
                }failuer:^(NSError *error){
                    [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                    sender.enabled= YES;
                }];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
            sender.enabled = YES;
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
        sender.enabled = YES;
    }
}
-(void)getConnection{
    [self.bossHeaderView.followButton addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dic4 = @{
                           @"user_id_followed":[NSString stringWithFormat:@"%ld",self.bossID],
                           };
    [[RequestManager shareRequestManager]getConnectionStatus:dic4 viewController:self successData:^(NSDictionary *result){
        NSLog(@"getconnection-----result--------->%@,",result);
        if (IsSucess(result) == 1) {
            id list = [[result objectForKey:@"data"] objectForKey:@"result"];
            if (![list isEqual:[NSNull null]]) {
                attentionType = [[[result objectForKey:@"data"] objectForKey:@"result"] integerValue];
                if (attentionType == 0) {
                    [self.bossHeaderView.followButton setTitleColor:RedUIColorC1 forState:(UIControlStateNormal)];
                    [self.bossHeaderView.followButton setTitle:@"关注"  forState:(UIControlStateNormal)];
                    [self.bossHeaderView.followButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xf4f5f7)] forState:UIControlStateNormal];
                    
                }
                if (attentionType == 1) {
                    [self.bossHeaderView.followButton setTitleColor:FontUIColor999999Gray forState:(UIControlStateNormal)];
                    [self.bossHeaderView.followButton setTitle:@"已关注"  forState:(UIControlStateNormal)];
                    [self.bossHeaderView.followButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xf4f5f7)] forState:UIControlStateNormal];
                }
                if (attentionType == 2) {
                    [self.bossHeaderView.followButton setTitleColor:FontUIColor999999Gray forState:(UIControlStateNormal)];
                    [self.bossHeaderView.followButton setTitle:@"相互关注"  forState:(UIControlStateNormal)];
                    [self.bossHeaderView.followButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xf4f5f7)] forState:UIControlStateNormal];
                }
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    }failuer:^(NSError *error){
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kBossDetailPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kBossDetailPage];
    
}

-(UIView *)tableHeaderView{
    if (_tableHeaderView == nil) {
        _tableHeaderView = [UIView new];
        _tableHeaderView.backgroundColor = BGColorGray;
        [_tableHeaderView addSubview:self.bossHeaderView];
        [_tableHeaderView addSubview:self.detailIntroduceView];

        _tableHeaderView.userInteractionEnabled = YES;
    }
    return _tableHeaderView;
}

-(UIView *)detailIntroduceView{
    if (_detailIntroduceView == nil) {
        _detailIntroduceView = [UIView new];
        _detailIntroduceView.backgroundColor = [UIColor whiteColor];
        UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, 4*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X)];
        redview.backgroundColor = RedUIColorC1;
        [_detailIntroduceView addSubview:redview];
        
        UILabel *detailLabel = [CommentMethod initLabelWithText:@"详情介绍" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
        detailLabel.frame = CGRectMake(27*AUTO_SIZE_SCALE_X, 11.5*AUTO_SIZE_SCALE_X, kScreenWidth-27*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
        [_detailIntroduceView addSubview:detailLabel];
        _detailIntroduceView.userInteractionEnabled = YES;

        [_detailIntroduceView addSubview:self.detailContentLabel];
    }
    return _detailIntroduceView;
}

-(UILabel *)detailContentLabel{
    if (_detailContentLabel == nil) {
        _detailContentLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
        _detailContentLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
        _detailContentLabel.numberOfLines = 0;
    }
    return _detailContentLabel;
}

-(UILabel *)detailButton{
    if (_detailButton == nil) {
        _detailButton = [CommentMethod initLabelWithText:@"展开全部" textAlignment:NSTextAlignmentCenter font:15 TextColor:FontUIColorBlack];
        
        _detailButton.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
        [_detailButton addGestureRecognizer:tap1];
    }
    return _detailButton;
}

-(BossHeaderView *)bossHeaderView{
    if (_bossHeaderView == nil) {
        _bossHeaderView  = [[BossHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 178*AUTO_SIZE_SCALE_X)];
    }
    return _bossHeaderView;
}

-(NSMutableArray *)myChildViewControllers{
    if (_myChildViewControllers == nil) {
        _myChildViewControllers = [NSMutableArray arrayWithCapacity:0];
    }
    return _myChildViewControllers;
}

-(UIButton *)directChatButton{
    if (_directChatButton == nil) {
        _directChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _directChatButton.frame = CGRectMake(0, kScreenHeight - kTabHeight, kScreenWidth   , kTabHeight);
        [_directChatButton setBackgroundImage:[CommentMethod createImageWithColor:RedUIColorC1] forState:UIControlStateNormal];
        [_directChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_directChatButton setTitle:@"立刻直聊" forState:UIControlStateNormal];
    }
    return _directChatButton;
}

-(NSMutableArray *)answerArray{
    if (_answerArray == nil) {
        _answerArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _answerArray;
}

-(NSMutableArray *)questionArray{
    if (_questionArray == nil) {
        _questionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _questionArray;
}

- (BossProjectListViewController *)pProjectVC{
    if (!_pProjectVC) {
        _pProjectVC = [[BossProjectListViewController alloc]init];
//        __weak typeof(self) weakSelf = self;
//        _pProjectVC.DidScrollBlock = ^(CGFloat scrollY) {
////            [weakSelf johnScrollViewDidScroll:scrollY];
//        };
    }
    return _pProjectVC;
}

- (BossQuestionViewController *)pQuestionVC{
    if (!_pQuestionVC) {
        _pQuestionVC = [[BossQuestionViewController alloc]init];
//        __weak typeof(self) weakSelf = self;
        _pQuestionVC.DidScrollBlock = ^(CGFloat scrollY) {
//            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _pQuestionVC;
}

- (BossAnswerListViewController *)pAnswerVC{
    if (!_pAnswerVC) {
        _pAnswerVC = [[BossAnswerListViewController alloc]init];
//        __weak typeof(self) weakSelf = self;
        _pAnswerVC.DidScrollBlock = ^(CGFloat scrollY) {
//            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _pAnswerVC;
}

//-(SPPageMenu *)pageMenu{
//    if (_pageMenu == nil) {
//        // trackerStyle:跟踪器的样式
//        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleTextZoom];
//        [_pageMenu setItems:@[@"项目",@"回答",@"提问",] selectedItemIndex:0];
//        // 等宽,不可滑动
//        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
//        // 设置代理
//        _pageMenu.delegate = self;
//
//    }
//    return _pageMenu;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;

    NSInteger section = indexPath.section;
    if (section==0) {
        height = [self tableHeaderView].frame.size.height;
    }else if(section==1){
        height = scrollViewHeight+pageMenuH;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section  = indexPath.section;
    if (section==0) {
        [cell.contentView addSubview:self.tableHeaderView];
        return cell;
    }else if(section==1){
        self.pProjectVC.reqeustURLStr = bossProjectH5Url;
        self.pAnswerVC.answerArray = self.answerArray;
        self.pQuestionVC.questionArray = self.questionArray;
        self.pAnswerVC.user_id = self.bossID;
        self.pQuestionVC.user_id = self.bossID;
        self.pAnswerVC.total_count = total_count2;
        self.pQuestionVC.total_count = total_count3;
        [self addChildViewController:self.pProjectVC];
        [self addChildViewController:self.pAnswerVC];
        [self addChildViewController:self.pQuestionVC];
        [self.myChildViewControllers addObject:self.pProjectVC];
        [self.myChildViewControllers addObject:self.pAnswerVC];
        [self.myChildViewControllers addObject:self.pQuestionVC];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageMenuH, kScreenWidth, scrollViewHeight)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = scrollView;
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleTextZoom];
        [_pageMenu setItems:@[@"项目",@"回答",@"提问",] selectedItemIndex:0];
        // 等宽,不可滑动
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        // 设置代理
        _pageMenu.delegate = self;
        // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
        _pageMenu.bridgeScrollView = scrollView;
        
        // pageMenu.selectedItemIndex就是选中的item下标
        if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
            BaseViewController *baseVc = self.myChildViewControllers[_pageMenu.selectedItemIndex];
            [scrollView addSubview:baseVc.view];
            baseVc.view.frame = CGRectMake(kScreenWidth*_pageMenu.selectedItemIndex, 0, kScreenWidth, scrollViewHeight);
            scrollView.contentOffset = CGPointMake(kScreenWidth*_pageMenu.selectedItemIndex, 0);
            scrollView.contentSize = CGSizeMake(3*kScreenWidth, 0);
        }
        [cell.contentView addSubview:_pageMenu];
        [cell.contentView addSubview:self.scrollView];
        return cell;
    }
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView class]]) {
        return;
    }
    CGFloat tabOffsetY = self.tableHeaderView.frame.size.height ;
    
    CGFloat offsetY = self.tableView.contentOffset.y;
        
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY+1>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(kScreenWidth * toIndex, 0, kScreenWidth, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
}


#pragma mark - insert or remove

// object是插入的对象(NSString或UIImage),insertNumber是插入到第几个
- (void)insertItemWithObject:(id)object toIndex:(NSInteger)insertNumber {
    //    // 插入之前，先将新控制器之后的控制器view往后偏移
    //    for (int i = 0; i < self.myChildViewControllers.count; i++) {
    //        if (i >= insertNumber) {
    //            UIViewController *childController = self.myChildViewControllers[i];
    //            childController.view.frame = CGRectMake(kScreenWidth * (i+1), 0, kScreenWidth, kScreenHeight-kNavHeight-pageMenuH);
    //            [self.scrollView addSubview:childController.view];
    //        }
    //    }
    //    if (insertNumber <= self.pageMenu.selectedItemIndex && self.myChildViewControllers.count) { // 如果新插入的item在当前选中的item之前
    //        // scrollView往后偏移
    //        self.scrollView.contentOffset = CGPointMake(kScreenWidth*(self.pageMenu.selectedItemIndex+1), 0);
    //    } else {
    //        self.scrollView.contentOffset = CGPointMake(0, 0);
    //    }
    //
    //    SixViewController *sixVc = [[SixViewController alloc] init];
    //    sixVc.text = @"我是新插入的";
    //    [self addChildViewController:sixVc];
    //    [self.myChildViewControllers insertObject:sixVc atIndex:insertNumber];
    //
    //    // 要先添加控制器，再添加item，如果先添加item，会立即调代理方法，此时myChildViewControllers的个数还是0，在代理方法中retun了
    //    if ([object isKindOfClass:[NSString class]]) {
    //        [self.pageMenu insertItemWithTitle:object atIndex:insertNumber animated:YES];
    //    } else {
    //        [self.pageMenu insertItemWithImage:object atIndex:insertNumber animated:YES];
    //    }
    //
    //    // 重新设置scrollView容量
    //    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

- (void)removeItemAtIndex:(NSInteger)index {
    
    //    if (index >= self.myChildViewControllers.count) {
    //        return;
    //    }
    //
    //    [self.pageMenu removeItemAtIndex:index animated:YES];
    //
    //    // 删除之前，先将新控制器之后的控制器view往前偏移
    //    for (int i = 0; i < self.myChildViewControllers.count; i++) {
    //        if (i >= index) {
    //            UIViewController *childController = self.myChildViewControllers[i];
    //            childController.view.frame = CGRectMake(screenW * (i>0?(i-1):i), 0, screenW, scrollViewHeight);
    //            [self.scrollView addSubview:childController.view];
    //        }
    //    }
    //    if (index <= self.pageMenu.selectedItemIndex) { // 移除的item在当前选中的item之前
    //        // scrollView往前偏移
    //        NSInteger offsetIndex = self.pageMenu.selectedItemIndex-1;
    //        if (offsetIndex < 0) {
    //            offsetIndex = 0;
    //        }
    //        self.scrollView.contentOffset = CGPointMake(screenW*offsetIndex, 0);
    //    }
    //
    //    UIViewController *vc = [self.myChildViewControllers objectAtIndex:index];
    //    [self.myChildViewControllers removeObjectAtIndex:index];
    //    [vc removeFromParentViewController];
    //    [vc.view removeFromSuperview];
    //
    //    // 重新设置scrollView容量
    //    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

- (void)removeAllItems {
//    [self.pageMenu removeAllItems];
//    for (UIViewController *vc in self.myChildViewControllers) {
//        [vc removeFromParentViewController];
//        [vc.view removeFromSuperview];
//    }
//    [self.myChildViewControllers removeAllObjects];
//    self.scrollView.contentOffset = CGPointMake(0, 0);
//    self.scrollView.contentSize = CGSizeMake(0, 0);
//    [self.scrollView removeFromSuperview];
//    self.scrollView = nil;
//
//    [self.pageMenu.bridgeScrollView removeFromSuperview];
//    [self.pageMenu removeFromSuperview];
//    self.pageMenu = nil;
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self removeAllItems];
}
@end
