//
//  QuestDetailViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/17.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestDetailViewController.h"
#import "YYText.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "DetailTableViewCell.h"
#import "DetailTableViewCell+DetailModel.h"
#import "AnswerViewController.h"
#import "noWifiView.h"
#import "DetailCellModel.h"
#import "CommonMenuView.h"
#import "YZTagList.h"
#import "noAnswerTableViewCell.h"
#import "DetailTableViewCell.h"
#import "DetailTableCellFrame.h"
#import "inviteExpertViewController.h"
#import "TagListViewController.h"
#import "ComplainViewController.h"
#import "AnswerDetailViewController.h"
#import "SharedView.h"
#import "NSString+textStringToSize.h"
#import "PersonalHomePageViewController.h"

@interface QuestDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,SelectSharedTypeDelegate,DetailTableHeaderViewDelegate>{
    NSInteger _sort_type;
    int current_page;
    int total_count;
    
    NSMutableArray *sortedDataArray;
    NSDictionary *result1,*result2;
    NSError *error1,*error2;
    
    UILabel *sortedLabel;
    UIImageView *arrowImageView;
    NSInteger myAnswer_id;
}

@property (nonatomic,strong) UIView *tagView;
@property (nonatomic,strong) UIView *tableviewHeaderView;
@property (nonatomic,strong) UIView *tableviewHeaderbgView;
@property (nonatomic,strong) UILabel *questionTitleLabel;
@property (nonatomic,strong) YYLabel *questionContentTextView;
@property (nonatomic,strong) UILabel *collectionLabel;
@property (nonatomic,strong) UILabel *answerNumLabel;
@property (nonatomic,strong) UIButton *sortedButton;
@property (nonatomic,strong) UIButton *collectionButton;
@property (nonatomic,strong) UIButton *inviteExpertButton;
@property (nonatomic,strong) UIButton *AnswerButton;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIImageView *expertImageView;
@property (nonatomic,strong) UILabel *expertLabel;
@property (nonatomic,strong) UIView *bottomToExpertView;
@property (nonatomic, strong)UIImageView *lineImageView,*topImageView;
@property (nonatomic,strong) BaseTableView *baseTableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) noWifiView *failView;
@property (nonatomic,strong) NSMutableArray *tagArray;

@end

@implementation QuestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgation];
    [self initSubViews];
    [self initSortedMenuview];
}

-(void)goBack{
    [super goBack];
}

-(void)initSubViews{
    [self.view addSubview:self.baseTableView];
    self.baseTableView.hidden = YES;
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.bottomToExpertView];
    [self.view addSubview:self.failView];
}

