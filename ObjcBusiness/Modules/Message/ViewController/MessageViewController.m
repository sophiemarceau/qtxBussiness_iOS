//
//  MessageViewController.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MessageViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ConversationViewController.h"
#import "ConversationTableViewCell.h"
#import "ConversantionUserInfo.h"
#import "UIImageView+WebCache.h"
#import "WhoSeeMyHomePagViewController.h"
@interface MessageViewController (){
    UILabel *countLabel;
}
@property(nonatomic,strong)UIView *whoSeeMyHomePageView;

@end

@implementation MessageViewController

-(id)init{
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)
                                            //                                        @(ConversationType_DISCUSSION),
                                            //                                        @(ConversationType_CHATROOM),
                                            //                                        @(ConversationType_GROUP),
                                            //                                        @(ConversationType_APPSERVICE),
                                            //                                        @(ConversationType_SYSTEM)
                                            ]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[
//                                              @(ConversationType_PRIVATE),
                                              @(ConversationType_DISCUSSION),
                                              @(ConversationType_GROUP)
                                              ]
         ];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"viewDidLoad---->%@",self.view);
    
    if (@available(iOS 11.0, *)){
    }else{self.automaticallyAdjustsScrollViewInsets = NO;}
    self.conversationListTableView.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight);
    self.title = @"消息";
    //设置后会去掉 列表里的风格县
    self.conversationListTableView.tableFooterView = [UIView new];
    
    self.showConnectingStatusOnNavigatorBar = YES;
    /*!
     当网络断开时，是否在Tabel View Header中显示网络连接不可用的提示。
     
     @discussion 默认值为YES。
     */
    self.isShowNetworkIndicatorView = NO;
    self.conversationListTableView.tableHeaderView = self.whoSeeMyHomePageView;
//    //自定义空会话的背景View。当会话列表为空时，将显示该View
//    UIView *blankView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    blankView.backgroundColor=[UIColor redColor];
//    self.emptyConversationView=blankView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    ConversationViewController *conversationVC = [[ConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    
    

    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
//    NSLog(@"senderID-------->%@",model.senderUserId);
//    NSDictionary *dic = @{
//                          @"user_id_to":model.targetId,//会话对方用户ID
//                          @"source":@"2",//最新一次对话，来源/方式，1，Android；2，iOS；3，H5；4，PC；5，系统；
//                          };
//    NSLog(@"dic-------->%@",dic);
//    [[RequestManager shareRequestManager] saveImUser:dic viewController:self successData:^(NSDictionary *result) {
//        if (IsSucess(result) == 1) {
//            NSInteger flag = [[[result objectForKey:@"data"] objectForKey:@"result"] integerValue];
//            if (flag == 1) {
//
//            }
//        }else{
//            if (IsSucess(result) == -1) {
//                [[RequestManager shareRequestManager] loginCancel:result];
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            }
//        }
//    } failuer:^(NSError *error) {
//
//    }];
//
}

-(void)countUserViewNum{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] countUserViewNum:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"countUserViewNum------>%@",result);
        if (IsSucess(result) == 1) {
            
            countLabel.text = [NSString stringWithFormat:@"%ld",[[result objectForKey:@"data"][@"result"] integerValue]];
          
            //（1，普通用户；2，企业用户；3，平台运营)
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        //        self.failView.hidden = YES;
        
    } failuer:^(NSError *error) {
        //        self.failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
}
//
//-(void)GetUserInfoResult{
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    NSString *user_id_str = [DEFAULTS objectForKey:@"user_id_str"];
//    if (!user_id_str) {
//        user_id_str  = @"";
//    }
//    NSDictionary *dic = @{
//                          @"user_id_str":user_id_str,
//                          @"_isReturnCompanyInfo":@"1",
//                          @"_isReturnExt":@"1"
//                          };
//    [[RequestManager shareRequestManager] searchUserCListDtoByUserIds:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"GetUserInfoResult------>%@",result);
//        if (IsSucess(result) == 1) {
//            NSDictionary *resultDic = [[result objectForKey:@"data"] objectForKey:@"result"];
//
//            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_tel"]] forKey:@"userTelphone"];
//            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_photo"]] forKey:@"userPortraitUri"];
//            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_nickname"]] forKey:@"userNickName"];
//            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_profiles"]] forKey:@"c_profiles"];
//            [DEFAULTS synchronize];
//            //（1，普通用户；2，企业用户；3，平台运营)
//        }else{
//            if (IsSucess(result) == -1) {
//                [[RequestManager shareRequestManager] loginCancel:result];
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            }
//        }
////        self.failView.hidden = YES;
//        [LZBLoadingView dismissLoadingView];
//    } failuer:^(NSError *error) {
////        self.failView.hidden = NO;
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//        [LZBLoadingView dismissLoadingView];
//    }];
//}
//