-(void)initUIView{
    self.baseTableView.hidden = NO;
    [self.baseTableView setTableHeaderView:self.tableviewHeaderView];
    if (IsSucess(result1) == 1) {
        NSDictionary *dtoDictionary = result1[@"data"][@"result"];
        if (![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil) {
            NSArray *array = dtoDictionary[@"tagList"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.tagArray removeAllObjects];
                [self.tagArray addObjectsFromArray:array];
                if (self.tagArray.count > 0) {
                    self.tagView.frame = CGRectMake(0, 0, kScreenWidth-24*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.frame = CGRectMake(kScreenWidth-24*AUTO_SIZE_SCALE_X, 14.5*AUTO_SIZE_SCALE_X, 9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
                    imageView.image = [UIImage imageNamed:@"list_icon_more"];
                    [self.tableviewHeaderbgView addSubview:imageView];
                    UITapGestureRecognizer *tagGesturetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTagSView:)];
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:tagGesturetap];
                    [self initTagListView:self.tagArray superView:self.tagView];
                    
                    
                    self.tagView.hidden = NO;
                }else{
                    self.tagView.frame = CGRectMake(0, 0, 0, 0);
                    self.tagView.hidden = YES;
                }
            }
            self.questionTitleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, self.tagView.frame.size.height+5*AUTO_SIZE_SCALE_X ,kScreenWidth-30*AUTO_SIZE_SCALE_X, 0);
            self.questionTitleLabel.text = dtoDictionary[@"question_content"];
            [self.questionTitleLabel sizeToFit];
            self.questionTitleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, self.tagView.frame.size.height+5*AUTO_SIZE_SCALE_X ,kScreenWidth-30*AUTO_SIZE_SCALE_X, self.questionTitleLabel.frame.size.height);
            
            
            
            
            self.questionContentTextView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                                            self.questionTitleLabel.frame.origin.y + self.questionTitleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X ,
                                                            kScreenWidth-30*AUTO_SIZE_SCALE_X,
                                                            0);
            
            
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            
            NSString *title =dtoDictionary[@"question_content_supplemented"];
            CGSize questTitleSize = [NSString sizeWithText:title maxSize:CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, MAXFLOAT) font:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
            
            CGFloat questTitleHeight = questTitleSize.height > 60*AUTO_SIZE_SCALE_X ? 60*AUTO_SIZE_SCALE_X : questTitleSize.height;
            
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
            self.questionContentTextView.attributedText = text;
            self.questionContentTextView.textColor = FontUIColor757575Gray;
            UIFont *font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
            text.yy_font = font;
            [self addSeeMoreButton];
            
            self.collectionLabel.text  = [NSString stringWithFormat:@"%@人收藏",dtoDictionary[@"question_collect_count"]];
            self.answerNumLabel.text  = [NSString stringWithFormat:@"%@个回答",dtoDictionary[@"question_answer_count"]];
            
            // 我在问题中的状态 1可以回答 2邀请专家回答（问题的提问者是我本人） 3查看我的回答（我已经回答过了）
            NSInteger mystatue = [dtoDictionary[@"myState"] integerValue];
            NSInteger isCollected = [dtoDictionary[@"isCollected"] integerValue];
            if(isCollected == 1){
                self.collectionButton.selected = YES;
            }else{
                self.collectionButton.selected = NO;
            }
            if (mystatue == 1) {
                self.bottomView.hidden = NO;
            }
            if (mystatue == 2) {
                self.bottomToExpertView.hidden = NO;
            }
            if (mystatue == 3) {
                self.bottomView.hidden = NO;
                [self.AnswerButton setTitle:@"查看我的回答" forState:UIControlStateNormal];
                myAnswer_id = [dtoDictionary[@"myAnswer_id"] integerValue];
            }
            
            self.questionContentTextView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                                            self.questionTitleLabel.frame.origin.y + self.questionTitleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X ,
                                                            kScreenWidth-30*AUTO_SIZE_SCALE_X,
                                                            questTitleHeight);
            
            self.collectionLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.questionContentTextView.frame), kScreenWidth-30*AUTO_SIZE_SCALE_X, 42*AUTO_SIZE_SCALE_X);
            
            self.tableviewHeaderbgView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.collectionLabel.frame));
            
            self.answerNumLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,  CGRectGetMaxY(self.tableviewHeaderbgView.frame), kScreenWidth/2, 32);
            self.sortedButton.frame = CGRectMake(kScreenWidth-(48+30)*AUTO_SIZE_SCALE_X,  CGRectGetMaxY(self.tableviewHeaderbgView.frame), (48+30)*AUTO_SIZE_SCALE_X, 32);
            self.tableviewHeaderView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.answerNumLabel.frame));
        }
    }else{
        if (IsSucess(result1) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result1];
        }else{
            [[RequestManager shareRequestManager] resultFail:result1 viewController:self];
        }
    }
    if (IsSucess(result2) == 1) {
        current_page = [[[result2 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count = [[[result2 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        NSArray *array = [[result2 objectForKey:@"data"] objectForKey:@"list"];
        if(![array isEqual:[NSNull null]] && array !=nil){
            [self.data removeAllObjects];
            for (NSDictionary *dict in array) {
                DetailCellModel *detailCellModel = [DetailCellModel logisticsWithDict:dict];
                DetailTableCellFrame *detailTableCellFrame = [[DetailTableCellFrame alloc] init];
                detailTableCellFrame.questModel = detailCellModel;
                [self.data addObject:detailTableCellFrame];
            }
            
        }
        [self.baseTableView reloadData];
    }else{
        if (IsSucess(result2) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result2];
        }else{
            [[RequestManager shareRequestManager] resultFail:result2 viewController:self];
        }
    }
}

-(void)initTagListView:(NSArray *)tagsArray superView:(UIView *)parentView{
    // 创建标签列表
    YZTagList *tagList = [[YZTagList alloc] init];
    tagList.backgroundColor = [UIColor clearColor];
    //    _tagList = tagList;
    //
    //    // 点击标签，就会调用,点击标签，删除标签
    //    __weak typeof(_tagList) weakTagList = _tagList;
    //    _tagList.clickTagBlock = ^(NSString *tag){
    //        [weakTagList deleteTag:tag];
    //
    //    };
    tagList.tagbuttonEnable = NO;
    // 高度可以设置为0，会自动跟随标题计算
    tagList.frame = CGRectMake(0, 0, parentView.frame.size.width, 0);
    // 设置标签背景色
    tagList.tagBackgroundColor = FontUIColorF4F5F7Gray;
    // 设置标签颜色
    tagList.tagColor = FontUIColorBlack;
    // 设置标签删除图片
    //    tagList.tagDeleteimage = [UIImage imageNamed:@"chose_tag_close_icon"];
    [parentView addSubview:tagList];
    for (NSDictionary *tagDic in tagsArray) {
        NSString *tagNameStr = tagDic[@"tag_content"];
        if (tagNameStr.length > 8) {
            [tagList addTag:[tagNameStr substringWithRange:NSMakeRange(0, 8)]];
        }else{
            [tagList addTag:tagNameStr];
        }
    }
    parentView.frame = CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y, parentView.frame.size.width, tagList.frame.size.height);
}

-(void)didSelectHeaderGotoHomePage:(NSInteger)userID{
    [self gotoPersonalHomePageView:userID];
}

-(void)gotoPersonalHomePageView:(NSInteger)userid{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = userid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    result1 = result2 = nil;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第1个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic0 = @{@"question_id":[NSString stringWithFormat:@"%ld",self.question_id],};
        [[RequestManager shareRequestManager] getQuestionDetail:dic0 viewController:self successData:^(NSDictionary *result){
            result1= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error1 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 将第2个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *dic1 = @{
                               @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],
                               @"_sort_type":@"1",
                               @"_currentPage":@"",
                               @"_pageSize":@""
                               };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] searchAnswerDtosByQuestionId:dic1 viewController:self successData:^(NSDictionary *result){
            result2= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error2 = error;
//            NSLog(@"失败请求数据");
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        
        
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (result1==nil||result2==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                self.failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
        }else{
//            NSLog(@"成功请求数据=1=======getQuestionDetail=======:%@",result1);
//            NSLog(@"成功请求数据=2=======searchAnswerDtosByQuestionId====:%@",result2);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.failView.hidden = YES;
                [self initUIView];
                [LZBLoadingView dismissLoadingView];
            });
        }
    });
}

- (void)reloadButtonClick:(UIButton *)sender {
    result2 = result1 = nil;
    [self loadData];
}

-(void)loadListData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = total_count = 0;
    NSDictionary *dic = @{
                          @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],
                          @"_sort_type":[NSString stringWithFormat:@"%ld",_sort_type],
                          @"_currentPage":@"",
                          @"_pageSize":@""
                          };
//    NSLog(@"dic----------------->%@",dic);
    [[RequestManager shareRequestManager] searchAnswerDtosByQuestionId:dic viewController:self successData:^(NSDictionary *result){
        if (IsSucess(result) == 1) {
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    [self.data removeAllObjects];
                    for (NSDictionary *dict in array) {
                        DetailCellModel *detailCellModel = [DetailCellModel logisticsWithDict:dict];
                        DetailTableCellFrame *detailTableCellFrame = [[DetailTableCellFrame alloc] init];
                        detailTableCellFrame.questModel = detailCellModel;
                        [self.data addObject:detailTableCellFrame];
                    }
                    [self.baseTableView reloadData];
                    if (self.data.count == total_count || self.data.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        self.failView.hidden = NO;
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

- (void)giveMeMoreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    NSDictionary *dic = @{
                          @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],
                          @"_sort_type":[NSString stringWithFormat:@"%ld",_sort_type],
                          @"_currentPage":page,
                          @"_pageSize":@""
                          };
//    NSLog(@"dic----------------->%@",dic);
    [[RequestManager shareRequestManager] searchAnswerDtosByQuestionId:dic viewController:self successData:^(NSDictionary *result){
        if (IsSucess(result) == 1) {
            [self.baseTableView.mj_footer endRefreshing];
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    [self.data removeAllObjects];
                    for (NSDictionary *dict in array) {
                        DetailCellModel *detailCellModel = [DetailCellModel logisticsWithDict:dict];
                        DetailTableCellFrame *detailTableCellFrame = [[DetailTableCellFrame alloc] init];
                        detailTableCellFrame.questModel = detailCellModel;
                        [self.data addObject:detailTableCellFrame];
                    }
                    [self.baseTableView reloadData];
                    if (self.data.count == total_count || self.data.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [self.baseTableView.mj_footer endRefreshing];
        self.failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)gotoTagSView:(id)sender{
//    NSLog(@"gotoTagSView");
    TagListViewController *vc = [[TagListViewController alloc] init];
    vc.question_id = self.question_id;
    vc.title =@"所属标签";
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)shareClick:(UIButton *)sender{
//    NSLog(@"shareClick");
//     flag 0 没有删除 flag 1有删除
    NSDictionary *dic = @{@"title" :self.questionTitleLabel.text,
                          @"desc" :[NSString stringWithFormat:@"你已经有%@快来看看吧",self.answerNumLabel.text],
                          @"image":[UIImage imageNamed:@"logo-login"],
                          @"url"  :[NSString stringWithFormat:@"%@/%@",@"question",[NSString stringWithFormat:@"%ld",self.question_id]]};
    SharedView *sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    sharedView.fromWhereFlag = ShareTypeFromQuestionDetail;
    
    sharedView.delegate = self;
    sharedView.currentVC = self;
    sharedView.question_id = self.question_id;
    [sharedView initPublishContent:dic FlagWithDeleButton:1];
}

- (void)SelectSharedTypeDelegateReturnPage:(ShareType)returnShareType{
//    NSLog(@"SelectSharedTypeDelegateReturnPage-------");
    if (returnShareType == ShareTypeReport) {
        NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (userID) {
            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                ComplainViewController *vc = [[ComplainViewController alloc] init];
                vc.feedback_kind = 1;
                vc.reportType = 3;
                vc.reportFromID = self.question_id;
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

-(void)inviteButtonOnclick:(id)sender{
//    NSLog(@"inviteButtonOnclick");
    
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            inviteExpertViewController *vc = [[inviteExpertViewController alloc] init];
            vc.title = @"邀请专家回答";
            
            vc.question_id = self.question_id ;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
             [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        }
    }else{
         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    }
}

-(void)collectionClick:(UIButton *)sender{
    sender.enabled = NO;
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            NSDictionary *dic = @{@"question_id":[NSString stringWithFormat:@"%ld",self.question_id],};
            if (sender.selected) {
                [[RequestManager shareRequestManager] cancelCollectQuestion:dic viewController:self successData:^(NSDictionary *result){
                    if (IsSucess(result) == 1) {
                        sender.selected = !sender.selected;
                        [[RequestManager shareRequestManager] tipAlert:@"取消收藏" viewController:self];
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        }
                    }
                    sender.enabled = YES;
                }failuer:^(NSError *error){
                    sender.enabled = YES;
                }];
            }else{
                [[RequestManager shareRequestManager] collectQuestion:dic viewController:self successData:^(NSDictionary *result){
                    if (IsSucess(result) == 1) {
                        sender.selected = !sender.selected;
                         [[RequestManager shareRequestManager] tipAlert:@"收藏成功" viewController:self];
                        
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        }
                    }
                    sender.enabled = YES;
                }failuer:^(NSError *error){
                    sender.enabled = YES;
                }];
            }
        }else{
            sender.enabled = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        }
    }else{
        sender.enabled = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    }
}

-(void)ButtonOnclick:(UIButton *)sender{
    [self popMenu:CGPointMake(sender.frame.origin.x+24*AUTO_SIZE_SCALE_X,kNavHeight+CGRectGetMaxY(sender.frame))];
}

- (void)popMenu:(CGPoint)point{
    self.sortedButton.selected = !self.sortedButton.selected;
    if (self.sortedButton.selected) {
        [CommonMenuView showMenuAtPoint:point];
    }else{
        [CommonMenuView hidden];
    }
}

-(void)AnswerButtonOnClick:(UIButton *)sender{
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            if([sender.titleLabel.text isEqualToString:@"查看我的回答"]){
                AnswerDetailViewController * vc = [[AnswerDetailViewController alloc] init];
                vc.answer_id = myAnswer_id;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                AnswerViewController * vc = [[AnswerViewController alloc] init];
                vc.question_id =self.question_id;
                vc.title = @"回答问题";
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    }
}

-(void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIImage *goBackImage = nil;
    goBackImage =[UIImage imageNamed:@"detail_pages_btn_return"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:goBackImage forState:UIControlStateNormal];
    [backButton sizeToFit];
    //点击事件
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [leftBackItem setTitle:@""];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.data.count > 0) {
        return [self.data count];
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.data.count > 0) {
        DetailTableCellFrame *detailTableCellFrame =  [self.data objectAtIndex:indexPath.row];
        return detailTableCellFrame.rowHeight;
    }else{
        return kScreenHeight-kNavHeight -self.tableviewHeaderView.frame.size.height -kTabHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.data.count > 0) {
        DetailTableViewCell *cell = [DetailTableViewCell userStatusCellWithTableView:tableView];
        DetailTableCellFrame *detailTableCellFrame =  [self.data objectAtIndex:indexPath.row];
        cell.detailTableViewFrame = detailTableCellFrame;
        cell.delegate = self;
        return  cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noAnswerTableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noAnswerTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *nameLabel =[[UILabel alloc] init];
        [cell addSubview:nameLabel];
        nameLabel.frame = CGRectMake(0, 111*AUTO_SIZE_SCALE_X, kScreenWidth, 20*AUTO_SIZE_SCALE_X);
        nameLabel.font =[UIFont systemFontOfSize:14];
        nameLabel.backgroundColor =[UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = FontUIColor757575Gray;
        nameLabel.text = @"还没有人回答，赶紧来发表下您的观点吧";
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.data.count > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailTableCellFrame *detailTableCellFrame =  [self.data objectAtIndex:indexPath.row];
        AnswerDetailViewController * vc = [[AnswerDetailViewController alloc] init];
        vc.answer_id = detailTableCellFrame.questModel.answer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)initSortedMenuview{
    NSDictionary *dict1 = @{
                            @"selectFlag" : @"1",
                            @"itemName" : @"点赞排序"
                            };
    NSDictionary *dict2 = @{
                            @"selectFlag" : @"0",
                            @"itemName" : @"时间排序"
                            };
    NSArray *dataArray = @[dict1,dict2];
    sortedDataArray = [NSMutableArray arrayWithArray:dataArray];
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认140，高度自适应
     */
    [CommonMenuView clearMenu];
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:sortedDataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        
        if (tag == 2) {
            _sort_type = 0;
        }
        if (tag == 1) {
            _sort_type = 1;
        }
        [self loadListData];
        
        for (int i = 0; i< sortedDataArray.count; i++) {
            NSString *itemName   = sortedDataArray[i][@"itemName"];
            if (tag -1 == i) {
                NSDictionary *dict3 = @{
                                        @"selectFlag" : @"1",
                                        @"itemName" : itemName
                                        };
                [sortedDataArray replaceObjectAtIndex:i withObject:dict3];
                sortedLabel.text = itemName;
            }else{
                NSDictionary *deselectdic = @{
                                              @"selectFlag" : @"0",
                                              @"itemName" : itemName
                                              };
                [sortedDataArray replaceObjectAtIndex:i withObject:deselectdic];
            }
        }
        [CommonMenuView hidden];
        [CommonMenuView updateMenuItemsWith:sortedDataArray];
        self.sortedButton.selected = !self.sortedButton.selected;
    } backViewTap:^{
        self.sortedButton.selected = !self.sortedButton.selected;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kQuestionDetailPage];
}
-(void)viewDidAppear:(BOOL)animated{
     [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kQuestionDetailPage];
}

-(UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [UIView new];
        _bottomView.frame = CGRectMake(0, kScreenHeight-kTabHeight, kScreenWidth, kTabHeight);
        [_bottomView addSubview:self.collectionButton];
        [_bottomView addSubview:self.AnswerButton];
        [_bottomView addSubview:self.inviteExpertButton];
        self.inviteExpertButton.frame = CGRectMake(self.collectionButton.frame.size.width, 0, kScreenWidth-self.collectionButton.frame.size.width-self.AnswerButton.frame.size.width, kTabHeight);
        
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

-(UIButton *)collectionButton{
    if (_collectionButton == nil) {
        _collectionButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionButton.frame = CGRectMake(0, 0, 78*AUTO_SIZE_SCALE_X, kTabHeight);
        _collectionButton.backgroundColor = [UIColor whiteColor];
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _collectionButton.imageEdgeInsets = UIEdgeInsetsMake(16, 25, 16, 36);
        
        //设置button正常状态下的图片
        [_collectionButton setImage:[UIImage imageNamed:@"detail_pages_btn_collection_normal"] forState:UIControlStateNormal];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        //设置button正常状态下的标题颜色
        [_collectionButton setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        
        [self.collectionButton setImage:[UIImage imageNamed:@"detail_pages_btn_collection_selected"] forState:UIControlStateSelected];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateSelected];
        [_collectionButton setTitleColor:RedUIColorC1 forState:UIControlStateSelected];
        //button标题的偏移量，这个偏移量是相对于图片的
        _collectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, (17+8), 0, 0);
        
        _collectionButton.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [_collectionButton addTarget:self
                              action:@selector(collectionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionButton;
}

-(UIButton *)inviteExpertButton{
    if (_inviteExpertButton == nil) {
        _inviteExpertButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        
        _inviteExpertButton.backgroundColor = [UIColor whiteColor];
        //设置button正常状态下的图片
        
        [_inviteExpertButton setImage:[UIImage imageNamed:@"question_icon_invitation_to_answer"] forState:UIControlStateNormal];
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _inviteExpertButton.imageEdgeInsets = UIEdgeInsetsMake(16, 25, 16, 89);
        
        [_inviteExpertButton setTitle:@"邀请回答" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _inviteExpertButton.titleEdgeInsets = UIEdgeInsetsMake(0, (17+8), 0, 0);
        //设置button正常状态下的标题颜色
        [_inviteExpertButton setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        _inviteExpertButton.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _inviteExpertButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_inviteExpertButton addTarget:self
                              action:@selector(inviteButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteExpertButton;
}

-(UIButton *)AnswerButton{
    if (_AnswerButton == nil) {
        _AnswerButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _AnswerButton.frame = CGRectMake(kScreenWidth-166*AUTO_SIZE_SCALE_X, 0, 166*AUTO_SIZE_SCALE_X, kTabHeight);
        _AnswerButton.backgroundColor = RedUIColorC1;
//        //设置button正常状态下的图片
//        [_AnswerButton setImage:[UIImage imageNamed:@"detail_pages_btn_collection_normal"] forState:UIControlStateNormal];
//        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
//        _AnswerButton.imageEdgeInsets = UIEdgeInsetsMake(16, 25, 16, 39);
        [_AnswerButton setTitle:@"立刻回答" forState:UIControlStateNormal];
//        //button标题的偏移量，这个偏移量是相对于图片的
//        _inviteExpertButton.titleEdgeInsets = UIEdgeInsetsMake(0, _collectionButton.imageView.size.width+8, 0, 0);
//        //设置button正常状态下的标题颜色
        [_AnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _AnswerButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_AnswerButton addTarget:self
                                action:@selector(AnswerButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _AnswerButton;
}

-(UIView *)bottomToExpertView{
    if (_bottomToExpertView == nil) {
        _bottomToExpertView = [UIView new];
        _bottomToExpertView.frame = CGRectMake(0, kScreenHeight-kTabHeight, kScreenWidth, kTabHeight);
        [_bottomToExpertView addSubview:self.expertImageView];
        [_bottomToExpertView addSubview:self.expertLabel];
        UITapGestureRecognizer *collect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inviteButtonOnclick:)];
        _bottomToExpertView.userInteractionEnabled = YES;
        [_bottomToExpertView addGestureRecognizer:collect];
        [_bottomToExpertView addSubview:self.lineImageView];
        _bottomToExpertView.hidden = YES;
    }
    return _bottomToExpertView;
}

-(UIImageView *)expertImageView{
    if (_expertImageView == nil) {
        _expertImageView = [UIImageView new];
        _expertImageView.image = [UIImage imageNamed:@"question_icon_invitation_to_answer"];
        _expertImageView.frame = CGRectMake(133*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X);
    }
    return _expertImageView;
}

-(UILabel *)expertLabel{
    if (_expertLabel == nil ) {
        _expertLabel = [CommentMethod createLabelWithText:@"邀请专家回答" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:14];
        _expertLabel.frame = CGRectMake(158*AUTO_SIZE_SCALE_X, 18.5*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
    }
    return _expertLabel;
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _baseTableView.bounces = YES;
                __weak __typeof(self) weakSelf = self;
        
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        _baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadListData];
        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
    }
    return _baseTableView;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        _lineImageView.frame = CGRectMake(0, 0*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5*AUTO_SIZE_SCALE_X);
    }
    return _lineImageView;
}


-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight - kTabHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

-(UIView *)tableviewHeaderView{
    if (_tableviewHeaderView == nil) {
        _tableviewHeaderView = [UIView new];
        _tableviewHeaderView.backgroundColor = BGColorGray;
        [_tableviewHeaderView addSubview:self.tableviewHeaderbgView];
        [self.tableviewHeaderbgView addSubview:self.tagView];
        [self.tableviewHeaderbgView addSubview:self.questionTitleLabel];
        [self.tableviewHeaderbgView addSubview:self.questionContentTextView];
        [self.tableviewHeaderbgView addSubview:self.collectionLabel];
        [self.tableviewHeaderView addSubview:self.answerNumLabel];
        [self.tableviewHeaderView addSubview:self.sortedButton];
    }
    return _tableviewHeaderView;
}

-(UIView *)tableviewHeaderbgView{
    if (_tableviewHeaderbgView == nil) {
        _tableviewHeaderbgView = [UIView new];
        _tableviewHeaderbgView.backgroundColor = [UIColor whiteColor];
    }
    return _tableviewHeaderbgView;
}

-(UILabel *)questionTitleLabel{
    if (_questionTitleLabel == nil) {
        _questionTitleLabel = [[UILabel alloc] init];
        _questionTitleLabel.font =  [UIFont boldSystemFontOfSize:20*AUTO_SIZE_SCALE_X];
        _questionTitleLabel.backgroundColor = [UIColor whiteColor];
        _questionTitleLabel.textAlignment =NSTextAlignmentLeft;
        _questionTitleLabel.textColor = FontUIColorBlack;
        _questionTitleLabel.text =@"";
        _questionTitleLabel.numberOfLines = 0;
    }
    return _questionTitleLabel;
}

-(UILabel *)collectionLabel{
    if (_collectionLabel == nil) {
        _collectionLabel = [[UILabel alloc] init];
        _collectionLabel.font =  [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _collectionLabel.textAlignment =NSTextAlignmentLeft;
        _collectionLabel.textColor = FontUIColor757575Gray;
        
        _collectionLabel.backgroundColor = [UIColor whiteColor];
    }
    return _collectionLabel;
}

-(UILabel *)answerNumLabel{
    if (_answerNumLabel == nil) {
        _answerNumLabel = [[UILabel alloc] init];
        _answerNumLabel.font =  [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _answerNumLabel.textAlignment =NSTextAlignmentLeft;
        _answerNumLabel.textColor = FontUIColor999999Gray;
        
    }
    return _answerNumLabel;
}

-(UIButton *)sortedButton{
    if (_sortedButton == nil) {
        _sortedButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        sortedLabel = [UILabel new];
        sortedLabel.text = @"点赞排序";
        sortedLabel.textColor = FontUIColor757575Gray;
        sortedLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        sortedLabel.frame = CGRectMake(0, 0, 50*AUTO_SIZE_SCALE_X, 32);
        [_sortedButton addSubview:sortedLabel];
        
        arrowImageView = [UIImageView new];
        arrowImageView.image = [UIImage imageNamed:@"question_icon_sort"];
        arrowImageView.frame = CGRectMake( 50*AUTO_SIZE_SCALE_X+5, 11, 10, 10);
        [_sortedButton addSubview:sortedLabel];
        [_sortedButton addSubview:arrowImageView];
        [_sortedButton addTarget:self
                          action:@selector(ButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortedButton;
}

-(UIView *)tagView{
    if (_tagView == nil) {
        _tagView = [UIView new];
        _tagView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tagGesturetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTagSView:)];
        _tagView.userInteractionEnabled = YES;
        [_tagView addGestureRecognizer:tagGesturetap];
    }
    return _tagView;
}

-(YYLabel *)questionContentTextView{
    if (_questionContentTextView == nil) {
        _questionContentTextView = [YYLabel new];
        _questionContentTextView.userInteractionEnabled =YES;
        _questionContentTextView.numberOfLines =0;
        _questionContentTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _questionContentTextView.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        
        _questionContentTextView.textColor = FontUIColorGray;
    }
    return _questionContentTextView;
}

- (void)addSeeMoreButton {
    __weak typeof(self) _self =self;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...展开"];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    
    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        YYLabel *label = _self.questionContentTextView;

        [label sizeToFit];
        
        
        self.collectionLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.questionContentTextView.frame), kScreenWidth-30*AUTO_SIZE_SCALE_X, 42*AUTO_SIZE_SCALE_X);
        
        self.tableviewHeaderbgView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.collectionLabel.frame));
        
        self.answerNumLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,  CGRectGetMaxY(self.tableviewHeaderbgView.frame), kScreenWidth/2, 32);
         self.sortedButton.frame = CGRectMake(kScreenWidth-(50+30)*AUTO_SIZE_SCALE_X,  CGRectGetMaxY(self.tableviewHeaderbgView.frame), (50+30)*AUTO_SIZE_SCALE_X, 32);
        self.tableviewHeaderView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.answerNumLabel.frame));
       
        [self.baseTableView setTableHeaderView:self.tableviewHeaderView];
    };
    [text yy_setColor:FontUIColorGray range:NSMakeRange(0,text.string.length-2)];
    [text yy_setFont:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X] range:NSMakeRange(text.string.length-2,2)];
    [text yy_setColor:UIColorFromRGB(0x2288FF) range:[text.string rangeOfString:@"展开"]];
   
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"展开"]];
    
    text.yy_font = _self.questionContentTextView.font;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    _self.questionContentTextView.truncationToken = truncationToken;
}

-(NSMutableArray *)tagArray{
    if (_tagArray == nil) {
        _tagArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tagArray;
}
@end