//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if (model.conversationType == ConversationType_PRIVATE) {
                model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            }
    }
    return dataSource;
}

//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE
                                             targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}


//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    __block NSString *c_name = nil;
    __block NSString *userId = nil;
    __block NSString *user_id_str = nil;
    __block NSString *c_photo = nil;
    __block NSString *c_short_company_name = nil;
    __block NSString *c_jobtitle = nil;
    RCMessageContent *_contactNotificationMsg = nil;
    
   
    __weak MessageViewController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if (model.conversationType == ConversationType_PRIVATE) {
            _contactNotificationMsg = (RCMessageContent *)model.lastestMessage;
//            if (_contactNotificationMsg.senderUserInfo.userId == nil) {
//                ConversationTableViewCell *cell =
//                [[ConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                 reuseIdentifier:@""];
//                //                    cell.lblDetail.text = @"好友请求";
//                //                    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
//                //                                  placeholderImage:[UIImage imageNamed:@"system_notice"]];
//                return cell;
//            }
            NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]
                                             objectForKey:model.targetId];
            if (_cache_userinfo) {
                c_name =  _cache_userinfo[@"c_name"];
                userId = _cache_userinfo[@"user_id"];
                user_id_str = _cache_userinfo[@"user_id_str"];
                c_photo = _cache_userinfo[@"c_photo"];
                c_short_company_name = _cache_userinfo[@"c_short_company_name"];
                c_jobtitle = _cache_userinfo[@"c_jobtitle"];
            } else {
                NSDictionary *emptyDic = @{};
                [[NSUserDefaults standardUserDefaults]
                 setObject:emptyDic
                 forKey:model.targetId];
                [[NSUserDefaults standardUserDefaults] synchronize];

                NSDictionary *dic = @{ @"user_id_strs":model.targetId, };
//                 NSLog(@"searchUserCListDtoByUserIds--rcConversationListTableView--dic-->%@",dic);
                [[RequestManager shareRequestManager] searchUserCListDtoByUserIds:dic viewController:self successData:^(NSDictionary *result) {
//                    NSLog(@"searchUserCListDtoByUserIds--rcConversationListTableView---->%@",result);
                    if (IsSucess(result) == 1) {
                        NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
                        if(array != nil){
                            NSDictionary *resultDic = array[0];
                            ConversantionUserInfo *rcduserinfo_ = [ConversantionUserInfo new];
                            rcduserinfo_.c_name =  resultDic[@"c_name"];
                            rcduserinfo_.userId = [NSString stringWithFormat:@"%ld",[resultDic[@"user_id"] integerValue]];
                            rcduserinfo_.user_id_str = resultDic[@"user_id_str"];
                            rcduserinfo_.c_photo = resultDic[@"c_photo"];
                            NSString *companyStr = resultDic[@"c_short_company_name"];
                            NSString *jobStr = resultDic[@"c_jobtitle"];
                            if( companyStr== nil){
                                rcduserinfo_.c_short_company_name = @"";
                            }else{
                                rcduserinfo_.c_short_company_name = companyStr;
                            }
                            if (jobStr== nil){
                                rcduserinfo_.c_jobtitle = @"";
                            }else{
                                rcduserinfo_.c_jobtitle = jobStr;
                            }
                            model.extend = rcduserinfo_;
                            
                            NSDictionary *userinfoDic = @{
                                                          @"c_name":rcduserinfo_.c_name ,
                                                          @"user_id":rcduserinfo_.userId,
                                                          @"user_id_str":rcduserinfo_.user_id_str,
                                                          @"c_photo":rcduserinfo_.c_photo ,
                                                          @"c_short_company_name":rcduserinfo_.c_short_company_name ,
                                                          @"c_jobtitle":rcduserinfo_.c_jobtitle
                                                          };
                            [[NSUserDefaults standardUserDefaults] setObject:userinfoDic forKey:model.targetId];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [weakSelf.conversationListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        }
    } else {
        ConversantionUserInfo *user = (ConversantionUserInfo *)model.extend;
        c_name =  user.c_name;
        userId = user.userId;
        user_id_str = user.user_id_str;
        c_photo = user.c_photo;
        c_short_company_name = user.c_short_company_name;
        c_jobtitle = user.c_jobtitle;
    }
    
    ConversationTableViewCell *cell =
    [[ConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@""];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:c_photo] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    
    cell.nameLabel.text = c_name;
    if ([c_short_company_name isEqualToString:@""]) {
        if([c_jobtitle isEqualToString:@""]){
            cell.companyAndJobLabel.text = @"";
        }else{
            cell.companyAndJobLabel.text = [NSString stringWithFormat:@"%@",c_jobtitle];
        }
    }else{
        if([c_jobtitle isEqualToString:@""]){
            cell.companyAndJobLabel.text = [NSString stringWithFormat:@"%@ ",c_short_company_name];
        }else{
            cell.companyAndJobLabel.text = [NSString stringWithFormat:@"%@ | %@",c_short_company_name,c_jobtitle];
        }
    }
    
    if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMsg = (RCTextMessage *)model.lastestMessage;
        [cell.messageSketchLabel setText:textMsg.content];
    } else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]) {
        [cell.messageSketchLabel setText:@"[图片]"];
    } else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]) {
        [cell.messageSketchLabel setText:@"[语音]"];
    } else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]) {
        [cell.messageSketchLabel setText:@"[位置]"];
    }else {
        [cell.messageSketchLabel setText:@"[不支持消息]"];
    }
    cell.timeLabel.text = [self ConvertChatMessageTime:model.sentTime/1000];
    
    cell.model = model;
    return cell;
}

-(NSString*)ConvertChatMessageTime:(long long)secs{
    NSString *timeText=nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs/1000];
    
    //    DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM:dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString* strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    }else if([strMsgDay isEqualToString:strYesterday]){
        [formatter setDateFormat:@"昨天"];
    }
    else
    {
        [formatter setDateFormat:@"MM-dd"];
    }
    timeText = [formatter stringFromDate:messageDate];
    
    return timeText;
}

#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if (message.conversationType == ConversationType_PRIVATE) {
//    if ([message.content isMemberOfClass:[RCMessageContent class]]) {

        RCMessageContent *_contactNotificationMsg = (RCMessageContent *)message.content;
 
        NSDictionary *dic = @{
                              @"user_id_strs":message.targetId,
                            };
        [[RequestManager shareRequestManager] searchUserCListDtoByUserIds:dic viewController:self successData:^(NSDictionary *result) {
//             NSLog(@"searchUserCListDtoByUserIds---didReceiveMessageNotification--->%@",result);
            if (IsSucess(result) == 1) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
                if(array != nil){
                    NSDictionary *resultDic = array[0];
                    ConversantionUserInfo *rcduserinfo_ = [ConversantionUserInfo new];
                    rcduserinfo_.c_name =  resultDic[@"c_name"];
                    rcduserinfo_.userId =  [NSString stringWithFormat:@"%d",[resultDic[@"user_id"] intValue]];
                    rcduserinfo_.user_id_str = resultDic[@"user_id_str"];
                    rcduserinfo_.c_photo = resultDic[@"c_photo"];
                    NSString *companyStr = resultDic[@"c_short_company_name"];
                    NSString *jobStr = resultDic[@"c_jobtitle"];
                    if( companyStr== nil){
                        rcduserinfo_.c_short_company_name = @"";
                    }else{
                        rcduserinfo_.c_short_company_name = companyStr;
                    }
                    if (jobStr== nil){
                        rcduserinfo_.c_jobtitle = @"";
                    }else{
                        rcduserinfo_.c_jobtitle = jobStr;
                    }
                    
                    RCConversationModel *customModel = [RCConversationModel new];
                    customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
                    customModel.extend = rcduserinfo_;
                    customModel.conversationType = message.conversationType;
                    customModel.targetId = message.targetId;
                    customModel.sentTime = message.sentTime;
                    customModel.receivedTime = message.receivedTime;
                    customModel.senderUserId = message.senderUserId;
                    customModel.lastestMessage = _contactNotificationMsg;
                    
                    NSDictionary *userinfoDic = @{
                                                  @"c_name":rcduserinfo_.c_name ,
                                                  @"user_id":rcduserinfo_.userId,
                                                  @"user_id_str":rcduserinfo_.user_id_str,
                                                  @"c_photo":rcduserinfo_.c_photo ,
                                                  @"c_short_company_name":rcduserinfo_.c_short_company_name ,
                                                  @"c_jobtitle":rcduserinfo_.c_jobtitle
                                                  };
                    [[NSUserDefaults standardUserDefaults] setObject:userinfoDic forKey:message.targetId];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //调用父类刷新未读消息数
                        [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
                        [self notifyUpdateUnreadMessageCount];
                        
                        //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                        //原因请查看super didReceiveMessageNotification的注释。
                        NSNumber *left = [notification.userInfo objectForKey:@"left"];
                        if (0 == left.integerValue) {
                            [super refreshConversationTableViewIfNeeded];
                        }
                    });
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
    } else {
        //调用父类刷新未读消息数
        [super didReceiveMessageNotification:notification];
    }
}


-(UIView *)whoSeeMyHomePageView{
    if (_whoSeeMyHomePageView == nil) {
        _whoSeeMyHomePageView = [UIView new];
        _whoSeeMyHomePageView.backgroundColor = BGColorGray;
        _whoSeeMyHomePageView.frame = CGRectMake(0, 0, kScreenWidth, 70*AUTO_SIZE_SCALE_X);
        
        UIView *whoSeeMyHomePageBGView = [UIView new];
        whoSeeMyHomePageBGView.frame = CGRectMake(0, 0, kScreenWidth, 60*AUTO_SIZE_SCALE_X);
        
        whoSeeMyHomePageBGView.backgroundColor = [UIColor whiteColor];
        UIImageView *seeMeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_icon_see_me"]];
        seeMeImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X);
        
        UILabel *_nameLabel = [UILabel new];
        [_nameLabel setFont:[UIFont systemFontOfSize:17.f*AUTO_SIZE_SCALE_X]];
        [_nameLabel setTextColor:FontUIColorBlack];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"谁看过我";
        _nameLabel.frame = CGRectMake(65*AUTO_SIZE_SCALE_X, 0, 100*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X);
        
      
        countLabel = [UILabel new];
        [countLabel setFont:[UIFont systemFontOfSize:17.f*AUTO_SIZE_SCALE_X]];
        [countLabel setTextColor:FontUIColor999999Gray];
        countLabel.textAlignment = NSTextAlignmentRight;
        
        countLabel.frame = CGRectMake(kScreenWidth -69*AUTO_SIZE_SCALE_X, 19.5*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_more"]];
        arrowImageView.frame = CGRectMake(kScreenWidth-24*AUTO_SIZE_SCALE_X, 22.5*AUTO_SIZE_SCALE_X, 9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    
        [whoSeeMyHomePageBGView addSubview:seeMeImageView];
        [whoSeeMyHomePageBGView addSubview:_nameLabel];
        [whoSeeMyHomePageBGView addSubview:countLabel];
        [whoSeeMyHomePageBGView addSubview:arrowImageView];
        [_whoSeeMyHomePageView addSubview:whoSeeMyHomePageBGView];
        
        _whoSeeMyHomePageView.userInteractionEnabled = YES;
        whoSeeMyHomePageBGView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *collect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotowhoSeeMyHomePageBGView)];
        [whoSeeMyHomePageBGView addGestureRecognizer:collect];
    }
    return _whoSeeMyHomePageView;
}

-(void)gotowhoSeeMyHomePageBGView{
    WhoSeeMyHomePagViewController *vc = [[WhoSeeMyHomePagViewController alloc] init];
    vc.title = @"谁看过我";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMessagePage];
   
}

- (void) viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMessagePage];
  
}
-(void)viewDidAppear:(BOOL)animated{
    [self countUserViewNum];
}
@end
